module ViewError exposing (viewError)

import Html exposing (..)
import Html.Attributes exposing (..)

import Model exposing (..)
import Msg exposing (..)

viewError : Model -> Html Msg
viewError model =
  div [ class "messageErreur" ] [ label [ id "messageErreur" ][ text model.error ] ]
