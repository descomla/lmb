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
  , teams : List Int
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
getTournament tournament_id tournaments =
  let
    result = List.filter (\t -> t.id == tournament_id) tournaments
  in
    if List.isEmpty result then
      Debug.log ("Aucun tournoi #" ++ (String.fromInt tournament_id)) Nothing
    else if (List.length result) > 1 then
      Debug.log ("Trop de tournois #" ++ (String.fromInt tournament_id)) Nothing
    else
      List.head result

-- add a Team to the Tournament
addTeam : Team -> Tournament -> Tournament
addTeam team tournament =
  let
    result = team.id :: tournament.teams
  in
    { tournament | teams = List.reverse result }

-- add a Team to the Tournament
removeTeam : Team -> Tournament -> Tournament
removeTeam team tournament =
  let
    result = List.filter (\i -> if (i == team.id) then False else True) tournament.teams
  in
    { tournament | teams = result }
