module TournamentsDecoder exposing (decoderTournament, decoderTournaments)

import Json.Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required)

import TournamentsModel exposing (..)

--
-- Json Decoder for League
--
decoderTournament : Decoder Tournament
decoderTournament =
  Json.Decode.Pipeline.decode Tournament
    |> Json.Decode.Pipeline.required "id" (Json.Decode.int)
    |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "location" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "maxTeams" (Json.Decode.int)
    |> Json.Decode.Pipeline.required "league_id" (Json.Decode.int)

decoderTournaments : Decoder Tournaments
decoderTournaments =
    Json.Decode.list decoderTournament
