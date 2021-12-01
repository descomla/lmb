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

import DatabaseRequests exposing (retrieveLeagues, retrieveCurrentLeague)

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
        , LinkToJS.confirmDeleteTournament TournamentConfirmDelete
        , LinkToJS.confirmDeleteTeam TeamConfirmDelete
        , LinkToJS.confirmRemoveTournamentTeam TournamentConfirmRemoveTeam
        , LinkToJS.confirmDeletePhase TournamentPhaseConfirmDelete
        , LinkToJS.confirmDeletePoule PouleConfirmDelete
          --, WebSocket.listen (model.modelURL) (NewSimuState << Json.Decode.decodeString Decoders.timerResponseDecode)--, LinkToJS.scenarioSelected ScenarioSelected
        ]

-- INIT
init : () -> Url.Url -> Browser.Navigation.Key -> (Model, Cmd Msg)
init flags url key =
  ( initModel url (Debug.log "initModel key " key)
    , Cmd.batch
      [ Task.perform AdjustZone Time.here
      , DatabaseRequests.retrieveLeagues
      , DatabaseRequests.retrieveCurrentLeague
      , DatabaseRequests.retrieveTournaments
      , DatabaseRequests.retrieveTeams
      ]
  )
