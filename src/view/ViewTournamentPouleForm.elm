module ViewTournamentPouleForm exposing (viewTournamentPouleForm)

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
import PouleFormEvent exposing (..)
import PouleForm exposing (..)

import MatchDuration exposing (..)

{--
--
-- View Tournament Phase
--
--}
viewTournamentPouleForm : UserRights -> PouleForm -> Html Msg
viewTournamentPouleForm rights pouleForm =
  div [ class "corps" ]
    [ div [ class "titre" ] [ text "Création / Edition d'une poule" ] -- Titre
    --
    -- Champ Name
    --
    , div [ class "paragraphe" ]
      [ text "Libellé : "
      , Html.input
        [ id "pouleCreamodiLibelle"
        , onInput (\s -> PouleFormInput (PouleFormEvent.PouleNameChange s))
        , placeholder "nom de la poule"
        , maxlength 255
        , size 25
        , value pouleForm.name
        , type_ "text"
        ]
        []
      ]
    --
    -- Champ VictoryPoints
    --
    , div [ class "paragraphe" ]
      [ text "Nombre de points rapportés par une victoire : "
      , Html.input
        [ id "pouleCreamodiVictory"
        , onInput (\s -> PouleFormInput (PouleFormEvent.PouleVictoryPointsChange (String.toInt s)))
        , placeholder "10000"
        , maxlength 6
        , size 6
        , value (String.fromInt pouleForm.pointsVictory)
        , type_ "number"
        ]
        []
      ]
    --
    -- Champ DefeatPoints
    --
    , div [ class "paragraphe" ]
      [ text "Nombre de points rapportés par une défaite : "
      , Html.input
        [ id "pouleCreamodiDefeat"
        , onInput (\s -> PouleFormInput (PouleFormEvent.PouleDefeatPointsChange (String.toInt s)))
        , placeholder "0"
        , maxlength 6
        , size 4
        , value (String.fromInt pouleForm.pointsDefeat)
        , type_ "number"
        ]
        []
      ]
    --
    -- Champ DefeatPoints
    --
    , div [ class "paragraphe" ]
      [ text "Nombre de points rapportés par un match nul : "
      , Html.input
        [ id "pouleCreamodiNull"
        , onInput (\s -> PouleFormInput (PouleFormEvent.PouleNullPointsChange (String.toInt s)))
        , placeholder "100"
        , maxlength 6
        , size 4
        , value (String.fromInt pouleForm.pointsNull)
        , type_ "number"
        ]
        []
      ]
    --
    -- Champ GoalAverage
    --
    , div [ class "paragraphe" ]
      [ text "Nombre de points d'écart maximum comptabilisés lors du goal average : "
      , Html.input
        [ id "pouleCreamodiGoalAverage"
        , onInput (\s -> PouleFormInput (PouleFormEvent.PouleGoalAveragePointsChange (String.toInt s)))
        , placeholder "0"
        , maxlength 6
        , size 4
        , value (String.fromInt pouleForm.goalAverage)
        , type_ "number"
        ]
        []
      ]
    --
    -- Boutons Validate / Cancel
    --
    , div [ class "paragraphe" ]
      [ lazy2 viewToolbar rights
        [ toolbarButtonValidate PouleValidateForm
        , toolbarButtonCancel PouleCancelForm
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
      , value (String.fromInt poule.nbPoules)
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
