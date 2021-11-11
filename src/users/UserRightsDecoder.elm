module UserRightsDecoder exposing (decodeUserRights, encodeUserRights)

import Json.Decode exposing (Decoder, string)

import UserRights exposing (..)
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
        "Director" ->
          Json.Decode.succeed Director
        "Visitor" ->
          Json.Decode.succeed Visitor
        somethingElse ->
          Json.Decode.fail <| "Unknown UserRight " ++ somethingElse
    )

encodeUserRights : UserRights -> String
encodeUserRights r =
    case r of
        Administrator -> "Administrator"
        Director -> "Director"
        Visitor -> "Visitor"
