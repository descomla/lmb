module HtmlExtra exposing (onClickPreventDefault)

import Html exposing (Attribute)
import Html.Events exposing (onWithOptions)

import Json.Decode exposing (succeed)

onClickPreventDefault : msg -> Attribute msg
onClickPreventDefault msg =
  onWithOptions
    "click"
    { preventDefault = True
    , stopPropagation = False
    }
    (Json.Decode.succeed msg)
