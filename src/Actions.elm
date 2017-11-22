module Actions exposing (..)

import Model exposing (..)

import UserController exposing (..)
import LeaguesController exposing (..)

import Msg exposing (..)
import Navigation exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)
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
      ( { model | navigation = Navigation.CurrentLeague }, Cmd.none)
    NavigationOthersLeagues ->
      ( { model | navigation = Navigation.OthersLeagues }, LeaguesController.requestLeagues)
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
      updateLeagueModel msg model
    LeaguesTournamentItemLoaded league_id result ->
      updateLeagueModel msg model
    LeaguesSortChange s ->
      updateLeagueModel msg model
    LeaguesFilterChange s ->
      updateLeagueModel msg model
    {--

    TOURNAMENTS

    --}
    EditTournament i ->
      updateLeagueModel msg model
    DeleteTournament i ->
      updateLeagueModel msg model
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

updateLeagueModel : Msg -> Model -> (Model, Cmd Msg)
updateLeagueModel msg model =
  let
    (lmodel, cmd) = LeaguesController.update msg model.leaguesModel
  in
    ( { model | leaguesModel = lmodel }, cmd )
