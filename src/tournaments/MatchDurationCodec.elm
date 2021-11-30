module MatchDurationCodec exposing (decoderMatchDuration, encoderMatchDuration)

import Json.Decode exposing (Decoder)
import Json.Encode exposing (Value)
import Json.Decode.Pipeline exposing (required)

import MatchDuration exposing (..)
--
-- Json Decoder for MatchDuration
--
decoderMatchDuration : Decoder MatchDuration
decoderMatchDuration =
  Json.Decode.succeed MatchDuration
    |> Json.Decode.Pipeline.required "nbPeriod" (Json.Decode.int)
    |> Json.Decode.Pipeline.required "duration" (Json.Decode.int)

--
-- Json Encoder for MatchDuration
--
encoderMatchDuration : MatchDuration -> Value
encoderMatchDuration data =
      Json.Encode.object
        [ ("nbPeriod", Json.Encode.int data.nbPeriod)
        , ("duration", Json.Encode.int data.periodDuration)
        ]
