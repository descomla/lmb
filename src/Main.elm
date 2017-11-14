module Main exposing (..)

import Html exposing (..)

import Msg exposing (..)
import Model exposing (..)
import View exposing (..)
import Actions exposing (..)

--import LinkToJS exposing (..)

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
    Sub.none
    --Sub.batch
    --    [ -- WebSocket.listen (model.modelURL) (NewSimuState << Json.Decode.decodeString Decoders.timerResponseDecode)
          --LinkToJS.decodeFromXML DecodeFromXML
          --, LinkToJS.scenarioSelected ScenarioSelected
          --, LinkToJS.validateScenario ValidateScenario
          --, LinkToJS.validateProject ValidateProject
    --    ]

-- INIT
init : Model -> (Model, Cmd Msg)
init model =
  ( model, Cmd.none )--Http.send UserProfilesLoaded (Http.get usersUrl decoderUserProfiles) )
