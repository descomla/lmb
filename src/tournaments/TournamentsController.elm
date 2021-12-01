module TournamentsController exposing (..)

import TournamentsModel exposing (..)
import Tournaments exposing (..)
import PhaseFormEvent exposing (..)
import PhaseForm exposing (..)
import Phase exposing (..)
import PouleFormEvent exposing (..)
import PouleForm exposing (..)
import Poule exposing (..)


-- update Phase Form events
updatePhaseForm : PhaseFormEvent -> TournamentsModel -> ( TournamentsModel, String )
updatePhaseForm msg model =
  case msg of
    -- Open the form for new phase
    AddPhase tournament_id ->
      let
        (mb_tournament, err_tournament) = getTournament tournament_id model.tournaments
      in
        case mb_tournament of
          Nothing -> ( model, err_tournament )
          Just tournoi ->
            let
              phase_id = ( List.length tournoi.phases ) + 1
            in
              ( { model | phaseForm =
                    initPhaseForm tournament_id ( defaultPhase |> setPhaseId phase_id ) }
                , "" )
    -- change the phase name
    PhaseNameChange name ->
      ( { model | phaseForm = model.phaseForm |> setPhaseFormName name }, "" )
    -- change the phase date
    PhaseDateChange date -> -- input date
      ( { model | phaseForm = model.phaseForm |> setPhaseFormDate date }, "" )
    -- change the phase type
    PhaseTypeChange t -> -- input parameters
      ( { model | phaseForm = model.phaseForm |> setPhaseFormType t }, "" )
    PhaseNbPouleChange v -> -- input poules nb poules
      case v of
        Nothing ->
          ( model, "Le nombre de poule doit être un nombre entier !" )
        Just n ->
          ( { model | phaseForm = model.phaseForm |> setPouleFormNbPoules n }, "" )
    PhaseNbPeriodChange v -> -- input poules nb period
      case v of
        Nothing ->
          ( model, "Le nombre de périodes doit être un nombre entier !" )
        Just n ->
          ( { model | phaseForm = model.phaseForm |> setPouleFormNbPeriod n }, "" )
    PhaseDurationChange v -> -- input poules period duration
      case v of
        Nothing ->
          ( model, "La durée d'une période doit être un nombre entier !" )
        Just n ->
          ( { model | phaseForm = model.phaseForm |> setPouleFormDuration n }, "" )
    PhaseNbTeamsChange n -> -- input elimination nb teams
        ( { model | phaseForm = model.phaseForm |> setEliminationFormNbTeams n }, "" )
    PhaseEliminationNbPeriodChange stage v -> -- input elimination stage nb period
      case v of
        Nothing ->
          ( model, "Le nombre de périodes doit être un nombre entier !" )
        Just n ->
          ( { model | phaseForm = model.phaseForm |> setEliminationFormNbPeriod n stage }, "" )
    PhaseEliminationDurationChange stage v -> -- input elimination stage period duration
      case v of
        Nothing ->
          ( model, "La durée d'une période doit être un nombre entier !" )
        Just n ->
          ( { model | phaseForm = model.phaseForm |> setEliminationFormDuration n stage }, "" )

validatePhaseForm : PhaseForm -> Tournaments -> (Maybe Tournament, String)
validatePhaseForm phaseForm tournaments =
  if String.isEmpty phaseForm.name then
    ( Nothing, "Nom de la phase obligatoire !!" )
  else if phaseForm.date == Nothing then
    ( Nothing, "Format de date incorrect !!" )
  else
    let
      (mb_tournament, error) = tournaments |> getTournament phaseForm.tid
    in
      case mb_tournament of
        Nothing -> ( Nothing, error )
        Just tournament ->
          let
            newPhase = convertPhase phaseForm
          in
            if tournament.phases |> containsPhase newPhase then
              ( Just { tournament | phases = tournament.phases |> updatePhase newPhase }, "" )
            else
              let -- fill the phase with appropriate data
                phase =
                  case newPhase.parameters of
                    PoulePhase data ->
                      { newPhase | parameters = PoulePhase ( createDefaultPoules data ) }
                    _ ->
                      newPhase
              in
                ( Just { tournament | phases =  List.append tournament.phases (List.singleton phase)}, "" )

-- create poules
createDefaultPoules : PouleData -> PouleData
createDefaultPoules data =
  { data | poules =
    List.map (\n ->
       setPouleName ("Poule " ++ (String.fromInt n))(setPouleId n defaultPoule))
        (List.range 1 data.nbPoules) }


-- update Poule Form events
updatePouleForm : PouleFormEvent -> TournamentsModel -> ( TournamentsModel, String )
updatePouleForm msg model =
  case msg of
    -- Open the form for new poule
    AddPoule tournament_id phase_id ->
      let
        (mb_tournament, err_tournament) = getTournament tournament_id model.tournaments
      in
        case mb_tournament of
          Nothing -> ( model, err_tournament )
          Just tournament ->
            let
              (mb_phase, err_phase) = getPhase phase_id tournament.phases
            in
              case mb_phase of
                Nothing -> ( model, err_phase )
                Just phase ->
                  case phase.parameters of
                    PoulePhase pouleData ->
                      if (List.length pouleData.poules) < pouleData.nbPoules then
                        let
                          poule_id =  ( List.length pouleData.poules ) + 1
                        in
                        ( { model | pouleForm =
                            initPouleForm tournament_id phase_id ( defaultPoule |> setPouleId poule_id ) }
                          , "" )
                      else
                        ( model, "Nombre maximum de poules atteint !" )
                    _ ->
                      ( model, "La phase n'est pas une phase de poules !" )
    -- change the poule name
    PouleNameChange name -> -- input name
      ( { model | pouleForm = model.pouleForm |> setPouleFormName name }, "" )
    -- change the phase type
    PouleVictoryPointsChange v -> -- input nb points
      case v of
        Nothing ->
          ( model, "Le nombre de point doit être un nombre entier !" )
        Just n ->
          ( { model | pouleForm = model.pouleForm |> setPouleFormVictory n }, "" )
    PouleDefeatPointsChange v -> -- input nb points
      case v of
        Nothing ->
          ( model, "Le nombre de point doit être un nombre entier !" )
        Just n ->
          ( { model | pouleForm = model.pouleForm |> setPouleFormDefeat n }, "" )
    PouleNullPointsChange v -> -- input nb points
      case v of
        Nothing ->
          ( model, "Le nombre de point doit être un nombre entier !" )
        Just n ->
          ( { model | pouleForm = model.pouleForm |> setPouleFormNull n }, "" )
    PouleGoalAveragePointsChange v -> -- input nb points
      case v of
        Nothing ->
          ( model, "Le nombre de point doit être un nombre entier !" )
        Just n ->
          ( { model | pouleForm = model.pouleForm |> setPouleFormGoalAverage n }, "" )

{--
-- Validate Poule Form
--    - Int tournament_id
--    - Int phase_id
--    - PouleForm pouleData
--    - Tournaments tournaments
--    -> (Maybe Tournament, String)
--}
validatePouleForm : PouleForm -> Tournaments -> (Maybe Tournament, String)
validatePouleForm pouleForm tournaments =
  if String.isEmpty pouleForm.name then
    ( Nothing, "Nom de la poule obligatoire !!" )
  else
    let
      (mb_tournament, err_t) = tournaments |> getTournament pouleForm.tid
    in
      case mb_tournament of
        Nothing -> ( Nothing, err_t)
        Just tournament ->
          let
            (mb_phase, err_ph) = tournament.phases |> getPhase pouleForm.pid
          in
            case mb_phase of
              Nothing -> ( Nothing, err_ph )
              Just phase ->
                let
                  (newPhase, error) = phase |> setPhasePoule (convertPoule pouleForm)
                in
                  if String.isEmpty error then
                    ( Just { tournament | phases = tournament.phases |> updatePhase newPhase }, "" )
                  else
                    ( Nothing, error )

{--
-- Delete Poule
--    - Int tournament_id
--    - Int phase_id
--    - Int poule_id
--    - Tournaments tournaments
--    -> (Maybe Tournament, String)
--}
deletePoule : Int -> Int -> Int -> Tournaments -> (Maybe Tournament, String)
deletePoule tournament_id phase_id poule_id tournaments =
  let -- récupération du tournoi
    (mb_tournament, error_tournament) = getTournament tournament_id tournaments
  in
    case mb_tournament of
      Nothing ->
        ( Nothing, error_tournament )
      Just tournament ->
        let
          (mb_phase, error_phase) = Phase.getPhase phase_id tournament.phases
        in
          case mb_phase of
            Nothing ->
              ( Nothing, error_phase )
            Just phase ->
              let
                (phase_result, error_poule) = phase |> removePhasePoule poule_id
              in
                ( Just { tournament | phases = tournament.phases |> updatePhase phase_result }, error_poule )

{--
-- Delete Phase
--    - Int tournament_id
--    - Int phase_id
--    - Tournaments tournaments
--    -> (Maybe Tournament, String)
--}
deletePhase : Int -> Int -> Tournaments -> (Maybe Tournament, String)
deletePhase tournament_id phase_id tournaments =
  let -- récupération du tournoi
    (mb_tournament, error_tournament) = getTournament tournament_id tournaments
  in
    case mb_tournament of
      Nothing ->
        ( Nothing, error_tournament )
      Just tournament ->
        ( Just { tournament | phases = tournament.phases |> removePhase phase_id }, "" )
