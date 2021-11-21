module Model exposing (Model, initModel, clearError, clearTeamFilter)

import Browser.Navigation exposing (..)
import Url exposing (..)
import Time exposing (Posix, Zone)

import Route exposing (..)
import Session exposing (Session, defaultSession)
import SessionInput exposing (..)
import LeaguesModel exposing (LeaguesModel, defaultLeaguesModel)

-- MODEL
type alias Model =
  { route : Route
  , key : Browser.Navigation.Key
  , zone : Time.Zone
  , time : Time.Posix
  , session : Session
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
    , sessionInput = defaultSessionInput
    , leaguesModel = defaultLeaguesModel
    , error = ""
  }

--
--
-- CLEAR TEAM FILTER
--
--
clearTeamFilter : Model -> Model
clearTeamFilter model =
  let
    initial = model.leaguesModel
    result = { initial | teamFilter = "" }
  in
    { model | leaguesModel = result }



--
-- Clear error
--
clearError : Model -> Model
clearError model =
  { model | error = "" }
