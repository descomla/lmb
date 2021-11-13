module Actions exposing (..)

import Http exposing (..)
import Url exposing (..)
import Browser exposing (..)
import Browser.Navigation exposing (..)

import Model exposing (..)
import Route exposing (..)
import SessionError exposing (..)

import Addresses exposing (..)

import CmdExtra exposing (createCmd)

import SessionController exposing (..)
import LeaguesController exposing (..)
import TournamentsController exposing (..)
import UserDecoder exposing (decoderUserProfiles)

import Msg exposing (..)
import LeaguesPages exposing (..)
import LeaguesModel exposing (..)
import UserModel exposing (..)

import LinkToJS exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)
    AdjustZone z ->
      ( { model | zone = z }, Cmd.none)
    TickTime t ->
      ( { model | time = t }, Cmd.none)
    --
    -- Récupération de l'URL
    --
    RouteChanged route ->
      ( { model  | route = route }, Browser.Navigation.pushUrl model.key (route2URL route) )
    UrlChanged url ->
      ( { model  | route = parseURL url }, Cmd.none )
    LinkClicked urlRequest ->
      let
        r = Debug.log "LinkClicked " urlRequest
      in
      case urlRequest of
        Browser.Internal url ->
          ( model, Browser.Navigation.pushUrl model.key (Url.toString url) )

        Browser.External href ->
          ( model, Browser.Navigation.load href )
    --
    -- Récupération de la ligue courante
    --
    CurrentLeagueLoaded result ->
      case result of
        Ok league ->
          ( { model | currentLeague = league.name }, Cmd.none )
        Err error ->
          (model, CmdExtra.createCmd (HttpFail error))
    {--
    --
    -- SESSION
    --
    --}
    SessionResult result ->
      updateSession model msg
    LoginChange s ->
      updateSession model msg
    PasswordChange s ->
      updateSession model msg
    Login ->
      updateSession model msg
    OnLoginResult result ->
      updateSession model msg
    Logout ->
      updateSession model msg

    {--
    --
    USERS
    --
    --}

    -- Récupération de la liste des profiles
    OnProfilesLoaded result ->
      ( model, Cmd.none ) --updateUserModel msg model

    {--
    --
    LEAGUES
    --
    --}
    LeaguesLoaded result ->
      updateLeagueInModel msg model
    LeaguesSortChange s ->
      updateLeagueInModel msg model
    LeaguesFilterChange s ->
      updateLeagueInModel msg model
    LeagueFormNameChange s ->
      updateLeagueForm msg model
    LeagueFormKindChange s ->
      updateLeagueForm msg model
    LeagueFormNbTournamentsChange s ->
      updateLeagueForm msg model
    DisplayLeague i ->
      ( model, Cmd.none )
    OpenLeagueForm i ->
      ( model, Cmd.none )
    ValidateLeagueForm ->
      createLeagueInModel model
    CancelLeagueForm ->
      ( model, Cmd.none )
    OnCreateLeagueResult result ->
      case result of
        Ok league -> -- TODO : nettoyer le formulaire qui a été validé
          ( { model | route = OthersLeagues }, LeaguesController.requestLeagues)
        Err err ->
          ( { model | error = (httpError2String err) }, Cmd.none )
    DeleteLeague league_id ->
      ( model, LinkToJS.requestDeleteLeagueConfirmation (String.fromInt league_id) )
    ConfirmDeleteLeague s ->
      case (String.toInt s) of
        Just league_id ->
          deleteLeague (league_id) model
        Nothing ->
          ( { model | error = "League_id reçu ("++s++") pour confirmation invalide !" }
            , Cmd.none )
    OnDeletedLeagueResult result ->
      case result of
        Ok _ ->
          ( model, LeaguesController.requestLeagues )
        Err err ->
          ( { model | error = (httpError2String err) }, Cmd.none )
    {--

    TOURNAMENTS

    --}
    TournamentsLoaded result ->
      updateLeagueInModel msg model
    DisplayTournament i ->
      ( model, Cmd.none )
    OpenTournamentForm i ->
      ( model, Cmd.none )
    ValidateTournamentForm ->
      ( model, Cmd.none )
    CancelTournamentForm ->
      ( model, Cmd.none )
    DeleteTournament tournament_id ->
      ( model
      , LinkToJS.requestDeleteTournamentConfirmation (String.fromInt tournament_id) )
    ConfirmDeleteTournament s ->
      case (String.toInt s) of
        Just tournament_id ->
          deleteTournament (tournament_id) model
        Nothing ->
          ( { model | error = "Tournament_id reçu ("++s++") pour confirmation invalide !" }
          , Cmd.none )
    OnCreateTournamentResult result ->
      ( model, Cmd.none )
    OnDeletedTournamentResult result ->
      case result of
        Ok _ ->
          ( model, LeaguesController.requestLeagues )
        Err err ->
          ( { model | error = (httpError2String err) }, Cmd.none )
    {--

    GLOBAL HTTP ERROR

    --}
    HttpFail err ->
        ( { model | error = httpError2String err }, Cmd.none)

--
--
-- UPDATE SESSION CONTROLLER
--
--
updateSession : Model -> Msg -> (Model, Cmd Msg)
updateSession model msg =
  let
      session = model.session
      input = model.sessionInput
  in
    case msg of
      -- Récupération des données de session
      SessionResult result ->
        case result of
          Ok s ->
            ( { model | session = s }, Cmd.none )
          Err error ->
            (model, CmdExtra.createCmd (HttpFail error))
      -- Login input changed by user
      LoginChange s ->
        let
            result = { input | login = s }
        in
          ( { model | sessionInput = result }, Cmd.none )
      -- Password input changed by user
      PasswordChange s ->
        let
            result = { input | password = s }
        in
          ( { model | sessionInput = result }, Cmd.none )
      -- Action de connection
      Login ->
        let
          cmd = requestLogin model.sessionInput
          result = clearSessionError model.sessionInput
        in
          ( { model | sessionInput = result }, cmd )
      -- Réponse du serveur sur demande de connection
      OnLoginResult result ->
        case result of
          Ok userList -> -- the list must contain only one user
            if List.isEmpty userList then
              let --> if empty => it is a login or password error
                r = { input | error = WrongLoginOrPassword }
              in -- update model for error display
                ( { model | sessionInput = r }, Cmd.none )
            else
              let --> if not empty =we assume there is only one (the head) > clear error
                r = updateSessionUser session (Maybe.withDefault defaultUserProfile (List.head userList))
              in -- update model & clear Error
                ( { model | session = r }, Cmd.none )
          Err error -> --> connection error
              let
                r = { input | error = (HttpError (httpError2String error)) }
              in -- update model for error display
                ( { model | sessionInput = r }, CmdExtra.createCmd (HttpFail error))
      -- Action de déconnection
      Logout ->
          ( { model | session = (clearSession model.session) }, Cmd.none )

      others ->
        ( model, Cmd.none )

createLeagueInModel : Model -> (Model, Cmd Msg)
createLeagueInModel model =
  let
    error = checkLeagueForm model.leaguesModel.leagueForm
  in
    if error == "" then
      let
        (lm, cmd) = LeaguesController.create model.leaguesModel
      in
        ( { model | leaguesModel = lm }, cmd )
    else
      ( { model | error = error }, Cmd.none )

deleteLeague : Int -> Model -> (Model, Cmd Msg)
deleteLeague league_id model =
  let
    (lm, cmd) = LeaguesController.delete league_id model.leaguesModel
  in
    ( { model | leaguesModel = lm }, cmd )
deleteTournament : Int -> Model -> (Model, Cmd Msg)
deleteTournament tournament_id model =
  let
    cmd = TournamentsController.delete tournament_id
  in
    ( model, cmd )


updateLeagueForm : Msg -> Model -> (Model, Cmd Msg)
updateLeagueForm msg model =
  let
    err = checkLeagueFormInput msg
  in
    if err == "" then
      let
        lf = LeaguesController.updateLeagueFormValue msg model.leaguesModel.leagueForm
        lm = model.leaguesModel
        nlm = { lm | leagueForm = lf}
        nm = { model | leaguesModel = nlm }
      in
      ( { nm | error = "" }, Cmd.none)
    else
      ( { model | error = err }, Cmd.none )

updateLeagueInModel : Msg -> Model -> (Model, Cmd Msg)
updateLeagueInModel msg model =
  let
    (lmodel, cmd) = LeaguesController.update msg model.leaguesModel
  in
    ( { model | leaguesModel = lmodel }, cmd )


httpError2String : Http.Error -> String
httpError2String error =
  case error of
    BadUrl s ->
      "Mauvaise URL (" ++ s ++ ")"
    Timeout ->
      "Timeout"
    NetworkError ->
      "Erreur réseau"
    BadStatus i ->
      "Mauvais statut"
    BadBody s ->
      "Erreur dans le corps de requête \n"++s
