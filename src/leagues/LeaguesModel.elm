module LeaguesModel
  exposing
    (LeaguesModel, defaultLeaguesModel, League, Leagues, defaultLeague, LeagueForm, defaultLeagueForm, fillForm, getCurrentLeague, getLeague)

import Table exposing (State)

import LeagueType exposing (..)
import TournamentsModel exposing (..)

type alias LeaguesModel =
  { sortState : Table.State -- table current sort
  , leagueFilter : String -- search text by name
  , leagues : Leagues
  , currentLeague : League
  , leagueForm : LeagueForm
  }

defaultLeaguesModel : LeaguesModel
defaultLeaguesModel =
  { sortState = Table.initialSort "name"
  , leagueFilter = ""
  , leagues = []
  , currentLeague = defaultLeague
  , leagueForm = defaultLeagueForm }

--
-- League
--
type alias League =
  { id : Int
  , name : String
  , kind : LeagueType
  , nbRankingTournaments: Int
  , tournaments : Tournaments
}

type alias Leagues = List League

defaultLeague : League
defaultLeague =
  { id = 0
  , name = ""
  , kind = SingleEvent
  , nbRankingTournaments = 0
  , tournaments = [] }

type alias LeagueForm =
  { id : Int
  , name : String
  , kind : Maybe LeagueType
  , nbRankingTournaments : Int }

defaultLeagueForm : LeagueForm
defaultLeagueForm =
  { id = 0
  , name = ""
  , kind = Nothing
  , nbRankingTournaments = 0 }

fillForm : League -> LeagueForm
fillForm league =
  { id = league.id
  , name = league.name
  , kind = Just league.kind
  , nbRankingTournaments = league.nbRankingTournaments
  }

  -- get the current league data
getCurrentLeague : LeaguesModel -> League
getCurrentLeague model =
  getLeague model.currentLeague.id model

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

  -- compare current league id with others leagues ids
compareLeagueId : Int -> League -> Bool
compareLeagueId i league =
  i == league.id
