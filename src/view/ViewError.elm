module ViewError exposing (viewError)

import Html exposing (..)
import Html.Attributes exposing (..)

import Model exposing (..)
import Msg exposing (..)

viewError : String -> Html Msg
viewError error =
  if String.isEmpty error then
    div [ style "height" "0px" ] []
  else
    div [ class "messageWrapper" ]
      [ div [ class "messageErreur" ]
        [ label [ id "messageErreur" ] [ text error ] ]
      ]
