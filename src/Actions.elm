module Actions exposing (..)

import Model exposing (..)

import CmdExtra exposing (createCmd)

import UserController exposing (..)
import LeaguesController exposing (..)

import Msg exposing (..)
import Navigation exposing (..)
import LeaguesPages exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)
    CurrentLeagueLoaded result ->
      case result of
        Ok league ->
          let
            lm1 = model.leaguesModel
            lm2 = { lm1 | currentLeague = league }
          in
            ( { model | leaguesModel = lm2 }, Cmd.none )
        Err error ->
          (model, CmdExtra.createCmd (HttpFail error))
    {--

    NAVIGATION

    --}
    NavigationHome ->
      ( { model | navigation = Navigation.Home }, Cmd.none)
    NavigationPlayers ->
      ( { model | navigation = Navigation.Players }, Cmd.none)
    NavigationTeams ->
      ( { model | navigation = Navigation.Teams }, Cmd.none)
    NavigationCurrentLeague ->
      ( { model | navigation = (Navigation.CurrentLeague LeaguesPages.Default) }, LeaguesController.requestLeagues)
    NavigationOthersLeagues ->
      ( { model | navigation = (Navigation.OthersLeagues LeaguesPages.Default) }, LeaguesController.requestLeagues)
    NavigationCreateLeague ->
      ( { model | navigation = (Navigation.OthersLeagues LeaguesPages.CreateLeague) }, Cmd.none)
    NavigationCreateTournament id_league ->
      if id_league == model.leaguesModel.currentLeague.id then
        ( { model | navigation = (Navigation.CurrentLeague (LeaguesPages.CreateTournament id_league) ) }, Cmd.none)
      else
        ( { model | navigation = (Navigation.OthersLeagues (LeaguesPages.CreateTournament id_league) ) }, Cmd.none)
    NavigationHelp ->
      ( { model | navigation = Navigation.Help }, Cmd.none)
    {--

    LOGIN

    --}
    LoginChange s ->
      updateUserModel msg model
    PasswordChange s ->
      updateUserModel msg model
    OnProfilesLoaded result ->
      updateUserModel msg model
    Login ->
      updateUserModel msg model
    OnLoginResult result ->
      updateUserModel msg model
    Logout ->
      updateUserModel msg model
    {--

    LEAGUES

    --}
    LeaguesLoaded result ->
      updateLeagueInModel msg model
    LeaguesTournamentItemLoaded league_id result ->
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
    LeagueFormCreate ->
      createLeagueInModel model
    OnCreateLeagueResult result ->
      case result of
        Ok league ->
          ( model, LeaguesController.requestLeagues )
        Err err ->
          ( { model | error = (toString err) }, Cmd.none )
    OnEditLeague i ->
      --updateLeagueInModel msg model
      ( model, Cmd.none )
    OnDeleteLeague i ->
      --updateLeagueInModel msg model
      ( model, Cmd.none )
    {--

    TOURNAMENTS

    --}
    OnEditTournament i ->
      --updateLeagueInModel msg model
      ( model, Cmd.none )
    OnDeleteTournament i ->
      --deleteLeagueModel msg model
      ( model, Cmd.none )
    {--

    GLOBAL HTTP ERROR

    --}
    HttpFail err ->
        ( { model | error = toString err }, Cmd.none)


updateUserModel : Msg -> Model -> (Model, Cmd Msg)
updateUserModel msg model =
  let
    (umodel, cmd) = UserController.update msg model.userModel
  in
    ( { model | userModel = umodel }, cmd )

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
      in
      ( { model | leaguesModel = nlm }, Cmd.none)
    else
      ( { model | error = err }, Cmd.none )

updateLeagueInModel : Msg -> Model -> (Model, Cmd Msg)
updateLeagueInModel msg model =
  let
    (lmodel, cmd) = LeaguesController.update msg model.leaguesModel
  in
    ( { model | leaguesModel = lmodel }, cmd )
