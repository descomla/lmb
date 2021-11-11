module ViewUnderConstruction exposing (viewUnderConstruction)

import Html exposing (..)
import Html.Attributes exposing (..)

import Model exposing (..)
import Msg exposing (..)

viewUnderConstruction: Model -> Html Msg
viewUnderConstruction model =
  div [ class "fullWidth" ]
    [ div [ style [("text-align","center")]] [ img [ src "img/Under-construction.png" ][] ]
    , div [ class "contentBody", style [("text-align","center"), ("font-size", "1.25em")] ] [ text "Site en construction." ]
    ]
