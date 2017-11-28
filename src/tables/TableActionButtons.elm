module TableActionButtons exposing (TableActionButton, actionButton, renderActionButtons)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Msg exposing (Msg)
import UserRights exposing (..)
import Table exposing (HtmlDetails)

type alias TableActionButton =
  { id : String
  , toMsg : Msg
  , imgSrc : String
  , minimalRights : UserRights
  }

actionButton : String -> Msg -> String -> UserRights -> TableActionButton
actionButton  i m s r =
  { id = i
  , toMsg = m
  , imgSrc = s
  , minimalRights = r
  }

renderActionButton : TableActionButton -> Html Msg
renderActionButton btn =
    Html.button
        [ id btn.id, onClick btn.toMsg ]
        [ img [src btn.imgSrc, width 15] []
        ]

renderActionButtons : UserRights -> List TableActionButton -> HtmlDetails Msg
renderActionButtons rights list =
  let
    filtered = List.filter (hasMinimalRights rights) list
  in
    HtmlDetails [ class "image_a_cliquer"] (List.map renderActionButton filtered)

hasMinimalRights : UserRights -> TableActionButton -> Bool
hasMinimalRights rights item =
  if isUpperOrEqualRights item.minimalRights rights then
    True
  else
    False
