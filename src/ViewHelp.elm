module ViewHelp exposing (viewHelp)

import Html exposing (..)
import Html.Attributes exposing (..)

import Model exposing (..)
import Msg exposing (..)

viewHelp: Model -> Html Msg
viewHelp model =
  div [ class "fullWidth" ]
  [ div [ style [("text-align","center")]] [ img [ src "img/Under-construction.png" ][] ]
  , div [ class "texte", style [("text-align","center")] ] [ text "Site en construction." ]
  ]
