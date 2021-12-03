module PouleFormEvent exposing (..)

import Date exposing (Date)
import Poule exposing (Poule)

type PouleFormEvent
  = AddPoule Int Int -- tournament_id phase_id
  | PouleNameChange String -- input name
  | PouleVictoryPointsChange (Maybe Int) -- input nb points
  | PouleDefeatPointsChange (Maybe Int) -- input nb points
  | PouleNullPointsChange (Maybe Int) -- input nb points
  | PouleGoalAveragePointsChange (Maybe Int) -- input nb points
