module Actions exposing (..)

import Http exposing (..)

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
import Navigation exposing (..)
import LeaguesPages exposing (..)
import LeaguesModel exposing (..)
import UserModel exposing (..)

import LinkToJS exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)
    InitTime time ->
      (model, Cmd.none)
    TickTime time ->
      (model, Cmd.none)
    --
    -- Récupération de l'URL
    --
    UrlChange route ->
      ( { model  | route = route }, Navigation.newUrl (route2URL route) )
    LocationChange location ->
      ( { model  | route = parseURL location }, Cmd.none )
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
          ( { model | error = (toString err) }, Cmd.none )
    DeleteLeague league_id ->
      ( model, LinkToJS.requestDeleteLeagueConfirmation (toString league_id) )
    ConfirmDeleteLeague s ->
      let
        result = String.toInt s
      in
        case result of
          Ok league_id ->
            deleteLeague (league_id) model
          Err err ->
            ( { model | error = (toString err) }, Cmd.none )
    OnDeletedLeagueResult result ->
      case result of
        Ok _ ->
          ( model, LeaguesController.requestLeagues )
        Err err ->
          ( { model | error = (toString err) }, Cmd.none )
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
      ( model, LinkToJS.requestDeleteTournamentConfirmation (toString tournament_id) )
    ConfirmDeleteTournament s ->
      let
        result = String.toInt s
        tournament_id =
          case result of
            Ok l ->
              l
            Err err ->
              0
      in
        deleteTournament (tournament_id) model
    OnCreateTournamentResult result ->
      ( model, Cmd.none )
    OnDeletedTournamentResult result ->
      case result of
        Ok _ ->
          ( model, LeaguesController.requestLeagues )
        Err err ->
          ( { model | error = (toString err) }, Cmd.none )
    {--

    GLOBAL HTTP ERROR

    --}
    HttpFail err ->
        ( { model | error = toString err }, Cmd.none)

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
          url = databaseUsersUrl ++ "?login=" ++ model.sessionInput.login ++ "&password=" ++ model.sessionInput.password
        in
          ( { model | sessionInput = (clearSessionError input) }, Http.send OnLoginResult (Http.get url decoderUserProfiles) )
      -- Réponse du serveur sur demande de connection
      OnLoginResult result ->
        case result of
          Ok userList -> -- the list must contain only one user
            if List.isEmpty userList then
              let --> if empty => it is a login or password error
                result = { input | error = WrongLoginOrPassword }
              in -- update model for error display
                ( { model | sessionInput = result }, Cmd.none )
            else
              let --> if not empty =we assume there is only one (the head) > clear error
                result = updateSessionUser session (Maybe.withDefault defaultUserProfile (List.head userList))
              in -- update model & clear Error
                ( { model | session = result }, Cmd.none )
          Err error -> --> connection error
              let
                result = { input | error = (HttpError (toString error)) }
              in -- update model for error display
                ( { model | sessionInput = result }, CmdExtra.createCmd (HttpFail error))
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
