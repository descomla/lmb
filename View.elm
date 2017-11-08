module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Lazy exposing (lazy, lazy2)
import Html.Events exposing (..)

import Model exposing (..)
import Actions exposing (..)
import Navigation exposing (..)

import ViewUserInfo exposing (viewUserInfo)

view : Model -> Html Msg
view model =
  div []
    [ lazy viewNavigation "LMB 2017-2018" -- TODO To get from a config file or something else
    , lazy ViewUserInfo.viewUserInfo model.user
    , lazy viewContainer model
    , infoFooter
    ]

-- Navigation Toolbar
viewNavigation : String -> Html Msg
viewNavigation league =
  nav [ id "nav-toolbar" ]
    [ div [ class "navigation" ]
    [ Html.table []
      [ Html.tr []
        [ Html.td [] [div [ onClick NavigationHome, id "Navigation-Home" ][text "Accueil"]]
        , Html.td [] [div [ onClick NavigationPlayers, id "Navigation-Players"] [ text "Les joueurs"]]
        , Html.td [] [div [ onClick NavigationTeams, id "Navigation-Teams"] [ text "Les équipes"]]
        , Html.td [] [div [ onClick NavigationCurrentLeague, id "Navigation-Current"] [ text league]]
        , Html.td [] [div [ onClick NavigationOthersLeagues, id "Navigation-Others"] [ text "Les autres ligues"]]
        , Html.td [] [div [ onClick NavigationHelp, id "Navigation-Help"] [ text "Aide d'utilisation"]]
        ]
      ]
    ]
  ]

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
        viewHome model-- viewPlayers model
      Teams ->
        viewHome model-- viewTeams model
      CurrentLeague ->
        viewHome model-- viewCurrentLeague model
      OthersLeagues ->
        viewHome model-- viewOthersLeagues model
      Help ->
        viewHome model-- viewHelp model

viewHome : Model -> Html Msg
viewHome model =
  div [ class "fullWidth" ]
    [ div [ class "texte", style [("text-align","center")] ]
      [ text " Bienvenue sur le site du monobasket français."
      , br [][]
      , text "Le but de celui-ci est de rassembler les documents, et les résultats des championnats, matchs, tournois de monobasket en France"
      , br [][]
      , text "Le site est actuellement en construction, particulièrement sur la partie design et 'présentation'"
      , br [][]
      , text "Si vous rencontrez un bug sur le site, n'hésitez pas à m'en faire part pour correction,"
      , a [href "mailto:lmb@monocycle.info"][text "par mail"]
      ]
    ]

--
-- Bas de page
--

infoFooter : Html Msg
infoFooter =
    footer [ class "infoFooter" ] [ p [] [ text "Copyright Julien Perrot 2017" ] ]
