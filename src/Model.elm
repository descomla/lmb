module Model exposing (Model, initModel, clearError, closeAllForms)

import Browser.Navigation exposing (..)
import Url exposing (..)
import Time exposing (Posix, Zone)

import Route exposing (..)
import Session exposing (Session, defaultSession)
import SessionInput exposing (..)
import LeaguesModel exposing (LeaguesModel, defaultLeaguesModel, clearLeagueFormData)
import TournamentsModel exposing (TournamentsModel, defaultTournamentsModel, closeTournamentsForms)
import TeamsModel exposing (TeamsModel, defaultTeamsModel, clearTeamFormData)

-- MODEL
type alias Model =
  { route : Route
  , key : Browser.Navigation.Key
  , zone : Time.Zone
  , time : Time.Posix
  , session : Session
  , sessionInput : SessionInput
  , leaguesModel : LeaguesModel
  , tournamentsModel : TournamentsModel
  , teamsModel : TeamsModel
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
    , tournamentsModel = defaultTournamentsModel
    , teamsModel = defaultTeamsModel
    , error = ""
  }


--
-- Close all forms
--
closeAllForms : Model -> Model
closeAllForms model =
    { route = model.route
    , key = model.key
    , zone = model.zone
    , time = model.time
    , session = model.session
    , sessionInput = model.sessionInput
    , leaguesModel = clearLeagueFormData model.leaguesModel
    , tournamentsModel = closeTournamentsForms model.tournamentsModel
    , teamsModel = clearTeamFormData model.teamsModel
    , error = model.error
  }

--
-- Clear error
--
clearError : Model -> Model
clearError model =
  { model | error = "" }
