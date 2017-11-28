module TournamentsModel exposing (Tournament, Tournaments, defaultTournament)

--
-- Tournament
--
type alias Tournament =
  { id : Int
  , name : String
  , location : String
  , maxTeams : Int
  , league_id : Int
}

type alias Tournaments = List Tournament

defaultTournament : Tournament
defaultTournament =
  { id = 0
  , name = ""
  , location = ""
  , maxTeams = 0
  , league_id = 0 }
