module Model exposing (Model, defaultModel)

import Route exposing (..)
import SessionModel exposing (Session, defaultSession)
import SessionInput exposing (..)
import LeaguesModel exposing (LeaguesModel, defaultLeaguesModel)

-- MODEL
type alias Model =
  { route : Route
  , session : Session
  , currentLeague : String
  , sessionInput : SessionInput
  , leaguesModel : LeaguesModel
  , error : String
  }

defaultModel : Model
defaultModel =
    { route = Home
    , session = defaultSession
    , currentLeague = ""
    , sessionInput = defaultSessionInput
    , leaguesModel = defaultLeaguesModel
    , error = ""
  }
