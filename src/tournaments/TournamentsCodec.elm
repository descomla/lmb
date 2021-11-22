module TournamentsCodec exposing (decoderTournament, decoderTournaments, encoderTournament)

import Json.Decode exposing (Decoder, string, succeed)
import Json.Encode exposing (Value)
import Json.Decode.Pipeline exposing (required, optional)

import TeamsCodec exposing (..)

import Tournaments exposing (..)

--
-- Json Decoder for League
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

decoderTournaments : Decoder Tournaments
decoderTournaments =
    Json.Decode.list decoderTournament

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
      ]
