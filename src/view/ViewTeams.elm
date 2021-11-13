module ViewTeams exposing (viewTeams)

import Html exposing (..)

import Model exposing (..)
import Msg exposing (..)

import ViewUnderConstruction exposing (viewUnderConstruction)

viewTeams: Model -> Html Msg
viewTeams model =
  viewUnderConstruction "Les équipes" model
