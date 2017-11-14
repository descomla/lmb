module ViewLeague exposing (viewCurrentLeague, viewOthersLeagues)

import Html exposing (..)
import Html.Attributes exposing (..)

import Model exposing (..)
import Msg exposing (..)

viewCurrentLeague : Model -> Html Msg
viewCurrentLeague model =
  div [ class "fullWidth" ]
    [ div [ class "titre" ] [ text model.currentLeague ]
    , div [ style [("text-align","center")]] [ img [ src "img/Under-construction.png" ][] ]
    , div [ class "contentBody", style [("text-align","center"), ("font-size", "1.25em")] ] [ text "Site en construction." ]
    ]

viewOthersLeagues : Model -> Html Msg
viewOthersLeagues model =
  div [ class "fullWidth" ]
    [ div [ class "titre" ] [ text "Les autres ligues" ]
    , div [ style [("text-align","center")]] [ img [ src "img/Under-construction.png" ][] ]
    , div [ class "contentBody", style [("text-align","center"), ("font-size", "1.25em")] ] [ text "Site en construction." ]
    ]
