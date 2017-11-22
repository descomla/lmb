module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Lazy exposing (lazy, lazy2)
import Html.Events exposing (..)

import Model exposing (..)
import Msg exposing (..)
import Navigation exposing (..)

import ViewUserInfo exposing (viewUserInfo)
import ViewLeague exposing (viewCurrentLeague, viewOthersLeagues)
import ViewHelp exposing (viewHelp)
import ViewPlayers exposing (viewPlayers)
import ViewTeams exposing (viewTeams)
import ViewHome exposing (viewHome)

view : Model -> Html Msg
view model =
    div []
      [ lazy2 viewNavigation model.navigation "LMB 2017-2018" -- TODO To get from a config file or something else
      , lazy ViewUserInfo.viewUserInfo model.userModel
      , div [ class "messageErreur" ] [ label [ id "messageErreur" ][ text model.error ] ]
      , lazy viewContainer model
      , infoFooter
      ]

-- Navigation Toolbar
viewNavigation : Navigation -> String -> Html Msg
viewNavigation page league =
  nav [ id "nav-toolbar" ]
    [ div [ class "navigation" ]
    [ Html.table []
      [ Html.tr []
        [ Html.td [class (isNavigationSelected page Navigation.Home)] [div [ onClick NavigationHome, id "Navigation-Home" ][text "Accueil"]]
        , Html.td [class (isNavigationSelected page Navigation.Players)] [div [ onClick NavigationPlayers, id "Navigation-Players"] [ text "Les joueurs"]]
        , Html.td [class (isNavigationSelected page Navigation.Teams)] [div [ onClick NavigationTeams, id "Navigation-Teams"] [ text "Les équipes"]]
        , Html.td [class (isNavigationSelected page Navigation.CurrentLeague)] [div [ onClick NavigationCurrentLeague, id "Navigation-Current"] [ text league]]
        , Html.td [class (isNavigationSelected page Navigation.OthersLeagues)] [div [ onClick NavigationOthersLeagues, id "Navigation-Others"] [ text "Les autres ligues"]]
        , Html.td [class (isNavigationSelected page Navigation.Help)] [div [ onClick NavigationHelp, id "Navigation-Help"] [ text "Aide d'utilisation"]]
        ]
      ]
    ]
  ]

isNavigationSelected : Navigation -> Navigation -> String
isNavigationSelected selected  expected =
  if selected == expected then
    "navigation-selected"
  else
    ""

viewContainer : Model -> Html Msg
viewContainer model =
  let
    content = viewContent model
  in
    div [ id "div-container" ] [ content ]

viewContent : Model -> Html Msg
viewContent model =
    case model.navigation of
      Home ->
        viewHome model
      Players ->
        viewPlayers model
      Teams ->
        viewTeams model
      CurrentLeague ->
        viewCurrentLeague model.leaguesModel
      OthersLeagues ->
        viewOthersLeagues model
      Help ->
        viewHelp model

--
-- Bas de page
--

infoFooter : Html Msg
infoFooter =
    footer [ class "infoFooter" ] [ p [] [ text "Copyright Julien Perrot 2017" ] ]
