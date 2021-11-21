module TeamsCodec exposing (decoderTeam, decoderTeams, encoderTeam)

import Json.Decode exposing (Decoder, string, int)
import Json.Encode exposing (Value)
import Json.Decode.Pipeline exposing (required, optional)

import Teams exposing (..)

--
-- Json Decoder for Team
--
decoderTeam : Decoder Team
decoderTeam =
  Json.Decode.succeed Team
    |> Json.Decode.Pipeline.required "id" (Json.Decode.int)
    |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "textcolor" (Json.Decode.string)

decoderTeams : Decoder Teams
decoderTeams =
    Json.Decode.list decoderTeam

--
-- Json Encoder for Team
--
encoderTeam : Team -> Value
encoderTeam team =
    Json.Encode.object
      [ ("id", Json.Encode.int team.id)
      , ("name", Json.Encode.string team.name)
      , ("textcolor", Json.Encode.string team.textcolor)
      ]
