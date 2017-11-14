module ViewTeams exposing (viewTeams)

import Html exposing (..)
import Html.Attributes exposing (..)

import Model exposing (..)
import Msg exposing (..)

viewTeams: Model -> Html Msg
viewTeams model =
  div [ class "fullWidth" ]
    [ div [ class "titre" ] [ text "Les équipes" ]
    , div [ style [("text-align","center")]] [ img [ src "img/Under-construction.png" ][] ]
    , div [ class "contentBody", style [("text-align","center"), ("font-size", "1.25em")] ] [ text "Site en construction." ]
    ]
