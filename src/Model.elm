module Model exposing (..)

import UserModel exposing (UserModel, defaultUserModel)
import LeaguesModel exposing (LeaguesModel, defaultLeaguesModel)
import Navigation exposing (..)

-- MODEL

type alias Model =
  {
    userModel : UserModel
  , leaguesModel : LeaguesModel
  , navigation : Navigation
  , error : String
}

defaultModel : Model
defaultModel =
    { userModel = defaultUserModel
    , leaguesModel = defaultLeaguesModel
    , navigation = Navigation.Home
    , error = ""
  }
