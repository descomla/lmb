module ViewPlayers exposing (viewPlayers)

import Html exposing (..)

import Model exposing (..)
import Msg exposing (..)

import ViewUnderConstruction exposing (viewUnderConstruction)

viewPlayers : Model -> Html Msg
viewPlayers model =
  viewUnderConstruction "Les Joueurs" model
