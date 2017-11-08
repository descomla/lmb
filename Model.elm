module Model exposing (..)

import User exposing (..)
import Navigation exposing (..)

-- MODEL

type alias Model =
  {
    user : User
  , inputLogin : String
  , inputPswd : String
  , currentLeague : String -- current lmb league
  , navigation : Navigation
}

defaultModel : Model
defaultModel =
    { user = User.defaultUser
    , inputLogin = ""
    , inputPswd = ""
    , currentLeague = "LMB 2016-2017"
    , navigation = Navigation.Home
  }
