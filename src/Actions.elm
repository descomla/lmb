module Actions exposing (..)

import Model exposing (..)
import UserController exposing (..)
import Msg exposing (..)
import Navigation exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      (model, Cmd.none)
    NavigationHome ->
      ( { model | navigation = Navigation.Home }, Cmd.none)
    NavigationPlayers ->
      ( { model | navigation = Navigation.Players }, Cmd.none)
    NavigationTeams ->
      ( { model | navigation = Navigation.Teams }, Cmd.none)
    NavigationCurrentLeague ->
      ( { model | navigation = Navigation.CurrentLeague }, Cmd.none)
    NavigationOthersLeagues ->
      ( { model | navigation = Navigation.OthersLeagues }, Cmd.none)
    NavigationHelp ->
      ( { model | navigation = Navigation.Help }, Cmd.none)
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

    HttpFail err ->
        ( { model | error = toString err }, Cmd.none)

updateUserModel : Msg -> Model -> (Model, Cmd Msg)
updateUserModel msg model =
  let
    (umodel, cmd) = UserController.update msg model.userModel
  in
    ( { model | userModel = umodel }, cmd )
