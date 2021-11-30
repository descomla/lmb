module PhaseForm exposing (..)

import Date exposing (..)
import DateCodec exposing (..)

import Phase exposing (..)

--
-- PhaseForm
--
type alias PhaseForm =
  { displayed : Bool
  , id : Int
  , tid : Int
  , name : String
  , datetxt : String
  , date : Maybe Date
  , typ : PhaseType
  }

defaultPhaseForm : PhaseForm
defaultPhaseForm =
  { displayed = False
  , id = 0
  , tid = 0
  , name = ""
  , datetxt = ""
  , date = Nothing
  , typ = PoulePhase defaultPouleData
  }

initPhaseForm : Int -> Phase -> PhaseForm
initPhaseForm tid phase =
    { displayed = True
    , id = phase.id
    , tid = tid
    , name = phase.name
    , datetxt = DateCodec.date2displayString phase.date
    , date = phase.date
    , typ = phase.parameters
    }

convertPhase : PhaseForm -> Phase
convertPhase phase =
  { id = phase.id
  , name = phase.name
  , date = phase.date
  , parameters = phase.typ
  }
{--

    SETTERS

--}
setPhaseFormId : Int -> PhaseForm -> PhaseForm
setPhaseFormId i phaseForm =
  { phaseForm | id = i  }

setPhaseFormName : String -> PhaseForm -> PhaseForm
setPhaseFormName s phaseForm =
  { phaseForm | name = s  }

setPhaseFormDate : String -> PhaseForm -> PhaseForm
setPhaseFormDate d phaseForm =
  let
    withDate = { phaseForm | datetxt = d }
  in
    { withDate | date = displayString2date d }

setPhaseFormType : PhaseType -> PhaseForm -> PhaseForm
setPhaseFormType p phaseForm =
  case p of
    PoulePhase p_in ->
      case phaseForm.typ of
        PoulePhase p_current ->
          phaseForm -- same type => no change
        _ ->
          { phaseForm | typ = PoulePhase defaultPouleData } -- reste form for poules
    EliminationPhase p_in ->
      case phaseForm.typ of
        EliminationPhase p_current ->
          phaseForm -- same type => no change
        _ ->
          { phaseForm | typ = EliminationPhase defaultEliminationData } -- reste form for poules
    FreePhase ->
      { phaseForm | typ = FreePhase } -- reste form for poules

{--

    SETTERS for Poule Data

--}
setPouleFormNbPoules : Int -> PhaseForm -> PhaseForm
setPouleFormNbPoules n phaseForm =
  case phaseForm.typ of
    PoulePhase poule -> -- the type is the samed as required
      { phaseForm | typ = PoulePhase (setNbPoules n poule) }
    _ ->
      phaseForm

setPouleFormNbPeriod : Int -> PhaseForm -> PhaseForm
setPouleFormNbPeriod n phaseForm =
  case phaseForm.typ of
    PoulePhase poule -> -- the type is the samed as required
      { phaseForm | typ = PoulePhase ( poule |> setPouleNbPeriod n ) }
    _ ->
      phaseForm

setPouleFormDuration : Int -> PhaseForm -> PhaseForm
setPouleFormDuration n phaseForm =
  case phaseForm.typ of
    PoulePhase poule -> -- the type is the samed as required
      { phaseForm | typ = PoulePhase ( poule |> setPoulePeriodDuration n ) }
    _ ->
      phaseForm

{--

    SETTERS for Elimination Data

--}
setEliminationFormNbTeams : Int -> PhaseForm -> PhaseForm
setEliminationFormNbTeams n phaseForm =
  case phaseForm.typ of
    EliminationPhase data -> -- the type is the samed as required
      { phaseForm | typ = EliminationPhase (data |> setNbTeams n) }
    _ ->
      phaseForm

setEliminationFormNbPeriod : Int -> EliminationStage -> PhaseForm -> PhaseForm
setEliminationFormNbPeriod n stage phaseForm =
  case phaseForm.typ of
    EliminationPhase data -> -- the type is the samed as required
      { phaseForm | typ = EliminationPhase ( data |> setStageNbPeriod n stage ) }
    _ ->
      phaseForm

setEliminationFormDuration : Int -> EliminationStage -> PhaseForm -> PhaseForm
setEliminationFormDuration n stage phaseForm =
  case phaseForm.typ of
    EliminationPhase data -> -- the type is the samed as required
      { phaseForm | typ = EliminationPhase ( data |> setStagePeriodDuration n stage ) }
    _ ->
      phaseForm
