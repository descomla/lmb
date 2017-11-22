module LeaguesModel exposing (LeaguesModel, defaultLeaguesModel, League, Leagues, defaultLeague)

import Table exposing (State)

import LeagueType exposing (..)
import TournamentsModel exposing (..)

type alias LeaguesModel =
  { sortState : Table.State -- table current sort
  , leagueFilter : String -- search text by name
  , leagues : Leagues
  , currentLeague : League
  }

defaultLeaguesModel : LeaguesModel
defaultLeaguesModel =
  { sortState = Table.initialSort "name"
  , leagueFilter = ""
  , leagues = []
  , currentLeague = defaultLeague }

--
-- League
--
type alias League =
  { id : Int
  , name : String
  , kind : LeagueType
  , tournaments : Tournaments
}

type alias Leagues = List League

defaultLeague : League
defaultLeague =
  { id = 0
  , name = ""
  , kind = SingleEvent
  , tournaments = [] }
