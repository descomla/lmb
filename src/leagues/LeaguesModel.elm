module LeaguesModel exposing (LeaguesModel, defaultLeaguesModel
  , getCurrentLeague, getCurrentLeagueName, setCurrentLeague
  , setLeagues
  , setLeagueFormData, clearLeagueFormData
  , setLeaguesSortState, setLeaguesFilter
  , setTournaments)

import Table exposing (State)

import League exposing (League, Leagues, compareLeagueId, defaultLeague, getLeague)
import LeagueFormData exposing (LeagueFormData, defaultLeagueFormData)

import Tournaments exposing (Tournaments)

--
-- Leagues Model
--
type alias LeaguesModel =
  { sortState : Table.State -- table current sort
  , leagueFilter : String -- search text by name
  , leagueForm : LeagueFormData
  , teamFilter : String -- search team by name
  , currentLeague_id : Int
  , leagues : Leagues
  , tournaments : Tournaments
  }

defaultLeaguesModel : LeaguesModel
defaultLeaguesModel =
  { sortState = Table.initialSort "name"
  , leagueFilter = ""
  , leagueForm = defaultLeagueFormData
  , teamFilter = ""
  , currentLeague_id = 0
  , leagues = []
  , tournaments = []
  }

-- get the current league
getCurrentLeague : LeaguesModel -> Maybe League
getCurrentLeague model =
  getLeague model.currentLeague_id model.leagues

-- get the current league name
getCurrentLeagueName : LeaguesModel -> Maybe String
getCurrentLeagueName model =
  case getCurrentLeague model of
    Nothing -> Nothing
    Just league -> Just league.name

-- set the current league
setCurrentLeague : League -> LeaguesModel -> LeaguesModel
setCurrentLeague league model =
  { model | currentLeague_id = league.id }

-- set the current league
setLeagues : Leagues -> LeaguesModel -> LeaguesModel
setLeagues ligues model =
  { model | leagues = ligues }

-- update the league form data
setLeagueFormData : LeagueFormData -> LeaguesModel -> LeaguesModel
setLeagueFormData data model =
  { model | leagueForm = data }

-- Toggle show/hide form
clearLeagueFormData : LeaguesModel -> LeaguesModel
clearLeagueFormData model =
  { model | leagueForm = defaultLeagueFormData }


-- update the league table sorting state
setLeaguesSortState : Table.State -> LeaguesModel -> LeaguesModel
setLeaguesSortState state model =
  { model | sortState = state }

-- update the league table filter
setLeaguesFilter : String -> LeaguesModel -> LeaguesModel
setLeaguesFilter s model =
  { model | leagueFilter = s }

-- set Tournaments Data
setTournaments : Tournaments -> LeaguesModel -> LeaguesModel
setTournaments tournois model =
  { model | tournaments = tournois }
