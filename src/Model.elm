module Model exposing (Model, initModel)

import Browser.Navigation exposing (..)
import Url exposing (..)
import Time exposing (Posix, Zone)

import Route exposing (..)
import SessionModel exposing (Session, defaultSession)
import SessionInput exposing (..)
import LeaguesModel exposing (LeaguesModel, defaultLeaguesModel)

-- MODEL
type alias Model =
  { route : Route
  , key : Browser.Navigation.Key
  , zone : Time.Zone
  , time : Time.Posix
  , session : Session
  , currentLeague : String
  , sessionInput : SessionInput
  , leaguesModel : LeaguesModel
  , error : String
  }

initModel : Url.Url -> Browser.Navigation.Key -> Model
initModel url key =
    { route = parseURL url
    , key = key
    , zone = Time.utc
    , time = (Time.millisToPosix 0)
    , session = defaultSession
    , currentLeague = ""
    , sessionInput = defaultSessionInput
    , leaguesModel = defaultLeaguesModel
    , error = ""
  }
