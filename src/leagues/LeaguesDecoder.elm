module LeaguesDecoder exposing (decoderLeague, decoderLeagues)

import Json.Decode exposing (Decoder, string, map)
import Json.Decode.Pipeline exposing (decode, required, optional)

import LeaguesModel exposing (..)
import LeagueType exposing (..)

import TournamentsModel exposing (..)

--
-- Json Decoder for League
--
decoderLeague : Decoder League
decoderLeague =
  Json.Decode.Pipeline.decode League
    |> Json.Decode.Pipeline.required "id" (Json.Decode.int)
    |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "kind" decodeLeagueType
    |> Json.Decode.Pipeline.required "tournaments" decodeTournamentIds

--
-- Json Decoder for LeaguerRights
--
decodeLeagueType : Decoder LeagueType
decodeLeagueType =
  Json.Decode.string
    |> Json.Decode.andThen (\str ->
      case str of
        "SingleEvent" ->
          Json.Decode.succeed SingleEvent
        "LeagueWithRanking" ->
          Json.Decode.succeed LeagueWithRanking
        "LeagueWithoutRanking" ->
          Json.Decode.succeed LeagueWithoutRanking
        somethingElse ->
          Json.Decode.fail <| "Unknown LeagueType " ++ somethingElse
    )

decoderLeagues : Decoder Leagues
decoderLeagues =
    Json.Decode.list decoderLeague

decodeTournamentIds : Decoder Tournaments
decodeTournamentIds =
  Json.Decode.list decoderTournamentId

decoderTournamentId : Decoder Tournament
decoderTournamentId =
  Json.Decode.Pipeline.decode Tournament
    |> Json.Decode.Pipeline.required "id" (Json.Decode.int)
    |> Json.Decode.Pipeline.optional "name" Json.Decode.string ""
    |> Json.Decode.Pipeline.optional "location" Json.Decode.string ""
    |> Json.Decode.Pipeline.optional "maxTeams" Json.Decode.int 0
    |> Json.Decode.Pipeline.optional "league_id" Json.Decode.int 0