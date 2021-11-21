module Tournaments exposing (Tournament, Tournaments, defaultTournament
  , getTournament
  , addTeam, removeTeam)

import Teams exposing (..)
--
-- Tournament
--
type alias Tournament =
  { id : Int
  , name : String
  , location : String
  , maxTeams : Int
  , league_id : Int
  , teams : Teams
  }

type alias Tournaments = List Tournament

defaultTournament : Tournament
defaultTournament =
  { id = 0
  , name = ""
  , location = ""
  , maxTeams = 0
  , league_id = 0
  , teams = []
  }

-- get Tournament Data
getTournament : Int -> Tournaments -> Maybe Tournament
getTournament i tournaments =
  let
    result = List.filter (\t -> t.id == i) tournaments
  in
    if (List.length result) == 0 then
      Debug.log ("No tournament #" ++ (String.fromInt i)) Nothing
    else
      if (List.length result) > 1 then
        Debug.log ("More than one tournament #" ++ (String.fromInt i)) Nothing
      else
        List.head result

-- add a Team to the Tournament
addTeam : Team -> Tournament -> Tournament
addTeam team tournament =
  let
    result = team :: tournament.teams
  in
    { tournament | teams = List.reverse result }

-- add a Team to the Tournament
removeTeam : Team -> Tournament -> Tournament
removeTeam team tournament =
  let
    result = List.filter (\t -> if (t.id == team.id) then False else True) tournament.teams
  in
    { tournament | teams = result }
