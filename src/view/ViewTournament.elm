module ViewTournament exposing (viewTournament)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onMouseOver )
import Html.Lazy exposing (lazy, lazy2, lazy3)

import Color exposing (..)
import Colors exposing (toCssString)

import Table exposing (..)
import TableCommon exposing (..)
import TableActionButtons exposing (..)

import Toolbar exposing (..)

import Msg exposing (..)
import Model exposing (..)
import Route exposing (..)

import LeaguesModel exposing (..)

import UserRights exposing (..)

import Tournaments exposing (Tournament, Tournaments, getTournament)
import Teams exposing (Teams, Team)

import ViewError exposing (..)
import ViewUnderConstruction exposing (..)

{--
--
-- View Tournament
--
--}
viewTournament : Int -> Bool -> Model -> Html Msg
viewTournament tournament_id fromCurrentLeague model =
  let
    result = getTournament tournament_id model.leaguesModel.tournaments
  in
    case result of
      Nothing -> viewError ("Aucun tournoi #" ++ (String.fromInt tournament_id) ++ "trouvé !!")
      Just tournament ->
        div [ class "fullWidth" ]
          [ div [ class "titre" ] [ text tournament.name ] -- Titre
          , div [ class "paragraphe" ]
            [ lazy2 viewToolbar model.session.rights
                [ toolbarButtonModifyTournament tournament.league_id tournament_id ]
            ]
          , br [] []
          , div [ class "soustitre" ] [ text "Equipe(s) inscrite(s) au tournoi" ] -- Titre
          , viewTournamentTeams tournament model.teamsModel.teams
          , viewTournamentTeamSelection tournament_id model
          , br [] []
          , viewTournamentPhases tournament
          , br [] []
          , div [ class "soustitre" ] [ text "Classement du tournoi" ] -- Titre
          , viewTournamentClassement tournament
          , div [ class "paragraphe" ]
            [ lazy2 viewToolbar model.session.rights
              [ toolbarButtonBackToLeague tournament.league_id fromCurrentLeague ]
            ]
          ]

-- View Tournament Teams
viewTournamentTeams : Tournament -> Teams -> Html Msg
viewTournamentTeams tournament teams =
  if (List.length tournament.teams) > 0 then
    let
      tournamentTeams = List.filter (\t -> List.member t.id tournament.teams) teams
    in
      div [ class "paragraphe" ]
        ( List.map viewColoredTeamName tournamentTeams )
  else
    div [ class "paragraphe" ] [ text "Aucune équipe inscrite au tournoi." ]

viewColoredTeamName : Team -> Html Msg
viewColoredTeamName team =
  div
    [ class "paragraphe", style "color" (Colors.toCssString team.colors) ]
    [ text team.name ]

-- View Tournament Teams Selection
viewTournamentTeamSelection : Int -> Model -> Html Msg
viewTournamentTeamSelection tournament_id model =
  case (getTournament tournament_id model.leaguesModel.tournaments) of
    Nothing ->
        viewError ("Tournoi #"++(String.fromInt tournament_id)++" introuvable !!" )
    Just tournament ->
      let
        r = Debug.log "length teams list = " (List.length tournament.teams)
      in
        if (List.length tournament.teams) > 0 then
          if (isUpperOrEqualRights Director model.session.rights) then
            div [ class "paragraphe" ]
              [ div []
                [ text "Chercher une équipe à ajouter : "
                , Html.input [ type_ "text", id "team.name.filter", onInput TeamFilterNameChange, placeholder "", value model.leaguesModel.teamFilter ][]
                ]
                , lazy3 viewTeamsSelectionTable model.session.rights tournament model.teamsModel.teams
              ]
          else --> Pas suffisamment de droits pour gérer les équipes
            div [][]
        else --> Si aucune équipe
          div [ class "paragraphe" ] [ text "Pour ajouter des équipes au tournoi, il faut d'abord en créer dans 'Les Equipes'." ]

-- View Tournament Classement
viewTournamentClassement : Tournament -> Html Msg
viewTournamentClassement tournament =
  viewError "Classement à implémenter"

-- View Tournament Classement
viewTournamentPhases : Tournament -> Html Msg
viewTournamentPhases tournament =
  viewError "Phases à implémenter"

-- View Teams Selection Table
viewTeamsSelectionTable : UserRights -> Tournament -> Teams -> Html Msg
viewTeamsSelectionTable rights tournament teams =
    Table.view (teamsTableConfig rights tournament.id) (Table.initialSort "Equipes") teams


-- Leagues table configuration
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
