module ViewError exposing (viewError)

import Html exposing (..)
import Html.Attributes exposing (..)

import Model exposing (..)
import Msg exposing (..)

viewError : Model -> Html Msg
viewError model =
  if String.isEmpty model.error then
    div [ style "height" "0px" ] []
  else
    div [ class "messageErreur" ]
      [ label [ id "messageErreur" ] [ text model.error ] ]
