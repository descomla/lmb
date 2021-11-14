module Main exposing (..)

import Html exposing (..)
import Http exposing (get)
import Time exposing (..)
import Task exposing (..)
import Url exposing (..)
import Browser exposing (..)
import Browser.Navigation exposing (..)

import Json.Decode exposing (..)

import Msg exposing (..)
import Model exposing (..)
import View exposing (..)
import Route exposing (..)
import Actions exposing (..)

import SessionController exposing (..)
import LeaguesController exposing (..)

import Addresses exposing (..)

import LinkToJS exposing (..)

-- Main
main : Program () Model Msg
main =
  Browser.application
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  , onUrlChange = UrlChanged
  , onUrlRequest = LinkClicked
  }

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    --Sub.none
    Sub.batch
        [ Time.every 1000 TickTime
        , LinkToJS.confirmDeleteLeague LeagueConfirmDelete
        , LinkToJS.confirmDeleteTournament ConfirmDeleteTournament
          --, WebSocket.listen (model.modelURL) (NewSimuState << Json.Decode.decodeString Decoders.timerResponseDecode)--, LinkToJS.scenarioSelected ScenarioSelected
        ]

-- INIT
init : () -> Url.Url -> Browser.Navigation.Key -> (Model, Cmd Msg)
init flags url key =
  ( initModel url key
    , Cmd.batch
      [ Task.perform AdjustZone Time.here
      , LeaguesController.retrieveLeagues
      , LeaguesController.retrieveCurrentLeague
      ]
  )
