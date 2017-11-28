module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Lazy exposing (lazy, lazy2)
import Html.Events exposing (..)

import Model exposing (..)
import Msg exposing (..)
import Navigation exposing (..)
import LeaguesPages exposing (..)

import ViewUserInfo exposing (viewUserInfo)
import ViewLeague exposing (viewCurrentLeague, viewOthersLeagues)
import ViewHelp exposing (viewHelp)
import ViewPlayers exposing (viewPlayers)
import ViewTeams exposing (viewTeams)
import ViewHome exposing (viewHome)

view : Model -> Html Msg
view model =
    div []
      [ lazy2 viewNavigation model.navigation model.leaguesModel.currentLeague.name -- TODO To get from a config file or something else
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
        [ Html.td [class (navigationTdClass page [Navigation.Home])]
          [div [ onClick NavigationHome, id "Navigation-Home" ][text "Accueil"]]
        , Html.td [class (navigationTdClass page [Navigation.Players])]
          [div [ onClick NavigationPlayers, id "Navigation-Players"] [ text "Les joueurs"]]
        , Html.td [class (navigationTdClass page [Navigation.Teams])]
          [div [ onClick NavigationTeams, id "Navigation-Teams"] [ text "Les équipes"]]
        , Html.td [class (navigationTdClass page [Navigation.CurrentLeague Default, Navigation.CurrentLeague LeagueForm])]
          [div [ onClick NavigationCurrentLeague, id "Navigation-Current"] [ text league]]
        , Html.td [class (navigationTdClass page [Navigation.OthersLeagues Default, Navigation.OthersLeagues LeagueForm])]
          [div [ onClick NavigationOthersLeagues, id "Navigation-Others"] [ text "Les autres ligues"]]
        , Html.td [class (navigationTdClass page [Navigation.Help])]
          [div [ onClick NavigationHelp, id "Navigation-Help"] [ text "Aide d'utilisation"]]
        ]
      ]
    ]
  ]

navigationTdClass : Navigation -> List Navigation -> String
navigationTdClass selected expected =
  if (List.member selected expected) then
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
      CurrentLeague subNavigation ->
        viewCurrentLeague model.userModel.profile.rights subNavigation model.leaguesModel
      OthersLeagues subNavigation ->
        viewOthersLeagues subNavigation model
      Help ->
        viewHelp model

--
-- Bas de page
--

infoFooter : Html Msg
infoFooter =
    footer [ class "infoFooter" ] [ p [] [ text "Copyright Julien Perrot 2017" ] ]
