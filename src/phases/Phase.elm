module Phase exposing (..)

import Date exposing (Date)
import Time exposing (Month(..))
import MatchDuration exposing (..)
import Poule exposing (..)

type PhaseType
  = PoulePhase PouleData -- Nombre de Poules + MatchDuration
  | EliminationPhase EliminationData-- Nombre d'équipes
  | FreePhase


--
-- Phase
--
type alias Phase =
  { id : Int
  , name : String
  , date : Maybe Date
  , parameters : PhaseType
  }

defaultPhase : Phase
defaultPhase =
  { id = 0
  , name = ""
  , date = Nothing
  , parameters = FreePhase
  }

-- Get a phase from its id
getPhase : Int -> List Phase -> (Maybe Phase, String)
getPhase phase_id phases =
  let
    result = List.filter (\p -> p.id == phase_id) phases
  in
    if List.isEmpty result then
      ( Nothing, "Aucune phase #" ++ (String.fromInt phase_id) )
    else if (List.length result) > 1 then
      ( Nothing, "Trop de phases #" ++ (String.fromInt phase_id) )
    else
      case List.head result of
        Nothing ->
          ( Nothing, "La phase #" ++ (String.fromInt phase_id) ++ "n'a pas été trouvée" )
        Just phase ->
          ( Just phase, "" )

-- Get a phase from its id
containsPhase : Phase -> List Phase -> Bool
containsPhase phase phases =
  let
    result = List.filter (\p -> p.id == phase.id) phases
  in
    (List.length result == 1)

-- delete phase
removePhase : Int -> List Phase -> List Phase
removePhase phase_id phases =
  List.filter (\p -> p.id /= phase_id) phases

-- update phase list with a specific phase
updatePhase : Phase -> List Phase -> List Phase
updatePhase phase phases =
  List.map (\p ->
    if p.id == phase.id then
      phase
    else
      p ) phases

-- set a poule for a PoulePhase
setPhasePoule : Poule -> Phase -> (Phase, String)
setPhasePoule poule phase =
  case phase.parameters of
    PoulePhase pouleData ->
      let
        data = { pouleData | poules = pouleData.poules |> createUpdatePoule poule }
      in
        ( { phase | parameters = PoulePhase data }, "")
    _ ->
      (phase, "La phase n'est pas une phase de poules!")

-- remove a poule from a PoulePhase
removePhasePoule : Int -> Phase -> (Phase, String)
removePhasePoule poule_id phase =
  case phase.parameters of
    PoulePhase pouleData ->
      let
        data = { pouleData | poules = pouleData.poules |> removePoule poule_id }
      in
        ({ phase | parameters = PoulePhase data }, "")
    _ ->
      (phase, "Impossible de supprimer une poule dans une phase qui n'est pas une phase de poules!")

setPhaseId : Int -> Phase -> Phase
setPhaseId i phase =
  { phase | id = i }

setPhaseName : String -> Phase -> Phase
setPhaseName s phase =
  { phase | name = s }

setPhaseDate : Maybe Date -> Phase -> Phase
setPhaseDate d phase =
  { phase | date = d }

setPhaseParameters : PhaseType -> Phase -> Phase
setPhaseParameters p phase =
  { phase | parameters = p }

-- temporary data for Poule Phase
type alias PouleData =
  { nbPoules : Int
  , matchDuration : MatchDuration
  , poules : List Poule
  }

defaultPouleData : PouleData
defaultPouleData =
  { nbPoules = 1
  , matchDuration = defaultMatchDuration
  , poules = []
  }

-- Setter Poule.nbPoules
setNbPoules : Int -> PouleData -> PouleData
setNbPoules n data =
  { data | nbPoules = n }

-- Setter Poule.matchDuration.nbPeriod
setPouleNbPeriod : Int -> PouleData -> PouleData
setPouleNbPeriod n data =
  { data | matchDuration = data.matchDuration |> setNbPeriod n }

-- Setter Poule.matchDuration.duration
setPoulePeriodDuration : Int -> PouleData -> PouleData
setPoulePeriodDuration n data =
  { data | matchDuration = data.matchDuration |> setPeriodDuration n }

-- temporary data for Elimination Phase
type alias EliminationData =
  { nbTeams : Int
  , finale : MatchDuration
  , littleFinale : MatchDuration
  , semiFinale : MatchDuration
  , quarterFinale : MatchDuration
  , eighthFinale : MatchDuration
  , sixteenthFinale : MatchDuration
  }

defaultEliminationData : EliminationData
defaultEliminationData =
  { nbTeams = 2
  , finale = defaultMatchDuration
  , littleFinale = defaultMatchDuration
  , semiFinale = defaultMatchDuration
  , quarterFinale = defaultMatchDuration
  , eighthFinale = defaultMatchDuration
  , sixteenthFinale = defaultMatchDuration
  }

type EliminationStage
  = StageFinale
  | StageLittleFinale
  | StageSemiFinale
  | StageQuarterFinale
  | StageEighthFinale
  | StageSixteenthFinale

-- Getter Elimination stage
getStageConfiguration : EliminationStage -> EliminationData -> MatchDuration
getStageConfiguration stage data =
  case stage of
    StageFinale -> data.finale
    StageLittleFinale -> data.littleFinale
    StageSemiFinale -> data.semiFinale
    StageQuarterFinale -> data.quarterFinale
    StageEighthFinale -> data.eighthFinale
    StageSixteenthFinale -> data.sixteenthFinale

-- Setter Elimination.nbTeams
setNbTeams : Int -> EliminationData -> EliminationData
setNbTeams n data =
  { data | nbTeams = n }

-- Setter Elimination stage period duration
setStagePeriodDuration : Int -> EliminationStage -> EliminationData -> EliminationData
setStagePeriodDuration n stage data =
  let
    config = getStageConfiguration stage data
    result = { config | periodDuration = n }
  in
    case stage of
      StageFinale -> { data | finale = config }
      StageLittleFinale -> { data | littleFinale = config }
      StageSemiFinale -> { data | semiFinale = config }
      StageQuarterFinale -> { data | quarterFinale = config }
      StageEighthFinale -> { data | eighthFinale = config }
      StageSixteenthFinale -> { data | sixteenthFinale = config }

-- Setter Elimination stage nb period
setStageNbPeriod : Int -> EliminationStage -> EliminationData -> EliminationData
setStageNbPeriod n stage data =
  let
    config = getStageConfiguration stage data
    result = { config | nbPeriod = n }
  in
    case stage of
      StageFinale -> { data | finale = config }
      StageLittleFinale -> { data | littleFinale = config }
      StageSemiFinale -> { data | semiFinale = config }
      StageQuarterFinale -> { data | quarterFinale = config }
      StageEighthFinale -> { data | eighthFinale = config }
      StageSixteenthFinale -> { data | sixteenthFinale = config }
