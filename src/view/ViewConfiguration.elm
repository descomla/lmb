module ViewConfiguration exposing (viewConfiguration)

import Html exposing (..)

import Model exposing (..)
import Msg exposing (..)

import ViewUnderConstruction exposing (viewUnderConstruction)

viewConfiguration: Model -> Html Msg
viewConfiguration model =
  viewUnderConstruction "Configuration" model
