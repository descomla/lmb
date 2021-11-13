module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Lazy exposing (lazy, lazy2)
import Browser exposing(Document)

import Msg exposing (..)
import Model exposing (..)
import Route exposing (..)
import Time exposing (..)

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

view : Model -> Document Msg
view model =
    { title = "Ligue de Monobasket"
    , body = [ div []
        [ lazy ViewNavigation.viewNavigation model
        , lazy2 ViewUserInfo.viewUserInfo model.session model.sessionInput
        , lazy ViewError.viewError model
        , lazy ViewCommon.viewContainer (viewContent model)
        , infoFooter model
        ]
      ]
    }

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

infoFooter : Model -> Html Msg
infoFooter model =
  let
    year   = String.fromInt (Time.toYear   model.zone model.time)

    month  = case (Time.toMonth  model.zone model.time) of
      Jan -> "Janvier"
      Feb -> "Février"
      Mar -> "Mars"
      Apr -> "Avril"
      May -> "Mai"
      Jun -> "Juin"
      Jul -> "Juillet"
      Aug -> "Août"
      Sep -> "Septembre"
      Oct -> "Octobre"
      Nov -> "Novembre"
      Dec -> "Décembre"

    day    = String.fromInt (Time.toDay    model.zone model.time)
    hour   = String.fromInt (Time.toHour   model.zone model.time)
    minute = String.fromInt (Time.toMinute model.zone model.time)
    second = String.fromInt (Time.toSecond model.zone model.time)
  in
    footer [ class "infoFooter" ]
      [ p []
        [ text (day ++ "/" ++ month ++ "/" ++ " " ++ hour ++ ":" ++ minute ++ ":" ++ second) ]
      ]
