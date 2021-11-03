module Main exposing (..)

import Html exposing (..)
import Http exposing (send)

import Msg exposing (..)
import Model exposing (..)
import View exposing (..)
import Actions exposing (..)

import LeaguesDecoder exposing (decoderLeague)

import Addresses exposing (..)

import LinkToJS exposing (..)

-- Main
main : Program Never Model Msg
main =
  Html.program
  { init = init Model.defaultModel
  , update = update
  , view = view
  , subscriptions = subscriptions
  }

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    --Sub.none
    Sub.batch
        [ LinkToJS.confirmDeleteLeague ConfirmDeleteLeague
        , LinkToJS.confirmDeleteTournament ConfirmDeleteTournament
          --, WebSocket.listen (model.modelURL) (NewSimuState << Json.Decode.decodeString Decoders.timerResponseDecode)--, LinkToJS.scenarioSelected ScenarioSelected
        ]

-- INIT
init : Model -> (Model, Cmd Msg)
init model =
  ( model, Http.send CurrentLeagueLoaded (Http.get currentLeagueUrl decoderLeague) )
