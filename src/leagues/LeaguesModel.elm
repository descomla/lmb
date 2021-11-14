module LeaguesModel exposing (LeaguesModel, defaultLeaguesModel
  , getCurrentLeague, getCurrentLeagueName, setCurrentLeague
  , getLeague, setLeagues
  , setLeagueFormData, clearLeagueFormData
  , setLeaguesSortState, setLeaguesFilter )

import Table exposing (State)

import League exposing (League, Leagues, compareLeagueId, defaultLeague)
import LeagueFormData exposing (LeagueFormData, defaultLeagueFormData)

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
getCurrentLeague : LeaguesModel -> League
getCurrentLeague model =
  getLeague model.currentLeague_id model

-- get the current league name
getCurrentLeagueName : LeaguesModel -> String
getCurrentLeagueName model =
  let
    league = getCurrentLeague model
  in
    league.name

-- set the current league
setCurrentLeague : League -> LeaguesModel -> LeaguesModel
setCurrentLeague league model =
  { model | currentLeague_id = league.id }

-- set the current league
setLeagues : Leagues -> LeaguesModel -> LeaguesModel
setLeagues l model =
  { model | leagues = l }

-- get the current league data
getLeague : Int -> LeaguesModel -> League
getLeague league_id model =
  let
    temp = List.filter (compareLeagueId league_id) model.leagues
  in
    if List.isEmpty temp then
      { defaultLeague | name = "Aucune ligue !" {--++ (debugString model)--} }
    else if (List.length temp) > 1 then
      { defaultLeague | name = "Trop de ligues !" }
    else
      Maybe.withDefault defaultLeague (List.head temp)

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
