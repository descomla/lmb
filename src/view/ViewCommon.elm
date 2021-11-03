module ViewCommon exposing (..)

import Html exposing (Html, div, footer, p, text)
import Html.Attributes exposing (id, class)

import Navigation exposing (..)
import Msg exposing (..)

navigationTdClass : Navigation -> List Navigation -> String
navigationTdClass selected expected =
  if (List.member selected expected) then
    "navigation-selected"
  else
    ""


viewContainer : Html Msg -> Html Msg
viewContainer content =
    div [ id "div-container" ] [ content ]

--
-- Bas de page
--

infoFooter : Html Msg
infoFooter =
    footer [ class "infoFooter" ] [ p [] [ text "Copyright Julien Perrot 2017" ] ]
