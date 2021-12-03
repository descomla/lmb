module PhaseCodec exposing (decoderPhase, encoderPhase)

import Json.Decode exposing (Decoder)
import Json.Encode exposing (Value)
import Json.Decode.Pipeline exposing (required, optional)

import DateCodec exposing (..)

import MatchDuration exposing (defaultMatchDuration)
import MatchDurationCodec exposing (..)

import Phase exposing (..)

import PouleCodec exposing (..)

--
-- Json Decoder for Phase
--
decoderPhase : Decoder Phase
decoderPhase =
  Json.Decode.succeed Phase
    |> Json.Decode.Pipeline.required "id" (Json.Decode.int)
    |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "date" decoderDate
    |> Json.Decode.Pipeline.required "parameters" decoderPhaseType

--
-- Json Encoder for Phase
--
encoderPhase : Phase -> Value
encoderPhase phase =
    Json.Encode.object
      [ ("id", Json.Encode.int phase.id)
      , ("name", Json.Encode.string phase.name)
      , ("date", encoderDate phase.date )
      , ("parameters", encoderPhaseType phase.parameters )
      ]


--
-- Json Decoder for PhaseType
--
decoderPhaseType : Decoder PhaseType
decoderPhaseType =
  Json.Decode.oneOf
  [ decoderPoulePhase, decoderEliminationPhase, decoderFreePhase ]

-- decode Poule data
decoderPouleData : Decoder PouleData
decoderPouleData =
  Json.Decode.succeed PouleData
    |> Json.Decode.Pipeline.required "nbPoules" Json.Decode.int
    |> Json.Decode.Pipeline.required "matchDuration" decoderMatchDuration
    |> Json.Decode.Pipeline.optional "poules" (Json.Decode.list decoderPoule) []

-- decode Poule phase
decoderPoulePhase : Decoder PhaseType
decoderPoulePhase =
  Json.Decode.map PoulePhase decoderPouleData


-- decode Elimination data
decoderEliminationData : Decoder EliminationData
decoderEliminationData =
  Json.Decode.succeed EliminationData
    |> Json.Decode.Pipeline.required "nbTeams" Json.Decode.int
    |> Json.Decode.Pipeline.required "finale" decoderMatchDuration
    |> Json.Decode.Pipeline.required "littleFinale" decoderMatchDuration
    |> Json.Decode.Pipeline.optional "semiFinale" decoderMatchDuration defaultMatchDuration
    |> Json.Decode.Pipeline.optional "quarterFinale" decoderMatchDuration defaultMatchDuration
    |> Json.Decode.Pipeline.optional "eighthFinale" decoderMatchDuration defaultMatchDuration
    |> Json.Decode.Pipeline.optional "sixteenthFinale" decoderMatchDuration defaultMatchDuration

-- decode Elimination phase
decoderEliminationPhase : Decoder PhaseType
decoderEliminationPhase =
  Json.Decode.map EliminationPhase decoderEliminationData

-- decode Free phase
decoderFreePhase : Decoder PhaseType
decoderFreePhase =
  Json.Decode.succeed FreePhase

--
-- Json Encoder for Phase
--
encoderPhaseType : PhaseType -> Value
encoderPhaseType phaseType =
  case phaseType of
    PoulePhase data ->
      Json.Encode.object
        [ ("nbPoules", Json.Encode.int data.nbPoules)
        , ("matchDuration", encoderMatchDuration data.matchDuration)
        , ("poules", Json.Encode.list encoderPoule data.poules)
        ]
    EliminationPhase data ->
      Json.Encode.object
        [ ("nbTeams", Json.Encode.int data.nbTeams)
        , ("finale", encoderMatchDuration data.finale)
        , ("littleFinale", encoderMatchDuration data.littleFinale)
        , ("semiFinale", encoderMatchDuration data.semiFinale)
        , ("quarterFinale", encoderMatchDuration data.quarterFinale)
        , ("eighthFinale", encoderMatchDuration data.eighthFinale)
        , ("sixteenthFinale", encoderMatchDuration data.sixteenthFinale)
        ]
    FreePhase ->
      Json.Encode.null
