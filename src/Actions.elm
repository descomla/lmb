module Actions exposing (..)

import Http exposing (..)
import Url exposing (..)
import Browser exposing (..)
import Browser.Navigation exposing (..)
import File exposing (File)
import File.Select as Select
import Task
import Date exposing (..)

import Msg exposing (..)
import Model exposing (Model, clearError, closeAllForms)
import Route exposing (..)
import Session exposing (updateSessionUser, clearSession)
import SessionInput exposing (clearPassword)

import DatabaseRequests exposing (..)

import CmdExtra exposing (createCmd)

import UserCodec exposing (decoderUserProfiles)

import League exposing (getLeague)
import LeagueType exposing (..)
import LeaguesModel exposing (..)
import LeagueFormData exposing (..)

import UserModel exposing (..)

import Tournaments exposing (getTournament, addTeam, removeTeam)
import TournamentsModel exposing (setTournaments, closePhaseForm, closePouleForm)
import TournamentsController exposing (updatePhaseForm, validatePhaseForm, validatePouleForm)

import Teams exposing (getTeam)
import TeamsModel exposing (..)
import TeamFormData exposing (..)

import PhaseForm exposing (convertPhase)
import LinkToJS exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case (Debug.log "update " msg) of
    NoOp -> -- Aucune activité
      (model, Cmd.none)
    AdjustZone z -> -- init Zone
      ( { model | zone = z }, Cmd.none)
    TickTime t -> -- every second
      ( { model | time = t }, Cmd.none)
    --
    -- Récupération de l'URL
    --
    RouteChanged route ->
      ( clearError { model | route = (Debug.log "RouteChanged " route) }, Browser.Navigation.pushUrl model.key (route2URL route) )
    UrlChanged url ->
      ( clearError { model | route = parseURL url }, Cmd.none )
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
      ( model, LinkToJS.requestDeleteLeagueConfirmation (LinkToJS.encode league_id) )
    -- League deletion confirmation received from user
    LeagueConfirmDelete s ->
      let
        league_id = LinkToJS.decode s
      in
        leagueConfirmDelete league_id model
    -- League request result
    LeagueResult result ->
      case result of
        Ok _ ->
          ( clearError { model | leaguesModel = clearLeagueFormData model.leaguesModel },
            DatabaseRequests.retrieveLeagues )
        Err err ->
          ( model, CmdExtra.createCmd (DatabaseRequestResult (HttpFail err)))
    {--

    TOURNAMENTS

    --}
    -- Récupération de la liste des tournois
    OnTournamentsLoaded result ->
      case result of
        Ok tournaments ->
          ( clearError
            { model | tournamentsModel = model.tournamentsModel |> setTournaments tournaments }
            , Cmd.none )
        Err err ->
          ( model, CmdExtra.createCmd (DatabaseRequestResult (HttpFail err)))
    -- Afficher le tournoi
    TournamentDisplay tournament_id ->
      tournamentDisplay tournament_id model
    -- Ajouter une équipe au tournoi
    TournamentAddTeam tournament_id team_id ->
      tournamentAddTeam tournament_id team_id model
    -- Supprimer une équipe au tournoi
    TournamentRemoveTeam tournament_id team_id ->
      ( model, LinkToJS.requestRemoveTournamentTeamConfirmation (LinkToJS.encode2 tournament_id team_id) )
    -- Supprimer une équipe au tournoi
    TournamentConfirmRemoveTeam s ->
      let
        (tournament_id, team_id) = LinkToJS.decode2 s
      in
        tournamentRemoveTeam tournament_id team_id model
    -- TournamentPhase form real-time input update
    TournamentPhaseFormEvent event ->
      let
        (tournamentsModel, error) =
          model.tournamentsModel |> TournamentsController.updatePhaseForm event
      in
        if error == "" then
          ( clearError { model | tournamentsModel = tournamentsModel }, Cmd.none )
        else
          ( { model | error = error }, Cmd.none )
    -- TournamentPhase form validation request
    TournamentPhaseValidateForm ->
      let
        (mb_tournament, error) =
           validatePhaseForm
            model.tournamentsModel.phaseForm
            model.tournamentsModel.tournaments
      in
        case mb_tournament of
          Nothing ->
            ( { model | error = error}, Cmd.none )
          Just tournament ->
            ( clearError model, DatabaseRequests.updateTournament tournament)
    -- TournamentPhase form cancel, error clear & close
    TournamentPhaseCancelForm ->
      ( { model | tournamentsModel = model.tournamentsModel |> closePhaseForm  }, Cmd.none )

    TournamentPhaseDelete tournament_id phase_id ->
      ( model, LinkToJS.requestDeletePhaseConfirmation (LinkToJS.encode2 tournament_id phase_id) )

    TournamentPhaseConfirmDelete s ->
      let
        (tournament_id, phase_id) = LinkToJS.decode2 s
      in
        phaseConfirmDelete tournament_id phase_id model
    -- Display the league form
    TournamentOpenForm i ->
      ( model, Cmd.none )-- TODO
    -- Tournament form validation request
    TournamentValidateForm ->
      ( model, Cmd.none )-- TODO
    -- Tournament form cancel, error clear & close
    TournamentCancelForm ->
      ( model, Cmd.none )-- TODO

    TournamentDelete tournament_id ->
      ( model, LinkToJS.requestDeleteTournamentConfirmation (LinkToJS.encode tournament_id) )

    TournamentConfirmDelete s ->
      let
        tournament_id = LinkToJS.decode s
      in
        tournamentConfirmDelete tournament_id model
    -- Tournament request result
    TournamentResult result ->
      case result of
        Ok _ ->
          ( clearError (closeAllForms model), DatabaseRequests.retrieveTournaments)
        Err err ->
          ( model, CmdExtra.createCmd (DatabaseRequestResult (HttpFail err)))
    {--

    TEAMS

    --}
    -- Récupération de la liste des équipes
    OnTeamsLoaded result ->
      case (Debug.log "Teams Loaded " result) of
        Ok teams ->
          ( clearError { model | teamsModel = (setTeams teams model.teamsModel) }
            , Cmd.none )
        Err err ->
          ( model, CmdExtra.createCmd (DatabaseRequestResult (HttpFail err)))
    TeamFilterNameChange s ->
      let
        teams_model = model.teamsModel
        newModel = { teams_model | teamFilter = s }
      in
        ( { model | teamsModel = newModel }, Cmd.none )
    TeamOpenForm team_id ->
      if (Debug.log "TeamOpenForm #" team_id) == 0 then -- Creation form
        ( clearError { model | teamsModel = displayTeamFormData model.teamsModel }, Cmd.none )
      else -- Edition form
        let
          -- Recherche de l'équipe
          result = getTeam team_id model.teamsModel.teams
        in
          case result of
            Just team ->
              ( clearError { model | teamsModel = initTeamFormData team model.teamsModel }, Cmd.none )
            Nothing ->
              ( { model | error = ("Aucune équipe #" ++ (String.fromInt team_id) ++ " trouvée !!") } , Cmd.none )
    TeamValidateForm ->
      ( model,
        DatabaseRequests.validateTeamForm model.teamsModel.formData model.teamsModel.teams)
    TeamCancelForm ->
      ( clearError { model | teamsModel = clearTeamFormData model.teamsModel }, Cmd.none )-- TODO
    TeamFormNameChange s ->
      ( { model | teamsModel = setTeamFormName s model.teamsModel }, Cmd.none )
    TeamFormColorChange s ->
      ( { model | teamsModel = setTeamFormColor s model.teamsModel }, Cmd.none )
    TeamFormLogoChange s ->
      ( { model | teamsModel = setTeamFormLogo s model.teamsModel }, Cmd.none )
    TeamFormLogoUpload ->
      ( model, Select.file ["image/*"] TeamFormLogoGotFile )
    TeamFormLogoGotFile file ->
      ( model, Task.perform TeamFormLogoChange <| (File.toUrl file) )
    TeamFormPictureChange s ->
      ( { model | teamsModel = setTeamFormPicture s model.teamsModel }, Cmd.none )
    TeamFormPictureUpload ->
      ( model, Select.file ["image/*"] TeamFormPictureGotFile )
    TeamFormPictureGotFile file ->
      ( model, Task.perform TeamFormPictureChange <| (File.toUrl file) )
    -- Ask for team deletion to user
    TeamDelete team_id ->
      ( model, LinkToJS.requestDeleteTeamConfirmation (LinkToJS.encode team_id) )
    -- Team deletion confirmation received from user
    TeamConfirmDelete s ->
      let
        team_id = LinkToJS.decode s
      in
        let
          result = getTeam team_id model.teamsModel.teams
        in
          case result of
            Nothing ->
              ( { model | error = "L'équipe' #"++s++") n'existe pas !" }, Cmd.none )
            Just team ->
              ( clearError model, DatabaseRequests.deleteTeam team )
    TeamResult result ->
      case result of
        Ok _ ->
          ( clearError { model | teamsModel = clearTeamFormData model.teamsModel },
            DatabaseRequests.retrieveTeams )
        Err err ->
          ( model, CmdExtra.createCmd (DatabaseRequestResult (HttpFail err)))
    {--
    --
    -- Matchs
    --
    --}
    MatchPrint match_id -> -- match id
      ( model, Cmd.none) --TODO Print
    MatchPrintAll tournament_id phase_id ->
      ( model, Cmd.none) -- TODO Print
    {--
    --
    -- Poules
    --
    --}
    -- Display a poule
    PouleDisplay tournament_id phase_id poule_id ->
      ( model, Cmd.none) -- TODO PouleDisplay
    -- Poule Form Event
    PouleFormInput event ->
      let
        (tournamentsModel, error) =
          model.tournamentsModel |> TournamentsController.updatePouleForm event
      in
        if error == "" then
          ( clearError { model | tournamentsModel = tournamentsModel }, Cmd.none )
        else
          ( { model | error = error }, Cmd.none )
    -- Delete a poule
    PouleDelete tournament_id phase_id poule_id ->
      ( model, LinkToJS.requestDeletePouleConfirmation (LinkToJS.encode3 tournament_id phase_id poule_id) )
    -- Confirm delete of a poule
    PouleConfirmDelete s ->
      let
        (tournament_id, phase_id, team_id) = LinkToJS.decode3 s
      in
        pouleConfirmDelete tournament_id phase_id team_id model
    PouleValidateForm ->
      let
        (mb_tournament, error) =
           validatePouleForm model.tournamentsModel.pouleForm model.tournamentsModel.tournaments
      in
        case mb_tournament of
          Nothing ->
            ( { model | error = error }, Cmd.none )
          Just tournament ->
            ( clearError model, DatabaseRequests.updateTournament tournament)
    -- Poule form cancel, error clear & close
    PouleCancelForm ->
      ( { model | tournamentsModel = model.tournamentsModel |> closePouleForm  }, Cmd.none )

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
    LeagueOpenForm league_id ->
      let
        (mb_league, error) = getLeague league_id model.leaguesModel.leagues
      in
        case mb_league of
          Nothing ->
            ( { model | error = error }, Cmd.none )
          Just league ->
            ( clearError { model | leaguesModel =
                setLeagueFormData (LeagueFormData.fillFromLeague league) model.leaguesModel }, Cmd.none )
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
    others ->
      ( model, Cmd.none )

-- TournamentConfirmDelete tournament_id
tournamentConfirmDelete : Int -> Model -> (Model, Cmd Msg)
tournamentConfirmDelete tournament_id model =
  let
    (mb_tournament, error) = model.tournamentsModel.tournaments |> getTournament tournament_id
  in
    case mb_tournament of
      Nothing ->
        ( { model | error = error }, Cmd.none )
      Just tournament ->
        ( clearError model, DatabaseRequests.deleteTournament tournament )

-- TournamentDisplay tournament_id
tournamentDisplay : Int -> Model -> (Model, Cmd Msg)
tournamentDisplay tournament_id model =
  case model.route of
    CurrentLeague query ->
      ( model, CmdExtra.createCmd ( RouteChanged ( CurrentLeague (QueryTournament tournament_id) ) ) )
    OthersLeagues query ->
      let
        ( result, error ) = getTournament tournament_id model.tournamentsModel.tournaments
      in
        case result of
          Just tournament ->
            ( model, CmdExtra.createCmd ( RouteChanged ( OthersLeagues (QueryLeagueTournament tournament.league_id tournament_id) ) ) )
          Nothing ->
            ( { model | error = error }, Cmd.none )
    others ->
      ( { model | error = "Demande d'affichage du Tournoi #" ++ (String.fromInt tournament_id) ++ " depuis une mauvaise page!!" }, Cmd.none )


-- TournamentAddTeam tournament_id team_id
tournamentAddTeam : Int -> Int -> Model -> (Model, Cmd Msg)
tournamentAddTeam tournament_id team_id model =
  case (getTeam team_id model.teamsModel.teams) of
    Nothing -> ( { model | error = "Impossible d'ajouter l'équipe !!" }, Cmd.none )
    Just team ->
      let
        (mb_tournament, error) = model.tournamentsModel.tournaments |> getTournament tournament_id
      in
        case mb_tournament of
          Nothing -> ( { model | error = error }, Cmd.none )
          Just tournament ->
            if List.member team_id tournament.teams then
              ( { model | error = "L'équipe est déjà inscrite au tournoi !!" }, Cmd.none )
            else
              let
                updatedTournament = addTeam team tournament
              in
                ( { model | teamsModel = clearTeamFilter model.teamsModel },
                  DatabaseRequests.updateTournament updatedTournament )

-- TournamentAddTeam tournament_id team_id
tournamentRemoveTeam : Int -> Int -> Model -> (Model, Cmd Msg)
tournamentRemoveTeam tournament_id team_id model =
  case (getTeam team_id model.teamsModel.teams) of
    Nothing -> ( { model | error = "Impossible de retirer l'équipe !!" }, Cmd.none )
    Just team ->
      let
        (mb_tournament, error) = model.tournamentsModel.tournaments |> getTournament tournament_id
      in
        case mb_tournament of
          Nothing -> ( { model | error = error }, Cmd.none )
          Just tournament ->
            if List.member team_id tournament.teams then
              let
                updatedTournament = removeTeam team tournament
              in
                ( { model | teamsModel = clearTeamFilter model.teamsModel },
                  DatabaseRequests.updateTournament updatedTournament )
            else
              ( { model | error = "L'équipe n'est pas inscrite au tournoi !!" }, Cmd.none )

-- LeagueConfirmDelete
leagueConfirmDelete : Int -> Model -> (Model, Cmd Msg)
leagueConfirmDelete league_id model =
  let
    (mb_league, error) = getLeague league_id model.leaguesModel.leagues
  in
    case mb_league of
      Nothing ->
        ( { model | error = error }, Cmd.none )
      Just league ->
        ( clearError model, DatabaseRequests.deleteLeague league )

-- PouleConfirmDelete
pouleConfirmDelete : Int -> Int -> Int -> Model -> (Model, Cmd Msg)
pouleConfirmDelete tournament_id phase_id poule_id model =
  let
    (mb_tournament, error) = model.tournamentsModel.tournaments
      |> TournamentsController.deletePoule tournament_id phase_id poule_id
  in
    case mb_tournament of
      Nothing ->
        ( { model | error = error }, Cmd.none )
      Just tournament ->
        ( clearError model, DatabaseRequests.updateTournament tournament )

-- PhaseConfirmDelete
phaseConfirmDelete : Int -> Int -> Model -> (Model, Cmd Msg)
phaseConfirmDelete tournament_id phase_id model =
  let
    (mb_tournament, error) = model.tournamentsModel.tournaments
      |> TournamentsController.deletePhase tournament_id phase_id
  in
    case mb_tournament of
      Nothing ->
        ( { model | error = error }, Cmd.none )
      Just tournament ->
        ( clearError model, DatabaseRequests.updateTournament tournament )

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
