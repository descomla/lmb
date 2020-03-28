module ViewPlayers exposing (viewPlayers)

import Html exposing (..)
import Html.Attributes exposing (..)

import Model exposing (..)
import Msg exposing (..)

viewPlayers: Model -> Html Msg
viewPlayers model =
  div [ class "fullWidth" ]
    [ div [ class "titre" ] [ text "Les joueurs" ]
    , div [ style [("text-align","center")]] [ img [ src "img/Under-construction.png" ][] ]
    , div [ class "contentBody", style [("text-align","center"), ("font-size", "1.25em")] ] [ text "Site en construction." ]
    ]
