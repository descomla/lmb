module LeaguesModel exposing (LeaguesModel, defaultLeaguesModel
  , getCurrentLeague, getCurrentLeagueName, setCurrentLeague
  , getLeague, setLeagues
  , setLeagueFormData, clearLeagueFormData
  , setLeaguesSortState, setLeaguesFilter
  , getLeagueTournaments, setTournaments)

import Table exposing (State)

import League exposing (League, Leagues, compareLeagueId, defaultLeague)
import LeagueFormData exposing (LeagueFormData, defaultLeagueFormData)

import Teams exposing (Teams)
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
  , teams : Teams
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
  , teams = []
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
setLeagues ligues model =
  { model | leagues = ligues }

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

-- get Tournaments Data for a specific league
getLeagueTournaments : League -> LeaguesModel -> Tournaments
getLeagueTournaments league model = -- filter the full tournaments list
  --with the tournaments id of the league
  List.filter (\t -> t.league_id == league.id ) model.tournaments

-- set Tournaments Data
setTournaments : Tournaments -> LeaguesModel -> LeaguesModel
setTournaments tournois model =
  { model | tournaments = tournois }
