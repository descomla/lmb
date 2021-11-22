module League exposing (League, defaultLeague, Leagues
  , compareLeagueId, getLeague, getLeagueTournaments)

import LeagueType exposing (..)

import Tournaments exposing (Tournaments)

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

-- get a league data
getLeague : Int -> Leagues -> Maybe League
getLeague league_id leagues =
  let
    result = List.filter (compareLeagueId league_id) leagues
  in
    if List.isEmpty result then
      Debug.log ("Aucune ligue #" ++ (String.fromInt league_id)) Nothing
    else if (List.length result) > 1 then
      Debug.log ("Trop de ligues #" ++ (String.fromInt league_id)) Nothing
    else
      List.head result

-- get Tournaments Data for a specific league
getLeagueTournaments : League -> Tournaments -> Tournaments
getLeagueTournaments league tournaments = -- filter the full tournaments list
  --with the tournaments id of the league
  List.filter (\t -> t.league_id == league.id ) tournaments
