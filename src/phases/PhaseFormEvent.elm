module PhaseFormEvent exposing (..)

import Date exposing (Date)
import Phase exposing (PhaseType(..), EliminationStage(..))

type PhaseFormEvent
  = AddPhase Int -- tournament_id
  | PhaseNameChange String -- input name
  | PhaseDateChange String -- input date
  | PhaseTypeChange PhaseType -- input parameters
  | PhaseNbPouleChange (Maybe Int) -- input nb poules
  | PhaseNbPeriodChange (Maybe Int) -- input poule nb period
  | PhaseDurationChange (Maybe Int) -- input poule period duration
  | PhaseNbTeamsChange Int -- nb teams
  | PhaseEliminationNbPeriodChange EliminationStage (Maybe Int) -- input poule nb period
  | PhaseEliminationDurationChange EliminationStage (Maybe Int) -- input poule period duration
