module ViewCommon exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (id)

import Msg exposing (..)

viewContainer : Html Msg -> Html Msg
viewContainer content =
    div [ id "div-container" ] [ content ]
