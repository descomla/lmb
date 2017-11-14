module Actions exposing (..)

import Model exposing (..)
import UserModel exposing (..)
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
      let
        newUserModel = { profile = model.userModel.profile
            , status = model.userModel.status
            , userInput = { login = s, password = model.userModel.userInput.password }
            , userError = model.userModel.userError
            , users = model.userModel.users }
      in
        ( { model | userModel = newUserModel }, Cmd.none)
    PasswordChange s ->
      let
        newUserModel = { profile = model.userModel.profile
            , status = model.userModel.status
            , userInput = { login = model.userModel.userInput.login, password = s }
            , userError = model.userModel.userError
            , users = model.userModel.users }
      in
        ( { model | userModel = newUserModel }, Cmd.none)
    HttpFail err ->
        ( { model | error = toString err }, Cmd.none)
    UserProfilesLoaded result ->
      case result of
        Ok profiles ->
          let
            newModel = { profile = model.userModel.profile
              , status = model.userModel.status
              , userInput = model.userModel.userInput
              , userError = model.userModel.userError
              , users = profiles }
          in
            ( { model | userModel = newModel }, Cmd.none)
        Err error ->
          ( { model | error = toString error }, Cmd.none)
    Login ->
      let
        newUserModel = login model.userModel
      in
        ( { model | userModel = newUserModel }, Cmd.none )
    Logout ->
      let
        newUserModel = logout model.userModel
      in
        ( { model | userModel = newUserModel }, Cmd.none )
