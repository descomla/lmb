module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Lazy exposing (lazy, lazy2)
import Browser exposing(Document)

import Msg exposing (..)
import Model exposing (..)
import Route exposing (..)
import Time exposing (..)

import ViewUserInfo exposing (viewUserInfo)
import ViewLeague exposing (viewCurrentLeague, viewOthersLeagues)
import ViewNavigation exposing (viewNavigation)
import ViewConfiguration exposing (viewConfiguration)
import ViewHelp exposing (viewHelp)
import ViewPlayers exposing (viewPlayers)
import ViewTeams exposing (viewTeams)
import ViewHome exposing (viewHome)
import ViewError exposing (viewError)

view : Model -> Document Msg
view model =
    { title = "Ligue de Monobasket"
    , body =
      [ lazy ViewNavigation.viewNavigation model
      , lazy2 ViewUserInfo.viewUserInfo model.session model.sessionInput
      , lazy ViewError.viewError model.error
      , lazy viewContainer (viewContent model)
      , infoFooter model
      ]
    }

viewContainer : Html Msg -> Html Msg
viewContainer content =
    div [ id "div-container" ] [ content ]

viewContent : Model -> Html Msg
viewContent model =
    case model.route of
      Home ->
        viewHome model
      Players ->
        viewPlayers model
      Teams ->
        viewTeams model
      CurrentLeague s{--subNavigation--} ->
        viewCurrentLeague model
      OthersLeagues s{--subNavigation--} ->
        viewOthersLeagues model --subNavigation model
      Configuration ->
        viewConfiguration model
      Help ->
        viewHelp model

--
-- Bas de page
--

infoFooter : Model -> Html Msg
infoFooter model =
  let
    year = String.fromInt (Time.toYear model.zone model.time)
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

    day    = formatDateTimeFigure (Time.toDay    model.zone model.time)
    hour   = formatDateTimeFigure (Time.toHour   model.zone model.time)
    minute = formatDateTimeFigure (Time.toMinute model.zone model.time)
    second = formatDateTimeFigure (Time.toSecond model.zone model.time)
  in
    footer [ class "infoFooter" ]
      [ p []
        [ text (day ++ " " ++ month ++ " " ++ year ++ " " ++ hour ++ ":" ++ minute ++ ":" ++ second) ]
      ]

formatDateTimeFigure : Int -> String
formatDateTimeFigure i =
  if i < 10 then
    "0" ++ (String.fromInt i)
  else
    (String.fromInt i)
