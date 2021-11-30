module Tournaments exposing (Tournament, Tournaments, defaultTournament
  , getTournament
  , addTeam, removeTeam)

import Teams exposing (..)
import Phase exposing (Phase)
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
  , phases : List Phase
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
  , phases = []
  }

-- get Tournament Data
getTournament : Int -> Tournaments -> (Maybe Tournament, String)
getTournament tournament_id tournaments =
  let
    result = List.filter (\t -> t.id == tournament_id) tournaments
  in
    if List.isEmpty result then
      ( Nothing, "Aucun tournoi #" ++ (String.fromInt tournament_id) )
    else if (List.length result) > 1 then
      ( Nothing, "Trop de tournois #" ++ (String.fromInt tournament_id) )
    else
      case List.head result of
        Nothing ->
          ( Nothing, "Le tournoi #" ++ (String.fromInt tournament_id) ++ "n'a pas été trouvé" )
        Just tournament ->
          ( Just tournament, "" )

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
