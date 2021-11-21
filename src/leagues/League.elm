module League exposing (League, defaultLeague, Leagues
  , compareLeagueId, retrieveFreeId, retrieveMaxId)

import LeagueType exposing (..)

--
-- League
--
type alias League =
  { id : Int
  , name : String
  , kind : LeagueType
  , nbRankingTournaments: Int
--  , tournaments : List Int
  }

type alias Leagues = List League

defaultLeague : League
defaultLeague =
  { id = 0
  , name = ""
  , kind = SingleEvent
  , nbRankingTournaments = 0
--  , tournaments = []
  }

-- compare current league id with others leagues ids
compareLeagueId : Int -> League -> Bool
compareLeagueId i league =
  i == league.id

-- get the last free id for a new league
retrieveFreeId : Leagues -> Int
retrieveFreeId leagues =
  let
    maxId = retrieveMaxId leagues
  in
    case maxId of
      Just value ->
        (1 + value)
      Nothing ->
        1

-- get the maximum id value in the leagues list
retrieveMaxId : Leagues -> Maybe Int
retrieveMaxId leagues =
    List.maximum (List.map .id leagues)
