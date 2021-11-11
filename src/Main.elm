module Main exposing (..)

import Html exposing (..)
import Http exposing (send)
import Time exposing (..)
import Task exposing (..)

import Json.Decode exposing (..)

import Msg exposing (..)
import Model exposing (..)
import View exposing (..)
import Route exposing (..)
import Actions exposing (..)

import SessionController exposing (..)
import LeaguesDecoder exposing (decoderLeague)

import Addresses exposing (..)

import Navigation exposing (..)
import LinkToJS exposing (..)

-- Main
main =
  Navigation.program LocationChange
  { init = init
  , update = update
  , view = view
  , subscriptions = subscriptions
  }

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    --Sub.none
    Sub.batch
        [ Time.every Time.second TickTime
        , LinkToJS.confirmDeleteLeague ConfirmDeleteLeague
        , LinkToJS.confirmDeleteTournament ConfirmDeleteTournament
          --, WebSocket.listen (model.modelURL) (NewSimuState << Json.Decode.decodeString Decoders.timerResponseDecode)--, LinkToJS.scenarioSelected ScenarioSelected
        ]

-- INIT
init : Navigation.Location -> (Model, Cmd Msg)
init location =
  ( { defaultModel | route = parseURL location }
    , Cmd.batch [
      Task.perform InitTime Time.now
      , Http.send CurrentLeagueLoaded (Http.get databaseCurrentLeagueUrl decoderLeague )
      ]
  )
