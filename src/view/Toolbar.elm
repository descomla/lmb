module Toolbar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Msg exposing (..)
import UserRights exposing (..)

type alias ToolbarButton =
  { buttonId : String
  , labelId : String
  , msg : Msg
  , caption : String
  , minimalRights : UserRights
  }

viewToolbar : UserRights -> List ToolbarButton -> Html Msg
viewToolbar rights list =
  let
    filtered =
      List.filter (isUpperOrEqualRightsToolbarButton rights) list
    htmlList = List.map viewToolbarButton filtered
  in
    if List.isEmpty htmlList then
      div [][]
    else
      div [] htmlList

isUpperOrEqualRightsToolbarButton : UserRights -> ToolbarButton -> Bool
isUpperOrEqualRightsToolbarButton current button =
  isUpperOrEqualRights button.minimalRights current

viewToolbarButton : ToolbarButton -> Html Msg
viewToolbarButton button =
    div [ id button.buttonId
        , class "champ_a_cliquer"
        --, onMouseOver "this.style.cursor='pointer'"
        , style "cursor" "pointer"
        ]
        [ label [ id button.labelId, onClick button.msg ]
          [ text button.caption ]
        ]
