module TableCommon exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Msg exposing (..)
import Table exposing (..)

import Color exposing (Color)
import Colors exposing (styleColor)

tableCustomizations : Customizations data msg
tableCustomizations =
  { tableAttrs = [class "tableau_recherche"]
  , caption = Nothing
  , thead = tableThead
  , tfoot = Nothing
  , tbodyAttrs = []
  , rowAttrs = tableRowAttrs
  }

tableThead : List (String, Status, Attribute msg) -> HtmlDetails msg
tableThead headers =
  HtmlDetails [] (List.map tableTheadHelp headers)

-- Handle conversion from LeagueType to HtmlDetails msg
stringToHtmlDetails : String -> HtmlDetails msg
stringToHtmlDetails str =
    HtmlDetails [ class "tableau_recherche_td" ] [ Html.text str ]

-- Handle conversion from LeagueType to HtmlDetails msg
stringToColorHtmlDetails : Color -> String -> HtmlDetails msg
stringToColorHtmlDetails c str =
    HtmlDetails [ class "tableau_recherche_td", styleColor c ] [ Html.text str ]

tableRowAttrs : data -> List (Attribute msg)
tableRowAttrs _ =
  [ class "tableau_recherche_tr" ]

tableTheadHelp : ( String, Status, Attribute msg ) -> Html msg
tableTheadHelp (name, status, onClick) =
    Html.th [ class "tableau_recherche_th", onClick ] (simpleTheadContent name status)


noSorter : State -> Msg
noSorter state =
  NoOp
