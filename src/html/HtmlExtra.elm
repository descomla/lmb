module HtmlExtra exposing (onClickPreventDefault)

import Html exposing (Attribute)
import Html.Events exposing (custom)

import Json.Decode exposing (succeed)

onClickPreventDefault : msg -> Attribute msg
onClickPreventDefault msg =
  custom
    "click"
    ( Json.Decode.succeed
      { message = msg, preventDefault = True, stopPropagation = False } )
