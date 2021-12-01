module ViewTournamentPhaseForm exposing (viewTournamentPhaseForm)

import Html exposing (..)
import Html.Attributes exposing (class, id, min, max, type_, value, size, placeholder, maxlength, selected, style)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy2)

import Msg exposing (..)

import UserRights exposing (..)

import Toolbar exposing (..)

import Date exposing (..)
import DateCodec exposing (..)

import PhaseFormEvent exposing (..)
import PhaseForm exposing (..)
import Phase exposing (..)

import MatchDuration exposing (..)

{--
--
-- View Tournament Phase
--
--}
viewTournamentPhaseForm : UserRights -> PhaseForm -> Html Msg
viewTournamentPhaseForm rights phaseForm =
  div [ class "corps" ]
    [ div [ class "titre" ] [ text "Création / Edition d'une phase" ] -- Titre
    --
    -- Champ Name
    --
    , div [ class "paragraphe" ]
      [ text "Libellé de la phase : "
      , Html.input
        [ id "phaseCreamodiLibelle"
        , onInput (\s -> TournamentPhaseFormEvent (PhaseFormEvent.PhaseNameChange s))
        , placeholder "nom de la phase"
        , maxlength 255
        , size 25
        , value phaseForm.name
        , type_ "text"
        ]
        []
      ]
    --
    -- Champ Date
    --
    , div [ class "paragraphe" ]
      [ text "Date : "
      , Html.input
        [ id "phaseCreamodiDate"
        , onInput (\s -> TournamentPhaseFormEvent (PhaseFormEvent.PhaseDateChange s))
        , placeholder "01/01/2020"
        , maxlength 10
        , size 10
        , value phaseForm.datetxt
        , type_ "text"
        ]
        []
      , text " (jj/mm/aaaa)"
      ]
    --
    -- Choix du type
    --
    , div [ class "paragraphe" ]
      [ text "Type : "
      , select
        [ id "phaseCreamodiType"
        , onInput (\s ->
          TournamentPhaseFormEvent (PhaseFormEvent.PhaseTypeChange (phaseTypeFromValueString s)))
        ]
        ( List.map phaseTypeOption
          [ FreePhase
          , PoulePhase defaultPouleData-- Nombre de Poules + MatchDuration
          , EliminationPhase defaultEliminationData-- Nombre d'équipes
          ]
        )
      ]
    --
    -- Détail des paramètres de la phase
    -- en fonction du choix du type
    --
    , viewSpecificForm phaseForm
    --
    -- Boutons Validate / Cancel
    --
    , div [ class "paragraphe" ]
      [ lazy2 viewToolbar rights
        [ toolbarButtonValidate TournamentPhaseValidateForm
        , toolbarButtonCancel TournamentPhaseCancelForm
        ]
      ]
    ]

phaseTypeOption : PhaseType -> Html msg
phaseTypeOption phasetype =
  option
    [value (phaseTypeToValueString phasetype)]
    [text (phaseTypeToDisplayString phasetype)]

-- Handle conversion from PhaseType to String
phaseTypeToDisplayString : PhaseType -> String
phaseTypeToDisplayString t =
  case t of
    PoulePhase o ->
      "Poules"
    EliminationPhase o ->
      "Tableau"
    FreePhase ->
      "Matchs libres"

-- Handle conversion from PhaseType to String
phaseTypeToValueString : PhaseType -> String
phaseTypeToValueString t =
  case t of
    PoulePhase o ->
      "Poules"
    EliminationPhase o ->
      "Elimination"
    FreePhase ->
      "Free"

-- Handle conversion from LeagueType to String
phaseTypeFromValueString : String -> PhaseType
phaseTypeFromValueString s =
  if s == "Poules" then
    PoulePhase defaultPouleData
  else if s == "Elimination" then
    EliminationPhase defaultEliminationData
--  else if s == "Free" then
  else
    FreePhase

-- View Phase Form depending on the type selected
viewSpecificForm : PhaseForm -> Html Msg
viewSpecificForm phaseForm =
  div [ class "paragraphe" ]
    (case phaseForm.typ of
      PoulePhase poule -> -- Nombre de Poules + MatchDuration
        poulePhaseForm poule
      EliminationPhase elimination -> -- Nombre d'équipes
        -- + MatchDuration pour chaque étape
        eliminationPhaseForm elimination
      FreePhase ->
        [ Html.text "" ]
    )

--
-- Détail des paramètres pour une Phase de poules
--
poulePhaseForm : PouleData -> List (Html Msg)
poulePhaseForm poule =
  --
  -- Champ Nombre de poules
  --
  [ div [ class "paragraphe" ]
    [ text "Nombre de poules : "
    , Html.input
      [ id "phaseCreamodiNbPoule"
      , onInput (\s -> TournamentPhaseFormEvent (PhaseFormEvent.PhaseNbPouleChange (String.toInt s)))
      , placeholder "1"
      , maxlength 2
      , size 2
      , value (Debug.log "poulePhaseForm NbPoules =" (String.fromInt poule.nbPoules) )
      , type_ "number"
      ]
      []
    ]
  --
  -- Champ Nombre de périodes
  --
  , div [ class "paragraphe" ]
    [ text "Nombre de périodes d'un match : "
    , Html.input
      [ id "phaseCreamodiNbPeriods"
      , onInput (\s -> TournamentPhaseFormEvent (PhaseFormEvent.PhaseNbPeriodChange (String.toInt s)))
      , placeholder "4"
      , maxlength 1
      , size 2
      , value (String.fromInt poule.matchDuration.nbPeriod)
      , type_ "number"
      ]
      []
    ]
  --
  -- Champ Durée d'une période
  --
  , div [ class "paragraphe" ]
    [ text "Durée d'une période d'un match : "
    , Html.input
      [ id "phaseCreamodiPeriodDuration"
      , onInput (\s -> TournamentPhaseFormEvent (PhaseFormEvent.PhaseDurationChange (String.toInt s)))
      , placeholder "10"
      , maxlength 2
      , size 2
      , value (String.fromInt poule.matchDuration.periodDuration)
      , type_ "number"
      ]
      []
    , text "min"
    ]
  ]

eliminationPhaseForm : EliminationData -> List (Html Msg)
eliminationPhaseForm elimination =
  let
    -- Champ Nombre de poules
    nbTeamsForm = eliminationPhaseNbTeams elimination
    -- Liste des étapes en fonction du nombre d'équipes
    stages = List.filter (\s ->
        case s of
          StageFinale -> (elimination.nbTeams >= 2)
          StageLittleFinale -> (elimination.nbTeams >= 2)
          StageSemiFinale ->  (elimination.nbTeams >= 4)
          StageQuarterFinale ->  (elimination.nbTeams >= 8)
          StageEighthFinale ->  (elimination.nbTeams >= 16)
          StageSixteenthFinale ->  (elimination.nbTeams >= 32)
      )
      [ StageFinale, StageLittleFinale, StageSemiFinale
      , StageQuarterFinale, StageEighthFinale, StageSixteenthFinale
      ]
    -- Champ nb period pour chaque étape
    stagesForm = List.map (\s ->
      div [ class "paragraphe" ]
        [ Html.text (labelStage s)
        , Html.text " - Nombre de périodes : "
        , eliminationPhasePeriod s (getStageConfiguration s elimination)
        , Html.text " Durée d'une période : "
        , eliminationPhaseDuration s (getStageConfiguration s elimination)
        ])
        stages
    in
      nbTeamsForm :: stagesForm

eliminationPhaseNbTeams : EliminationData -> Html Msg
eliminationPhaseNbTeams elimination =
  div [ class "paragraphe" ]
    [ text "Nombre d'équipes : "
    , select
      [ id "phaseCreamodiNbTeams"
      , onInput (\s ->
        TournamentPhaseFormEvent (PhaseFormEvent.PhaseNbTeamsChange (Maybe.withDefault elimination.nbTeams (String.toInt s))))
      ]
      (List.map (nbTeamsOption elimination.nbTeams) [2, 4, 8, 16, 32])
    ]

nbTeamsOption : Int -> Int -> Html msg
nbTeamsOption expected n =
  option
    [ value (String.fromInt n), selected (expected == n) ]
    [ text (String.fromInt n) ]

eliminationPhasePeriod : EliminationStage -> MatchDuration -> Html Msg
eliminationPhasePeriod stage param =
  Html.input
    [ id ("phaseCreamodiNbPeriods" ++ (stageId stage))
    , onInput (\s -> TournamentPhaseFormEvent (PhaseFormEvent.PhaseEliminationNbPeriodChange stage (String.toInt s)))
    , placeholder "4"
    , maxlength 1
    , size 2
    , value (String.fromInt param.nbPeriod)
    , type_ "number"
    ]
    []

eliminationPhaseDuration : EliminationStage -> MatchDuration -> Html Msg
eliminationPhaseDuration stage param =
  Html.input
    [ id ("phaseCreamodiDuration" ++ (stageId stage))
    , onInput (\s -> TournamentPhaseFormEvent (PhaseFormEvent.PhaseEliminationDurationChange stage (String.toInt s)))
    , placeholder "4"
    , maxlength 1
    , size 2
    , value (String.fromInt param.periodDuration)
    , type_ "number"
    ]
    []

labelStage : EliminationStage -> String
labelStage stage =
  case stage of
    StageFinale -> "Finale"
    StageLittleFinale -> "Petite finale"
    StageSemiFinale -> "Demi-finale"
    StageQuarterFinale -> "Quart de finale"
    StageEighthFinale -> "Huitième de finale"
    StageSixteenthFinale -> "Seizième de finale"

stageId : EliminationStage -> String
stageId stage =
  case stage of
    StageFinale -> "Finale"
    StageLittleFinale -> "LittleFinale"
    StageSemiFinale -> "SemiFinale"
    StageQuarterFinale -> "QuarterFinale"
    StageEighthFinale -> "EighthFinale"
    StageSixteenthFinale -> "SixteenthFinale"
