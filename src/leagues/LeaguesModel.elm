module LeaguesModel exposing (LeaguesModel, defaultLeaguesModel
  , getCurrentLeague, getCurrentLeagueName, setCurrentLeague
  , setLeagues
  , setLeagueFormData, clearLeagueFormData
  , setLeaguesSortState, setLeaguesFilter)

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
  , currentLeague_id : Int
  , leagues : Leagues
  }

defaultLeaguesModel : LeaguesModel
defaultLeaguesModel =
  { sortState = Table.initialSort "name"
  , leagueFilter = ""
  , leagueForm = defaultLeagueFormData
  , currentLeague_id = 0
  , leagues = []
  }

-- get the current league
getCurrentLeague : LeaguesModel -> (Maybe League, String)
getCurrentLeague model =
  getLeague model.currentLeague_id model.leagues

-- get the current league name
getCurrentLeagueName : LeaguesModel -> (Maybe String, String)
getCurrentLeagueName model =
  let
    (mb_league, error) = getCurrentLeague model
  in
    case mb_league of
      Nothing -> (Nothing, error)
      Just league -> (Just league.name, "")

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
