module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Lazy exposing (lazy, lazy2)
import Html.Events exposing (..)

import Model exposing (..)
import Actions exposing (..)

import ViewUserInfo exposing (viewUserInfo)

view : Model -> Html Msg
view model =
  div []
    [ lazy viewNavigation "LMB 2017-2018"
    , lazy ViewUserInfo.viewUserInfo model.user
    , lazy viewContainer model
    , infoFooter
    ]

-- Navigation Toolbar
viewNavigation : String -> Html Msg
viewNavigation league =
  nav [ id "nav-toolbar" ] [ span [class "navigation"]
    [ button [ onClick NavigationHome, id "Navigation-Home"] [ text "Accueil"]
    , button [ onClick NavigationPlayers, id "Navigation-Players"] [ text "Les joueurs"]
    , button [ onClick NavigationTeams, id "Navigation-Teams"] [ text "Les équipes"]
    , button [ onClick NavigationCurrentLeague, id "Navigation-Current"] [ text league] -- TODO To get from a config file or something else
    , button [ onClick NavigationOthersLeagues, id "Navigation-Others"] [ text "Les autres ligues"]
    , button [ onClick NavigationHelp, id "Navigation-Help"] [ text "Aide d'utilisation"]
    ]
  ]

viewContainer : Model -> Html Msg
viewContainer model =
    div [ id "div-container" ] [ text "main content" ]

--
-- Bas de page
--

infoFooter : Html Msg
infoFooter =
    footer [ class "info" ] [ p [] [ text "Copyright Julien Perrot 2017" ] ]
