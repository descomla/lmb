module TournamentsCodec exposing (decoderTournament, decoderTournaments, encoderTournament)

import Json.Decode exposing (Decoder, string, succeed)
import Json.Encode exposing (Value)
import Json.Decode.Pipeline exposing (required, optional)

import DateCodec exposing (..)
import TeamsCodec exposing (..)
import PhaseCodec exposing (..)
import MatchDurationCodec exposing (..)

import Tournaments exposing (..)

decoderTournaments : Decoder Tournaments
decoderTournaments =
    Json.Decode.list decoderTournament

--
-- Json Decoder for Tournament
--
decoderTournament : Decoder Tournament
decoderTournament =
  Json.Decode.succeed Tournament
    |> Json.Decode.Pipeline.required "id" (Json.Decode.int)
    |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "location" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "maxTeams" (Json.Decode.int)
    |> Json.Decode.Pipeline.required "league_id" (Json.Decode.int)
    |> Json.Decode.Pipeline.optional "teams" (Json.Decode.list Json.Decode.int) []
    |> Json.Decode.Pipeline.optional "phases"(Json.Decode.list decoderPhase) []

--
-- Json Encoder for Tournament
--
encoderTournament : Tournament -> Value
encoderTournament tournament =
    Json.Encode.object
      [ ("id", Json.Encode.int tournament.id)
      , ("name", Json.Encode.string tournament.name)
      , ("location", Json.Encode.string tournament.location )
      , ("maxTeams", Json.Encode.int tournament.maxTeams)
      , ("league_id", Json.Encode.int tournament.league_id)
      , ("teams", Json.Encode.list Json.Encode.int tournament.teams)
      , ("phases", Json.Encode.list encoderPhase tournament.phases)
      ]
