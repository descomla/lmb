module UserDecoder exposing (decoderUserProfile, decoderUserProfiles)

import Json.Decode exposing (Decoder, string, map)
import Json.Decode.Pipeline exposing (decode, required)

import UserModel exposing (..)
import UserRights exposing (..)

--
-- Json Decoder for UserProfile
--
decoderUserProfile : Decoder UserProfile
decoderUserProfile =
  Json.Decode.Pipeline.decode UserProfile
    |> Json.Decode.Pipeline.required "login" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "password" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "rights" decodeUserRights
    |> Json.Decode.Pipeline.required "firstName" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "lastName" (Json.Decode.string)

--
-- Json Decoder for UserRights
--
decodeUserRights : Decoder UserRights
decodeUserRights =
  Json.Decode.string
    |> Json.Decode.andThen (\str ->
      case str of
        "Administrator" ->
          Json.Decode.succeed Administrator
        "Visitor" ->
          Json.Decode.succeed Visitor
        somethingElse ->
          Json.Decode.fail <| "Unknown UserRight " ++ somethingElse
    )

decoderUserProfiles : Decoder UserProfiles
decoderUserProfiles =
    Json.Decode.list decoderUserProfile
