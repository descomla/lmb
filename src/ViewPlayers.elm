module ViewPlayers exposing (viewPlayers)

import Html exposing (..)
import Html.Attributes exposing (..)

import Model exposing (..)
import Msg exposing (..)

viewPlayers: Model -> Html Msg
viewPlayers model =
  div [ class "fullWidth" ]
  [ div [ style [("text-align","center")]] [ img [ src "img/Under-construction.png" ][] ]
  , div [ class "texte", style [("text-align","center")] ] [ text "Site en construction." ]
  ]
