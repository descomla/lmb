module TeamsCodec exposing (decoderTeam, decoderTeams, encoderTeamForm)

import Json.Decode exposing (Decoder, string, int)
import Json.Encode exposing (Value)
import Json.Decode.Pipeline exposing (required, optional)

import Color exposing (..)
import Colors exposing (fromCssString)

import Teams exposing (Team, Teams)
import TeamFormData exposing (TeamFormData)

--
-- Json Decoder for Team
--
decoderTeam : Decoder Team
decoderTeam =
  Json.Decode.succeed Team
    |> Json.Decode.Pipeline.required "id" (Json.Decode.int)
    |> Json.Decode.Pipeline.required "name" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "colors" decoderColor
    |> Json.Decode.Pipeline.required "logo" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "picture" (Json.Decode.string)

decoderTeams : Decoder Teams
decoderTeams =
    Json.Decode.list decoderTeam

decoderColor : Decoder Color
decoderColor =
  Json.Decode.map Colors.fromCssString Json.Decode.string

--
-- Json Encoder for Team
--
encoderTeamForm : TeamFormData -> Value
encoderTeamForm team =
    Json.Encode.object
      [ ("id", Json.Encode.int team.id)
      , ("name", Json.Encode.string team.name)
      , ("colors", Json.Encode.string (Colors.toCssString team.colors) )
      , ("logo", Json.Encode.string team.logo)
      , ("picture", Json.Encode.string team.picture)
      ]
