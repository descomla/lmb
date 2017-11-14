module ViewLeague exposing (viewCurrentLeague, viewOthersLeagues)

import Html exposing (..)
import Html.Attributes exposing (..)

import Model exposing (..)
import Msg exposing (..)

viewCurrentLeague : Model -> Html Msg
viewCurrentLeague model =
  div [ class "fullWidth" ]
  [ div [ style [("text-align","center")]] [ img [ src "img/Under-construction.png" ][] ]
  , div [ class "texte", style [("text-align","center")] ] [ text "Site en construction." ]
  ]

viewOthersLeagues : Model -> Html Msg
viewOthersLeagues model =
  div [ class "fullWidth" ]
  [ div [ style [("text-align","center")]] [ img [ src "img/Under-construction.png" ][] ]
  , div [ class "texte", style [("text-align","center")] ] [ text "Site en construction." ]
  ]
