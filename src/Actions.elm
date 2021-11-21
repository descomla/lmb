module Actions exposing (..)

import Http exposing (..)
import Url exposing (..)
import Browser exposing (..)
import Browser.Navigation exposing (..)

import Msg exposing (..)
import Model exposing (Model, clearError, clearTeamFilter)
import Route exposing (..)
import Session exposing (updateSessionUser, clearSession)
import SessionInput exposing (clearPassword)
import Tournaments exposing (getTournament, addTeam)
import Teams exposing (getTeam)

import DatabaseRequests exposing (..)

import CmdExtra exposing (createCmd)

import UserCodec exposing (decoderUserProfiles)

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
      ( clearError { model | route = (Debug.log "RouteChanged " route) }, Browser.Navigation.pushUrl model.key (route2URL route) )
    UrlChanged url ->
      ( clearError { model | route = (Debug.log "UrlChanged Route=" (parseURL (Debug.log "UrlChanged URL=" url))) }, Cmd.none )
    LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          ( model, Browser.Navigation.pushUrl model.key (Url.toString (Debug.log "LinkClicked internal " url) ) )

        Browser.External href ->
          ( model, Browser.Navigation.load (Debug.log "LinkClicked external " href) )
    --
    -- Récupération de la ligue courante
    --
    CurrentLeagueLoaded result ->
      case (Debug.log "CurrentLeagueLoaded " result) of
        Ok league ->
          ( clearError { model | leaguesModel = setCurrentLeague league model.leaguesModel }, Cmd.none )
        Err error ->
          (model, CmdExtra.createCmd (DatabaseRequestResult (HttpFail error)))
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
      ( clearError model, Cmd.none ) --updateUserModel msg model

    {--
    --
    LEAGUES
    --
    --}

    -- Récupération de la liste des leagues
    OnLeaguesLoaded result ->
      case result of
        Ok leagues ->
          ( clearError { model | leaguesModel = (setLeagues leagues model.leaguesModel) }
            , Cmd.none )
        Err err ->
          ( model, CmdExtra.createCmd (DatabaseRequestResult (HttpFail err)))

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
      ( clearError { model | leaguesModel = setLeaguesSortState s model.leaguesModel }, Cmd.none )
    -- League table filter change
    LeagueFilterChange s ->
      ( clearError { model | leaguesModel = setLeaguesFilter s model.leaguesModel }, Cmd.none )

    -- Display a specific league
    LeagueDisplay i ->
      case model.route of
        OthersLeagues s ->
          ( model, CmdExtra.createCmd ( RouteChanged ( OthersLeagues (QueryLeague i) ) ) )
        others ->
          ( model, Cmd.none  )

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
          in
            ( clearError model, DatabaseRequests.deleteLeague league )
    LeagueDeleteResult result ->
      case result of
        Ok _ ->
          ( clearError model, DatabaseRequests.retrieveLeagues)
        Err err ->
          ( model, CmdExtra.createCmd (DatabaseRequestResult (HttpFail err)))
    {--

    TOURNAMENTS

    --}
    -- Récupération de la liste des tournois
    TournamentsLoaded result ->
      case result of
        Ok tournaments ->
          ( clearError { model | leaguesModel = (setTournaments tournaments model.leaguesModel) }
            , Cmd.none )
        Err err ->
          ( model, CmdExtra.createCmd (DatabaseRequestResult (HttpFail err)))
    TournamentUpdateResult result ->
      (model, DatabaseRequests.retrieveTournaments)
    -- Afficher le tournoi
    TournamentDisplay tournament_id ->
      case model.route of
        CurrentLeague query ->
          ( model, CmdExtra.createCmd ( RouteChanged ( CurrentLeague (QueryTournament tournament_id) ) ) )
        OthersLeagues query ->
          let
            result = getTournament tournament_id model.leaguesModel.tournaments
          in
            case result of
              Just tournament ->
                ( model, CmdExtra.createCmd ( RouteChanged ( OthersLeagues (QueryLeagueTournament tournament.league_id tournament_id) ) ) )
              Nothing ->
                ( { model | error = ("Tournoi #" ++ String.fromInt tournament_id ++ " n'existe pas !!") }, Cmd.none )
        others ->
          ( { model | error = ("Demande d'affichage du Tournoi #" ++ String.fromInt tournament_id ++ " depuis une mauvaise page!!") }, Cmd.none )
    -- Ajouter une équipe au tournoi
    TournamentAddTeam tournament_id team_id ->
      case (getTeam team_id model.leaguesModel.teams) of
        Nothing -> ( { model | error = "Impossible d'ajouter l'équipe !!" }, Cmd.none )
        Just team ->
          case (getTournament tournament_id model.leaguesModel.tournaments) of
            Nothing -> ( { model | error = "Impossible d'ajouter l'équipe !!" }, Cmd.none )
            Just tournament ->
              let
                updatedTournament = addTeam team tournament
              in
                ( clearTeamFilter model, DatabaseRequests.updateTournament updatedTournament )
    TournamentOpenForm i ->
      ( model, Cmd.none )-- TODO
    TournamentValidateForm ->
      ( model, Cmd.none )-- TODO
    TournamentCancelForm ->
      ( model, Cmd.none )-- TODO
    TournamentDelete tournament_id ->
      ( model, LinkToJS.requestDeleteTournamentConfirmation (String.fromInt tournament_id) )
      --( model, LinkToJS.requestDeleteTournamentConfirmation (String.fromInt tournament_id) )
    TournamentConfirmDelete s ->
      ( model, Cmd.none )-- TODO
{--      case (String.toInt s) of
        Just tournament_id ->
          deleteTournament (tournament_id) model
        Nothing ->
          ( { model | error = "Tournament_id reçu ("++s++") pour confirmation invalide !" }
          , Cmd.none )
--}
    TournamentValidateResult result ->
      ( model, Cmd.none )-- TODO
    TournamentDeletedResult result ->
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
    TeamFilterNameChange s ->
      let
        leagues_model = model.leaguesModel
        newModel = { leagues_model | teamFilter = s }
      in
        ( { model | leaguesModel = newModel }, Cmd.none )
    {--

    GLOBAL HTTP ERROR

    --}
    DatabaseRequestResult result ->
      case result of
        InvalidLeagueType ->
          ( { model | error = "Type de league invalide!!" }, Cmd.none)
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
            ( clearError model, CmdExtra.createCmd (DatabaseRequestResult (HttpFail error)) )
      -- Login input changed by user
      LoginChange s ->
        let
            result = { input | login = s }
        in
          ( clearError { model | sessionInput = result }, Cmd.none )
      -- Password input changed by user
      PasswordChange s ->
        let
            result = { input | password = s }
        in
          ( clearError{ model | sessionInput = result }, Cmd.none )
      -- Action de connection
      Login ->
          ( { model | sessionInput = clearPassword model.sessionInput },
            DatabaseRequests.requestLogin model.sessionInput )
      -- Réponse du serveur sur demande de connection
      OnLoginResult result ->
        case result of
          Ok userList -> -- the list must contain only one user
            if List.isEmpty userList then
              --> if empty => it is a login or password error
              -- update model for error display
              ( { model | error = "Login ou Mot de passe erroné." }, Cmd.none )
            else
              let --> if not empty =we assume there is only one (the head) > clear error
                r = updateSessionUser session (Maybe.withDefault defaultUserProfile (List.head userList))
              in -- update model & clear Error
                ( clearError { model | session = r }, Cmd.none )
          Err error -> --> connection error
            ( model, CmdExtra.createCmd (DatabaseRequestResult (HttpFail error)))
      -- Action de déconnection
      Logout ->
          ( clearError { model | session = (clearSession model.session) }, Cmd.none )

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
        ( clearError { model | leaguesModel = setLeagueFormData formData  model.leaguesModel }, Cmd.none )
    -- League form real-time input update
    LeagueFormNameChange s ->
      if String.isEmpty s then
        ( { model | error = "Le nom de la ligue ne doit pas être vide !" }, Cmd.none )
      else
        let
          formData = LeagueFormData.setName s model.leaguesModel.leagueForm
        in
          ( clearError { model | leaguesModel = (setLeagueFormData formData model.leaguesModel) }, Cmd.none )
    LeagueFormKindChange s ->
      case (leagueTypeFromDatabaseString s) of
        Nothing ->
          ( { model | error = "Le type de ligue (" ++ s ++ ") est invalide !" }, Cmd.none )
        Just kind ->
          let
            formData = LeagueFormData.setKind kind model.leaguesModel.leagueForm
          in
            ( clearError { model | leaguesModel = (setLeagueFormData formData model.leaguesModel) }, Cmd.none )
    LeagueFormNbTournamentsChange s ->
      case (String.toInt s) of
        Nothing ->
          ( { model | error = "Valeur '" ++ s ++ "' invalide !" }, Cmd.none )
        Just n ->
          let
            formData = LeagueFormData.setNbRanklingTournaments n model.leaguesModel.leagueForm
          in
            ( clearError { model | leaguesModel = (setLeagueFormData formData model.leaguesModel) }, Cmd.none )
    -- League form validation request
    LeagueValidateForm ->
      ( clearError model, DatabaseRequests.validateLeagueForm model.leaguesModel.leagueForm  model.leaguesModel.leagues )
    -- League form cancel, error clear & close
    LeagueCancelForm ->
      ( clearError { model | leaguesModel = clearLeagueFormData model.leaguesModel }, Cmd.none )
    -- League form validation result & close (if ok)
    LeagueValidateFormResult result ->
      case result of
        Ok league ->
            ( clearError { model | leaguesModel = clearLeagueFormData model.leaguesModel },
              DatabaseRequests.retrieveLeagues )
        Err err ->
          ( { model | error = (httpError2String err) }, Cmd.none )
    others ->
      ( model, Cmd.none )

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
