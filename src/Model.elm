module Model exposing (..)

import UserModel exposing (UserModel, defaultUserModel)
import Navigation exposing (..)

-- MODEL

type alias Model =
  {
    userModel : UserModel
  , currentLeague : String -- current lmb league
  , navigation : Navigation
  , error : String
}

defaultModel : Model
defaultModel =
    { userModel = defaultUserModel
    , currentLeague = "LMB 2016-2017"
    , navigation = Navigation.Home
    , error = ""
  }
