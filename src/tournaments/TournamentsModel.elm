module TournamentsModel exposing (..)

import Date exposing (..)

import Tournaments exposing (Tournaments)
import PhaseForm exposing (PhaseForm, defaultPhaseForm)
import PouleForm exposing (PouleForm, defaultPouleForm)
--
-- Tournaments Model
--
type alias TournamentsModel =
  { phaseForm : PhaseForm
  , pouleForm : PouleForm
  , tournaments : Tournaments
  }

defaultTournamentsModel : TournamentsModel
defaultTournamentsModel =
  { phaseForm = defaultPhaseForm
  , pouleForm = defaultPouleForm
  , tournaments = []
  }

-- set Tournaments Data
setTournaments : Tournaments -> TournamentsModel -> TournamentsModel
setTournaments tournois model =
  { model | tournaments = tournois }

closePhaseForm : TournamentsModel -> TournamentsModel
closePhaseForm model =
  { model | phaseForm = defaultPhaseForm }

closePouleForm : TournamentsModel -> TournamentsModel
closePouleForm model =
  { model | pouleForm = defaultPouleForm }
