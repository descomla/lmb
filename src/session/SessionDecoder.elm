module SessionDecoder exposing (decoderSession, encoderSession)

import Json.Decode exposing (Decoder, Value, string)
import Json.Decode.Pipeline exposing (required)
import Json.Encode exposing (string)
import SessionModel exposing (Session)
import UserRightsDecoder exposing (..)

--
-- Json Decoder for Session
--
decoderSession : Decoder Session
decoderSession =
  Json.Decode.succeed Session
    |> Json.Decode.Pipeline.required "sessionId" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "login" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "rights" decodeUserRights
    |> Json.Decode.Pipeline.required "firstName" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "lastName" (Json.Decode.string)

--
-- Json Encoder for Session
--
encoderSession : Session -> Value
encoderSession session =
    Json.Encode.object
      [ ("sessionId", Json.Encode.string session.sessionId)
      , ("login", Json.Encode.string "")
      , ("rights", Json.Encode.string (encodeUserRights session.rights))
      , ("firstName", Json.Encode.string session.firstName)
      , ("lastName", Json.Encode.string session.lastName)
      ]
