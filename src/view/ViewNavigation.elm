module ViewNavigation exposing (viewNavigation)

import Html exposing (Html, a, img, div, footer, text, nav)
import Html.Attributes exposing (id, href, class, style, attribute, src)

import Html.Events exposing (onClick, onMouseOver)
import HtmlExtra exposing (..)

import UserRights exposing (..)
import Model exposing (..)
import Route exposing (..)
import Msg exposing (..)

import LeaguesModel exposing (getCurrentLeagueName)

import Debug exposing (..)

--
-- Debug function for ViewNavigation
--
debugViewNav : String -> a -> a
debugViewNav s a =
    --Debug.log s a
    a
--
-- Route rights
--
isUpperOrEqualRightsRoute : UserRights -> Route -> Bool
isUpperOrEqualRightsRoute rights route =
  case route of
    Route.Home ->
      isUpperOrEqualRights Visitor rights
    Route.Players ->
      isUpperOrEqualRights Visitor rights
    Route.Teams ->
      isUpperOrEqualRights Visitor rights
    Route.CurrentLeague s ->
      isUpperOrEqualRights Visitor rights
    Route.OthersLeagues s ->
      isUpperOrEqualRights Visitor rights
    Route.Configuration ->
      isUpperOrEqualRights Administrator rights
    Route.Help ->
      isUpperOrEqualRights Visitor rights

-- Navigation Toolbar
viewNavigation : Model -> Html Msg
viewNavigation model =
  let
    routes =
      List.filter
        (isUpperOrEqualRightsRoute model.session.rights)
          [Home, Players, Teams, CurrentLeague NoQuery, OthersLeagues NoQuery, Configuration, Help]
  in
    nav [ id "nav-toolbar" ]
      (List.map (\a -> navigationItem a model ) routes)
--      [ div [ class "navigation" ]
--        [ Html.table []
--          [ Html.tr [] (List.map (\a -> navigationItem a model ) routes)
--          ]
--        ]
--      ]

-- Navigaton item TD
navigationItem : Route -> Model -> Html Msg
navigationItem route model =
--  Html.td [class (navigationItemClass model.route route)]
    div
      [ class (navigationItemClass model.route route)
      , onClickPreventDefault (RouteChanged route)
      ]
      [ div []
        [ img [ src ("img/" ++ (route2img route)) ][]
        , text (routeDisplayName route model)
        ]
      ]

-- Choose selected or not selected item display class
navigationItemClass : Route -> Route -> String
navigationItemClass selected expected =
  if selected == expected then
    "nav-toolbar-item-selected"
  else
    "nav-toolbar-item-not-selected"

-- Navigaton item display name from Route
routeDisplayName : Route -> Model -> String
routeDisplayName route model =
  case route of
      Home -> "Accueil"
      Players -> "Les joueurs"
      Teams -> "Les équipes"
      CurrentLeague s ->
        case getCurrentLeagueName model.leaguesModel of
          Nothing -> "Ligue courante"-- si la ligue courante n'est pas définie, on affiche un générique
          Just name -> name -- si la ligue courante est définie, on affiche son nom
      OthersLeagues s -> "Les autres ligues"
      Configuration -> "Configuration"
      Help -> "Aide"

-- Navigaton item display image from Route
route2img : Route -> String
route2img route =
  case route of
      Home -> "home-32x32.png"
      Players -> "players-32x32.png"
      Teams -> "team-32x32.png"
      CurrentLeague s -> "Logo-lmb-32x32.png"
      OthersLeagues s -> "folder-32x32.png"
      Configuration -> "gears-32x32.png"
      Help -> "icon-help-32x32.png"
