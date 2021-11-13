module ViewUnderConstruction exposing (viewUnderConstruction)

import Html exposing (..)
import Html.Attributes exposing (..)

import Model exposing (..)
import Msg exposing (..)

viewUnderConstruction: String -> Model -> Html Msg
viewUnderConstruction title model =
  div [ class "fullWidth" ]
    [ div [ class "titre" ] [ text title ]
    , div [ style "text-align" "center" ] [ img [ src "img/Under-construction.png" ][] ]
    , div [ class "contentBody", style "text-align" "center", style "font-size" "1.25em" ] [ text "Site en construction." ]
    ]
