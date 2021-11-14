module LeagueFormData exposing (..)

import League exposing (League)
import LeagueType exposing (..)

--
-- League Form
--
type alias LeagueFormData =
  { id : Int
  , displayed : Bool
  , name : String
  , kind : Maybe LeagueType
  , nbRankingTournaments : Int
  }

defaultLeagueFormData : LeagueFormData
defaultLeagueFormData =
  { id = 0
  , displayed = False
  , name = ""
  , kind = Nothing
  , nbRankingTournaments = 0
  }

-- Fill the League Form Data from a League
fillFromLeague : League -> LeagueFormData
fillFromLeague league =
  { id = league.id
  , displayed = True
  , name = league.name
  , kind = Just league.kind
  , nbRankingTournaments = league.nbRankingTournaments
  }

-- Fill the name of League Form Data
setName : String -> LeagueFormData -> LeagueFormData
setName s data =
  { data | name = s }

-- Fill the kind of League Form Data
setKind : LeagueType -> LeagueFormData -> LeagueFormData
setKind t data =
  { data | kind = Just t }

-- Fill the NbRanklingTournaments of League Form Data
setNbRanklingTournaments : Int -> LeagueFormData -> LeagueFormData
setNbRanklingTournaments i data =
  { data | nbRankingTournaments = i }
