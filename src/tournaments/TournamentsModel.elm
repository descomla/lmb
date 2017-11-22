module TournamentsModel exposing (Tournament, Tournaments, defaultTournament)

--
-- Tournament
--
type alias Tournament =
  { id : Int
  , name : String
  , location : String
  , maxTeams : Int
  , league : Int
}

type alias Tournaments = List Tournament

defaultTournament : Tournament
defaultTournament =
  { id = 0
  , name = ""
  , location = ""
  , maxTeams = 0
  , league = 0 }
