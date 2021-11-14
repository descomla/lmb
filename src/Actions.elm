module Actions exposing (..)

import Http exposing (..)
import Url exposing (..)
import Browser exposing (..)
import Browser.Navigation exposing (..)

import Msg exposing (..)
import Model exposing (..)
import Route exposing (..)
import SessionError exposing (..)

import Addresses exposing (..)

import CmdExtra exposing (createCmd)

import SessionController exposing (..)
import LeaguesController exposing (..)
import TournamentsController exposing (..)
import UserDecoder exposing (decoderUserProfiles)

import LeaguesPages exposing (..)
import LeagueType exposing (..)
import LeaguesModel exposing (..)
import LeagueFormData exposing (..)
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
      case (Debug.log "CurrentLeagueLoaded " result) of
        Ok league ->
          ( { model | leaguesModel = setCurrentLeague league model.leaguesModel }, Cmd.none )
        Err error ->
          (model, CmdExtra.createCmd (HttpFail error))
    {--
    --
    -- SESSION
    --
    --}
    SessionResult result ->
      update_session model msg
    LoginChange s ->
      update_session model msg
    PasswordChange s ->
      update_session model msg
    Login ->
      update_session model msg
    OnLoginResult result ->
      update_session model msg
    Logout ->
      update_session model msg

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

    -- Récupération de la liste des leagues
    OnLeaguesLoaded result ->
      case result of
        Ok leagues ->
          ( { model | leaguesModel = (setLeagues leagues model.leaguesModel) }
            , Cmd.none )
        Err err ->
          ( { model | error = (httpError2String err) }, Cmd.none )

    -- Display the league form
    LeagueOpenForm i ->
      update_league_form_data msg model
    -- League form real-time input update
    LeagueFormNameChange s ->
      update_league_form_data msg model
    -- League form real-time input update
    LeagueFormKindChange s ->
      update_league_form_data msg model
    -- League form real-time input update
    LeagueFormNbTournamentsChange s ->
      update_league_form_data msg model
    -- League form validation request
    LeagueValidateForm ->
      update_league_form_data msg model
    -- League form cancel, error clear & close
    LeagueCancelForm ->
      update_league_form_data msg model
    -- League form validation result & close (if ok)
    LeagueValidateFormResult result ->
      update_league_form_data msg model

    -- League table sort change
    LeagueSortChange s ->
      ( { model | leaguesModel = setLeaguesSortState s model.leaguesModel }, Cmd.none )
    -- League table filter change
    LeagueFilterChange s ->
      ( { model | leaguesModel = setLeaguesFilter s model.leaguesModel }, Cmd.none )

    -- Display a specific league
    LeagueDisplay i ->
    -- TODO set the query for displaying a league
    -- ( { model  | route = route }, Browser.Navigation.pushUrl model.key (route2URL route) )
      ( model, Cmd.none )

    -- Ask for league deletion to user
    LeagueDelete league_id ->
      ( model, LinkToJS.requestDeleteLeagueConfirmation (String.fromInt league_id) )
    -- League deletion confirmation received from user
    LeagueConfirmDelete s ->
      case (String.toInt s) of
        Nothing ->
          ( { model | error = "League_id reçu ("++s++") pour confirmation invalide !" }
            , Cmd.none )
        Just league_id ->
          let
            league = getLeague league_id model.leaguesModel
            ( m, c ) = LeaguesController.deleteLeague league model.leaguesModel
          in
            ( { model | leaguesModel = m }, c )
    LeagueDeleteResult result ->
      case result of
        Ok _ ->
          ( clearError model, LeaguesController.retrieveLeagues)
        Err err ->
          ( { model | error = (httpError2String err) }, Cmd.none )
    {--

    TOURNAMENTS

    --}
    TournamentsLoaded result ->
      ( model, Cmd.none ) -- TODO
    DisplayTournament i ->
      ( model, Cmd.none )-- TODO
    OpenTournamentForm i ->
      ( model, Cmd.none )-- TODO
    ValidateTournamentForm ->
      ( model, Cmd.none )-- TODO
    CancelTournamentForm ->
      ( model, Cmd.none )-- TODO
    DeleteTournament tournament_id ->
      ( model, Cmd.none )-- TODO
      --( model, LinkToJS.requestDeleteTournamentConfirmation (String.fromInt tournament_id) )
    ConfirmDeleteTournament s ->
      ( model, Cmd.none )-- TODO
{--      case (String.toInt s) of
        Just tournament_id ->
          deleteTournament (tournament_id) model
        Nothing ->
          ( { model | error = "Tournament_id reçu ("++s++") pour confirmation invalide !" }
          , Cmd.none )
--}
    OnCreateTournamentResult result ->
      ( model, Cmd.none )-- TODO
    OnDeletedTournamentResult result ->
      ( model, Cmd.none )-- TODO
{--      case result of
        Ok _ ->
          let
            ( m, c ) = LeaguesController.requestLeagues model.leaguesModel
          in
            ( { model | leaguesModel = m }, c )
        Err err ->
          ( { model | error = (httpError2String err) }, Cmd.none )
--}
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
update_session : Model -> Msg -> (Model, Cmd Msg)
update_session model msg =
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
          cmd = SessionController.requestLogin model.sessionInput
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

--
--
-- UPDATE LEAGUES FORM CONTROLLER
--
--
update_league_form_data : Msg -> Model -> (Model, Cmd Msg)
update_league_form_data msg model =
  case msg of
    -- Display the league form
    LeagueOpenForm i ->
      let
        league = getLeague i model.leaguesModel
        formData = fillFromLeague league
      in
        ( { model | leaguesModel = setLeagueFormData formData  model.leaguesModel }, Cmd.none )
    -- League form real-time input update
    LeagueFormNameChange s ->
      if String.isEmpty s then
        ({ model | error = "Le nom de la ligue ne doit pas être vide !" }, Cmd.none )
      else
        let
          formData = LeagueFormData.setName s model.leaguesModel.leagueForm
        in
          ({ model | leaguesModel = (setLeagueFormData formData model.leaguesModel) }, Cmd.none )
    LeagueFormKindChange s ->
      case (leagueTypeFromDatabaseString s) of
        Nothing ->
          ({ model | error = "Le type de ligue (" ++ s ++ ") est invalide !" }, Cmd.none )
        Just kind ->
          let
            formData = LeagueFormData.setKind kind model.leaguesModel.leagueForm
          in
            ({ model | leaguesModel = (setLeagueFormData formData model.leaguesModel) }, Cmd.none )
    LeagueFormNbTournamentsChange s ->
      case (String.toInt s) of
        Nothing ->
          ({ model | error = "Valeur '" ++ s ++ "' invalide !" }, Cmd.none )
        Just n ->
          let
            formData = LeagueFormData.setNbRanklingTournaments n model.leaguesModel.leagueForm
          in
            ({ model | leaguesModel = (setLeagueFormData formData model.leaguesModel) }, Cmd.none )
    -- League form validation request
    LeagueValidateForm ->
          let
            ( m, c ) = LeaguesController.validateLeagueForm model.leaguesModel.leagueForm  model.leaguesModel
          in
        ({ model | leaguesModel = m }, c )
    -- League form cancel, error clear & close
    LeagueCancelForm ->
      ({ model | leaguesModel = clearLeagueFormData model.leaguesModel }, Cmd.none )
    -- League form validation result & close (if ok)
    LeagueValidateFormResult result ->
      case result of
        Ok league ->
            ( clearError { model | leaguesModel = clearLeagueFormData model.leaguesModel }, LeaguesController.retrieveLeagues )
        Err err ->
          ( { model | error = (httpError2String err) }, Cmd.none )
    others ->
      ( model, Cmd.none )

--
-- Clear error
--
clearError : Model -> Model
clearError model =
  { model | error = "" }

--
-- Http Error conversion to displayed error string
--
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
