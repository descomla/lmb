module PouleCodec exposing (decoderPoule, encoderPoule)

import Json.Decode exposing (Decoder)
import Json.Encode exposing (Value)
import Json.Decode.Pipeline exposing (required, optional)

import Poule exposing (..)
--
-- Json Decoder for Poule
--
decoderPoule : Decoder Poule
decoderPoule =
  Json.Decode.succeed Poule
    |> Json.Decode.Pipeline.required "id" Json.Decode.int
    |> Json.Decode.Pipeline.required "name" Json.Decode.string
    |> Json.Decode.Pipeline.required "status" decoderPouleStatus
    |> Json.Decode.Pipeline.required "pointsVictory" Json.Decode.int
    |> Json.Decode.Pipeline.required "pointsDefeat" Json.Decode.int
    |> Json.Decode.Pipeline.required "pointsNull" Json.Decode.int
    |> Json.Decode.Pipeline.required "goalAverage" Json.Decode.int

--
-- Json Encoder for Poule
--
encoderPoule : Poule -> Value
encoderPoule poule =
    Json.Encode.object
      [ ("id", Json.Encode.int poule.id)
      , ("name", Json.Encode.string poule.name)
      , ("status", encoderPouleStatus poule.status )
      , ("pointsVictory", Json.Encode.int poule.pointsVictory )
      , ("pointsDefeat", Json.Encode.int poule.pointsDefeat )
      , ("pointsNull", Json.Encode.int poule.pointsNull )
      , ("goalAverage", Json.Encode.int poule.goalAverage )
      ]


--
-- Json Decoder for PouleStatus
--
decoderPouleStatus : Decoder PouleStatus
decoderPouleStatus =
  Json.Decode.string
    |> Json.Decode.andThen (\str ->
      case str of
        "Pending" ->
          Json.Decode.succeed Pending
        "Running" ->
          Json.Decode.succeed Running
        "Terminated" ->
          Json.Decode.succeed Terminated
        somethingElse ->
          Json.Decode.fail <| "Unknown PouleStatus " ++ somethingElse)

--
-- Json Encoder for PouleStatus
--
encoderPouleStatus : PouleStatus -> Value
encoderPouleStatus status =
  case status of
    Pending -> Json.Encode.string "Pending"
    Running -> Json.Encode.string "Running"
    Terminated -> Json.Encode.string "Terminated"
