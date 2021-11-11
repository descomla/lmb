module ViewNavigation exposing (viewNavigation)

import Html exposing (Html, a, img, div, footer, text, nav)
import Html.Attributes exposing (id, href, class, style, attribute, src)

import Html.Events exposing (onClick, onMouseOver)
import HtmlExtra exposing (..)

import Model exposing (..)
import Route exposing (..)
import Msg exposing (..)

import Debug exposing (..)

--
-- Debug function for ViewNavigation
--
debugViewNav : String -> a -> a
debugViewNav s a =
    Debug.log s a
    --a


-- Navigation Toolbar
viewNavigation : Model -> Html Msg
viewNavigation model =
  nav [ id "nav-toolbar" ]
    [ div [ class "navigation" ]
      [ Html.table []
        [ Html.tr []
          [ navigationItem Route.Home model
          , navigationItem Route.Players model
          , navigationItem Route.Teams model
          , navigationItem Route.CurrentLeague model
          , navigationItem Route.OthersLeagues model
          , navigationItem Route.Help model
          ]
        ]
      ]
    ]

-- Navigaton item TD
navigationItem : Route -> Model -> Html Msg
navigationItem route model =
  Html.td [class (navigationTdClass model.route route)]
    [ div [ onClickPreventDefault (UrlChange route) ]
      [ div [ style [("text-align","center")] ]
        [ img [ src ("img/" ++ (route2img route)) ][] ]
      , text (routeDisplayName route model)
      --a
        --[ href (route2URL route), onClickPreventDefault (UrlChange route) ]
        --[ text (routeDisplayName route model) ]
      ]
    ]

-- Navigaton item display name from Route
routeDisplayName : Route -> Model -> String
routeDisplayName route model =
  case route of
      Home -> "Accueil"
      Players -> "Les joueurs"
      Teams -> "Les équipes"
      CurrentLeague -> model.currentLeague
      OthersLeagues -> "Les autres ligues"
      Help -> "Aide"

-- Navigaton item display image from Route
route2img : Route -> String
route2img route =
  case route of
      Home -> "home-32x32.png"
      Players -> "players-32x32.png"
      Teams -> "team-32x32.png"
      CurrentLeague -> "progress-icon-32x32.png"
      OthersLeagues -> "database-worldwide-32x32.png"
      Help -> "icon-help-32x32.png"

-- Choose selected or not selected item display class
navigationTdClass : Route -> Route -> String
navigationTdClass selected expected =
  if (debugViewNav "navTDclass selected = " selected) == (debugViewNav "navTDclass expected = " expected) then
    (debugViewNav "navTDclass result =" "navigation-selected")
  else
    (debugViewNav "navTDclass result =" "navigation-not-selected")
