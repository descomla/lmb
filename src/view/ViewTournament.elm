module ViewTournament exposing (viewTournament)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onMouseOver )
import Html.Lazy exposing (lazy, lazy2, lazy3, lazy4)

import Time exposing (Month(..))

import Color exposing (..)
import Colors exposing (toCssString)

import Table exposing (..)
import TableCommon exposing (..)
import TableActionButtons exposing (..)

import Toolbar exposing (..)

import Msg exposing (..)
import Model exposing (..)
import Route exposing (..)

import UserRights exposing (..)

import Tournaments exposing (Tournament, Tournaments, getTournament)

import Phase exposing (..)
import Poule exposing (..)

import Teams exposing (Teams, Team)

import DateCodec exposing (date2displayString)

import ViewError exposing (..)
import ViewTournamentPhaseForm exposing (viewTournamentPhaseForm)
import ViewTournamentPouleForm exposing (viewTournamentPouleForm)

{--
--
-- View Tournament
--
--}
viewTournament : Int -> Bool -> Model.Model -> Html Msg
viewTournament tournament_id isCurrentLeague model =
  if model.tournamentsModel.phaseForm.displayed then
    model.tournamentsModel.phaseForm |> viewTournamentPhaseForm model.session.rights
  else if model.tournamentsModel.pouleForm.displayed then
    model.tournamentsModel.pouleForm |> viewTournamentPouleForm model.session.rights
  else
    mainViewTournament tournament_id isCurrentLeague model

mainViewTournament : Int -> Bool -> Model.Model -> Html Msg
mainViewTournament tournament_id isCurrentLeague model =
  let
    (mb_tournament, error) = getTournament tournament_id model.tournamentsModel.tournaments
  in
    case mb_tournament of
      Nothing -> viewError error
      Just tournament ->
        div [ class "fullWidth" ]
          [ div [ class "titre" ] -- Titre
            [ text tournament.name
            , lazy2 viewToolbar model.session.rights
              [ toolbarButtonBackToLeague tournament.league_id isCurrentLeague ]
            ]
          , div [ class "paragraphe" ]
            [ div [ class "soustitre" ] [ text "Equipe(s) inscrite(s) au tournoi" ] -- Titre
            , viewTournamentTeams tournament model.teamsModel.teams model.session.rights
            , viewTournamentTeamSelection tournament_id model
            , br [] []
            , div [ class "soustitre" ]
              [ text "Phases du tournoi" -- Titre
              , lazy2 viewToolbar model.session.rights
                [ toolbarButtonCreateTournamentPhase tournament.league_id tournament_id ]
              ]
            , viewTournamentPhases model.session.rights tournament
            , br [] []
            , div [ class "soustitre" ] [ text "Classement du tournoi" ] -- Titre
            , viewTournamentClassement tournament
--          , div [ class "paragraphe" ]
--            [ lazy2 viewToolbar model.session.rights
--              [ toolbarButtonModifyTournament tournament.league_id tournament_id ]
            ]
          ]

{--
--
-- View Tournament Teams
--
--}
viewTournamentTeams : Tournament -> Teams -> UserRights -> Html Msg
viewTournamentTeams tournament teams rights =
  if (List.length tournament.teams) > 0 then
    let
      tournamentTeams = List.filter (\t -> List.member t.id tournament.teams) teams
    in
      div [ ]
        ( List.map (viewTournamentTeam rights tournament) tournamentTeams )
  else
    div [ class "paragraphe" ] [ text "Aucune équipe inscrite au tournoi." ]

-- Display a team name with its own color
viewTournamentTeam : UserRights -> Tournament -> Team -> Html Msg
viewTournamentTeam rights tournament team =
  div
    [ class "paragraphe", style "color" (Colors.toCssString team.colors) ]
    [ text team.name
    , actionImg "img/trash-16x16.png" (TournamentRemoveTeam tournament.id team.id) rights Director
    ]

-- filter teams list
filterTeams : String -> Team -> Bool
filterTeams s team =
  let
    str = String.toLower s
    name = String.toLower team.name
  in
    String.contains str name

-- View Tournament Teams Selection
viewTournamentTeamSelection : Int -> Model.Model -> Html Msg
viewTournamentTeamSelection tournament_id model =
  let
    (mb_tournament, error) = getTournament tournament_id model.tournamentsModel.tournaments
  in
    case mb_tournament of
      Nothing ->
          viewError error
      Just tournament ->
        if (List.length model.teamsModel.teams) > 0 then
          if (isUpperOrEqualRights Director model.session.rights) then
            div [ class "paragraphe" ]
              [ div []
                [ text "Chercher une équipe à ajouter : "
                , Html.input [ type_ "text", id "team.name.filter", onInput TeamFilterNameChange, placeholder "", value model.teamsModel.teamFilter ][]
                ]
                , if String.isEmpty model.teamsModel.teamFilter then
                    div [ style "visibility" "hidden" ][]
                  else
                    let
                      result = List.filter (filterTeams model.teamsModel.teamFilter) model.teamsModel.teams
                    in
                      if List.isEmpty result then
                        div [ style "visibility" "hidden" ][]
                      else
                        lazy3 viewTeamsSelectionTable model.session.rights tournament result
              ]
          else --> Pas suffisamment de droits pour gérer les équipes
            div [][]
        else --> Si aucune équipe
          div [ class "paragraphe" ] [ text "Pour ajouter des équipes au tournoi, il faut d'abord en créer dans 'Les Equipes'." ]

-- View Teams Selection Table
viewTeamsSelectionTable : UserRights -> Tournament -> Teams -> Html Msg
viewTeamsSelectionTable rights tournament teams =
    Table.view (teamsTableConfig rights tournament.id) (Table.initialSort "Equipes") teams


-- Teams table configuration
teamsTableConfig : UserRights -> Int -> Table.Config Team Msg
teamsTableConfig rights tournament_id =
  Table.customConfig
  { toId = .name
  , toMsg = noSorter
  , columns =
    [ Table.veryCustomColumn
      { name = "Equipes"
      , viewData = teamNameToHtmlDetails
      , sorter = Table.unsortable
      }
    , addTeamImgActionList rights "" tournament_id .id
    ]
    , customizations = tableCustomizations
  }

teamNameToHtmlDetails : Team -> HtmlDetails msg
teamNameToHtmlDetails team =
    stringToHtmlDetails team.name


addTeamImgActionList : UserRights -> String -> Int -> (data -> Int) -> Column data Msg
addTeamImgActionList rights name tournament_id toInt =
   Table.veryCustomColumn
     { name = name
     , viewData = (addTeamActionsDetails rights tournament_id) << toInt
     , sorter = Table.unsortable
     }

addTeamActionsDetails : UserRights -> Int -> Int -> HtmlDetails Msg
addTeamActionsDetails rights tournament_id team_id =
  renderActionButtons rights
    [ actionButton "AddTeam" (TournamentAddTeam tournament_id team_id) "img/plus-16x16.png" Director
    ]

{--
--
-- View Tournament Phase
--
--}
viewTournamentPhases : UserRights -> Tournament -> Html Msg
viewTournamentPhases rights tournament =
  if (List.length tournament.phases) > 0 then
    div [ ]
      ( List.map (viewPhase rights tournament.id) tournament.phases )
  else
    div [ ] [ text "Aucune phase n'a été crée pour ce tournoi." ]

phaseHeader : Phase -> String
phaseHeader phase =
  let
    phaseid = "Phase " ++ (String.fromInt phase.id)
    phasedate = date2displayString phase.date
  in
    (phaseid ++ " : " ++ phase.name ++ " (" ++ phasedate ++ ")")

-- Display a single phase
viewPhase : UserRights -> Int -> Phase -> Html Msg
viewPhase rights tournament_id phase =
  div [ class "paragraphe" ]
    [ div [ class "soustitre" ] -- Titre
      [ text (phaseHeader phase)
      , actionImg "img/trash-16x16.png" (TournamentPhaseDelete tournament_id phase.id) rights Director
      ]
    , case phase.parameters of
        PoulePhase data ->
          lazy4 viewPoulePhaseContent rights tournament_id phase.id data
        EliminationPhase data ->
          lazy4 viewEliminationPhaseContent rights tournament_id phase.id data
        FreePhase ->
          lazy3 viewFreePhaseContent rights tournament_id phase.id
    , br [][]
    , lazy2 viewToolbar rights
      [ toolbarButtonPrintAll tournament_id phase.id
      -- Résolution des règles
      ]
    ]

-- Poule phase info
poulePhaseInfo : PouleData -> String
poulePhaseInfo data =
  let
    defaultInfos =
      [ String.fromInt data.nbPoules
      , " poule(s), matchs en "
      , String.fromInt data.matchDuration.nbPeriod
      , " période(s) de "
      , String.fromInt data.matchDuration.periodDuration
      , " minutes"
      ]
    expanded =
      if data.nbPoules > List.length data.poules then
        [ " : reste "
        , String.fromInt (data.nbPoules - List.length data.poules)
        , " poule(s) à créer."
        ]
      else
        []
  in
    String.concat (List.append defaultInfos expanded)

-- Display a single poule phase
viewPoulePhaseContent : UserRights -> Int -> Int -> PouleData -> Html Msg
viewPoulePhaseContent rights tournament_id phase_id data =
  div [ class "paragraphe" ]
    [ text (poulePhaseInfo data)
    , br [][]
    , if List.isEmpty data.poules then
        text "Aucune poule n'a encore été créée !!!"
      else
        lazy4 viewPoulesTable rights tournament_id phase_id data
    , lazy2 viewToolbar rights
      (List.filter (\t -> (List.length data.poules) < data.nbPoules )
        [ toolbarButtonCreatePoule tournament_id phase_id ])
    ]

-- Table for Phase poules
viewPoulesTable : UserRights -> Int -> Int -> PouleData -> Html Msg
viewPoulesTable rights tournament_id phase_id data =
  Table.view (poulesTableConfig rights tournament_id phase_id) (Table.initialSort "Libellé") data.poules

-- Phase poules table configuration
poulesTableConfig : UserRights -> Int -> Int -> Table.Config Poule Msg
poulesTableConfig rights tournament_id phase_id =
  Table.customConfig
  { toId = .name
  , toMsg = noSorter
  , columns =
    [ Table.veryCustomColumn
      { name = "Libellé"
      , viewData = pouleNameToHtmlDetails
      , sorter = Table.unsortable
      }
    , Table.veryCustomColumn
      { name = "Etat"
      , viewData = pouleStateToHtmlDetails
      , sorter = Table.unsortable
      }
    , Table.veryCustomColumn
      { name = "Matchs\n(prévus/joués)"
      , viewData = pouleMatchsToHtmlDetails
      , sorter = Table.unsortable
      }
    , Table.veryCustomColumn
      { name = "Equipes"
      , viewData = pouleTeamsToHtmlDetails
      , sorter = Table.unsortable
      }
    , pouleImgActionList rights "Actions" tournament_id phase_id .id
    ]
    , customizations = tableCustomizations
  }

pouleNameToHtmlDetails : Poule -> HtmlDetails msg
pouleNameToHtmlDetails poule =
  stringToHtmlDetails poule.name

pouleStateToHtmlDetails : Poule -> HtmlDetails msg
pouleStateToHtmlDetails poule =
  stringToHtmlDetails
    (case poule.status of
      Pending -> "En attente"
      Running -> "En cours"
      Terminated -> "Terminée")

pouleMatchsToHtmlDetails : Poule -> HtmlDetails msg
pouleMatchsToHtmlDetails poule =
  stringToHtmlDetails "TODO : matchs prévus / joués"

pouleTeamsToHtmlDetails : Poule -> HtmlDetails msg
pouleTeamsToHtmlDetails poule =
  stringToHtmlDetails "TODO : liste des équipes"

pouleImgActionList : UserRights -> String -> Int -> Int ->(data -> Int) -> Column data Msg
pouleImgActionList rights name tournament_id phase_id toInt =
   Table.veryCustomColumn
     { name = name
     , viewData = (pouleActionsDetails rights tournament_id phase_id) << toInt
     , sorter = Table.unsortable
     }

pouleActionsDetails : UserRights -> Int -> Int -> Int -> HtmlDetails Msg
pouleActionsDetails rights tournament_id phase_id poule_id =
  renderActionButtons rights
    [ actionButton "EditPoule" (PouleDisplay tournament_id phase_id poule_id) "img/arrow-right-16x16.png" Visitor
    , actionButton "DeletePoule" (PouleDelete tournament_id phase_id poule_id) "img/trash-16x16.png" Director
    ]


-- Display a single Elimination phase
viewEliminationPhaseContent : UserRights -> Int -> Int -> EliminationData -> Html Msg
viewEliminationPhaseContent rights tournament_id phase_id data =
  div [ class "paragraphe" ]
    [ br [][]
    ]

-- Display a single free phase
viewFreePhaseContent : UserRights -> Int -> Int -> Html Msg
viewFreePhaseContent rights tournament_id phase_id =
  div [ class "paragraphe" ]
    [ br [][]
    ]

{--
--
-- View Tournament Classement
--
--}
viewTournamentClassement : Tournament -> Html Msg
viewTournamentClassement tournament =
  viewError "Classement à implémenter"
