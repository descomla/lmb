module Actions exposing (..)

import Model exposing (..)
import User exposing (..)
import Navigation exposing (..)


type Msg
  = NoOp
  | NavigationHome
  | NavigationPlayers
  | NavigationTeams
  | NavigationCurrentLeague
  | NavigationOthersLeagues
  | NavigationHelp
  | LoginChange String
  | PasswordChange String
  | Login
  | Logout

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
      ( { model | inputLogin = s }, Cmd.none)
    PasswordChange s ->
      ( { model | inputPswd = s }, Cmd.none)
    Login ->
      let
        newUser = { status = Connected
        , login = model.inputLogin
        , firstName = ""
        , lastName = ""
        }
      in
        ( { model | user = newUser }, Cmd.none)
    Logout ->
      let
        newUser = { status = Undefined
        , login = ""
        , firstName = ""
        , lastName = ""
        }
      in
        ( { model | user = newUser }, Cmd.none)
