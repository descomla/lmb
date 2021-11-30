module DateCodec exposing (..)

import Date exposing (..)
import Time exposing (Month(..))

import Json.Decode exposing (Decoder, string, succeed)
import Json.Encode exposing (Value)

--
-- Json Decoder for Date
--
decoderDate : Decoder (Maybe Date)
decoderDate =
    Json.Decode.map string2date Json.Decode.string

--
-- Json Encoder for Date
--
encoderDate : (Maybe Date) -> Value
encoderDate d =
  Json.Encode.string (date2String d)

date2String : (Maybe Date) -> String
date2String d =
  case d of
    Nothing -> ""
    Just date ->
      Date.toIsoString date

string2date : String -> (Maybe Date)
string2date s =
  case (Date.fromIsoString s) of
    Ok d -> Just d
    Err r -> Nothing


date2displayString : (Maybe Date) -> String
date2displayString d =
  case d of
    Nothing -> ""
    Just date ->
      Date.format "dd/MM/y" date

displayString2date : String -> (Maybe Date)
displayString2date s =
  let
    iso = String.join "-" ( List.reverse ( String.split "/" s ) )
  in
    string2date iso
