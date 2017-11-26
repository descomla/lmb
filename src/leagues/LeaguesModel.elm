module LeaguesModel exposing (LeaguesModel, defaultLeaguesModel, League, Leagues, defaultLeague, LeagueForm, defaultLeagueForm)

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
  { name : String
  , kind : Maybe LeagueType
  , nbRankingTournaments : Int }

defaultLeagueForm : LeagueForm
defaultLeagueForm =
  { name = ""
  , kind = Nothing
  , nbRankingTournaments = 0 }
