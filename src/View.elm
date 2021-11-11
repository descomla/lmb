module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Lazy exposing (lazy, lazy2)

import Msg exposing (..)
import Model exposing (..)
import Route exposing (..)

import LeaguesPages exposing (..)

import ViewCommon exposing (..)
import ViewUserInfo exposing (viewUserInfo)
import ViewLeague exposing (viewCurrentLeague, viewOthersLeagues)
import ViewNavigation exposing (viewNavigation)
import ViewHelp exposing (viewHelp)
import ViewPlayers exposing (viewPlayers)
import ViewTeams exposing (viewTeams)
import ViewHome exposing (viewHome)
import ViewError exposing (viewError)

view : Model -> Html Msg
view model =
    div []
      [ lazy ViewNavigation.viewNavigation model
      , lazy2 ViewUserInfo.viewUserInfo model.session model.sessionInput
      , lazy ViewError.viewError model
      , lazy ViewCommon.viewContainer (viewContent model)
      , infoFooter
      ]

viewContent : Model -> Html Msg
viewContent model =
    case model.route of
      Home ->
        viewHome model
      Players ->
        viewPlayers model
      Teams ->
        viewTeams model
      CurrentLeague {--subNavigation--} ->
        viewCurrentLeague model.session.rights LeaguesPages.Default model.leaguesModel
      OthersLeagues {--subNavigation--} ->
        viewOthersLeagues LeaguesPages.Default model --subNavigation model
      Help ->
        viewHelp model

--
-- Bas de page
--

infoFooter : Html Msg
infoFooter =
    footer [ class "infoFooter" ] [ p [] [ text "Copyright Julien Perrot 2017" ] ]
