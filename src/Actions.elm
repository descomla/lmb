module Actions exposing (..)

import Model exposing (..)
import UserModel exposing (..)
import UserStatus exposing (..)
import UserActionError exposing (..)
import Msg exposing (..)
import Navigation exposing (..)

import Http exposing (..)

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
      -- let
      --   newUserModel = login model.userModel
      -- in
      --   ( { model | userModel = newUserModel }, Cmd.none )
      let
        url = "http://localhost:3000/users?login=" ++ model.userModel.userInput.login ++ "&password=" ++ model.userModel.userInput.password
      in
        ( model, Http.send OnLoginResult (Http.get url decoderUserProfile) )

    OnLoginResult result ->
      let
        newModel = case result of
          Ok connectedUser ->
              { profile = connectedUser
                , status = Connected
                , userInput = defaultUserConnectionInput
                , userError = NoError
                , users = model.userModel.users }
          Err error ->
              { profile = defaultUserProfile
                , status = NotConnected
                , userInput = defaultUserConnectionInput
                , userError = ProfileNotFound
                , users = model.userModel.users }
      in
        ( { model | userModel = newModel }, Cmd.none)
    Logout ->
      let
        newUserModel = logout model.userModel
      in
        ( { model | userModel = newUserModel }, Cmd.none )
