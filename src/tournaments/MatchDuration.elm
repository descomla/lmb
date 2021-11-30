module MatchDuration exposing (..)

--
-- MatchDuration
--
type alias MatchDuration =
  { nbPeriod : Int
  , periodDuration : Int
  }

defaultMatchDuration : MatchDuration
defaultMatchDuration =
  { nbPeriod = 4
  , periodDuration = 10
  }

-- Setter Poule.matchDuration.nbPeriod
setNbPeriod : Int -> MatchDuration -> MatchDuration
setNbPeriod n data =
  { data | nbPeriod = n }

-- Setter Poule.matchDuration.duration
setPeriodDuration : Int -> MatchDuration -> MatchDuration
setPeriodDuration n data =
  { data | periodDuration = n }
