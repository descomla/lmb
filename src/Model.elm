module Model exposing (..)

import UserModel exposing (UserModel, defaultUserModel)
import LeaguesModel exposing (LeaguesModel, defaultLeaguesModel)
import TournamentsModel exposing (Tournament, defaultTournament)
import Navigation exposing (..)

-- MODEL

type alias Model =
  {
    userModel : UserModel
  , leaguesModel : LeaguesModel
  , tournament : Tournament
  , navigation : Navigation
  , error : String
}

defaultModel : Model
defaultModel =
    { userModel = defaultUserModel
    , leaguesModel = defaultLeaguesModel
    , tournament = defaultTournament
    , navigation = Navigation.Home
    , error = ""
  }
