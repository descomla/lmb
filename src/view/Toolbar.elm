module Toolbar exposing (viewToolbar, ToolbarButton,
 toolbarButtonValidate, toolbarButtonCancel,
 toolbarButtonCreateLeague, toolbarButtonModifyLeague,
 toolbarButtonCreateTournament, toolbarButtonModifyTournament,
 toolbarButtonBackToLeaguesList, toolbarButtonBackToLeague,
 toolbarButtonCreateTeam)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Msg exposing (..)
import UserRights exposing (..)

import Route exposing (..)

type alias ToolbarButton =
  { buttonId : String
  , labelId : String
  , msg : Msg
  , caption : String
  , img : String -- optional : empty if not required
  , minimalRights : UserRights
  }

--
-- viewToolbar with arguments
--    -> UserRights : the current user UserRights
--    -> List ToolbarButton : a list of toolbar button description
--
viewToolbar : UserRights -> List ToolbarButton -> Html Msg
viewToolbar rights list =
  let
    filtered =
      List.filter (isUpperOrEqualRightsToolbarButton rights) list
    htmlList = List.map viewToolbarButton filtered
  in
    if List.isEmpty htmlList then
      div [][]
    else --TODO ajouter un espace entre les boutons
      div [] htmlList

-- toolbar button Validate
--    validate the Form data
--
toolbarButtonValidate : Msg -> ToolbarButton
toolbarButtonValidate msg =
  { buttonId = "validation"
  , labelId = "validateButton"
  , msg = msg
  , caption = "Valider"
  , img = "img/validate-16x16.png"
  , minimalRights = Director
  }

--
-- toolbar button Validate
--    validate the Form data
--
toolbarButtonCancel : Msg -> ToolbarButton
toolbarButtonCancel msg =
  { buttonId = "cancel"
  , labelId = "cancelButton"
  , msg = msg
  , caption = "Annuler"
  , img = "img/delete-16x16.png"
  , minimalRights = Director
  }

--
-- viewToolbar with arguments
--    -> UserRights : the current user UserRights
--    -> List ToolbarButton : a list of toolbar button description
--
isUpperOrEqualRightsToolbarButton : UserRights -> ToolbarButton -> Bool
isUpperOrEqualRightsToolbarButton current button =
  isUpperOrEqualRights button.minimalRights current

--
-- viewToolbar with arguments
--    -> UserRights : the current user UserRights
--    -> List ToolbarButton : a list of toolbar button description
--
viewToolbarButton : ToolbarButton -> Html Msg
viewToolbarButton button =
  if String.isEmpty button.img then
    div [ id button.buttonId
        , class "champ_a_cliquer"
        --, onMouseOver "this.style.cursor='pointer'"
        , style "cursor" "pointer"
        ]
        [ label [ id button.labelId, onClick button.msg ]
          [ text button.caption ]
        ]
  else
    div [ id button.buttonId, class "image_a_cliquer" ]
        [ Html.button [ id button.buttonId, onClick button.msg ]
          [ img [src button.img, width 15] [] ]
        ]


--
-- toolbar button CreateLeague
--    create a league description
--
toolbarButtonCreateLeague : ToolbarButton
toolbarButtonCreateLeague =
  { buttonId = "ligue.creation.ligue"
  , labelId = "createLeagueButton"
  , msg = LeagueOpenForm 0
  , caption = "Création d'une nouvelle ligue"
  , img = "img/plus-16x16.png"
  , minimalRights = Director
  }

--
-- toolbar button ModifyLeague
--    modify the league description
--    -> Int : the league id
--
toolbarButtonModifyLeague : Int -> ToolbarButton
toolbarButtonModifyLeague league_id =
  { buttonId = "ligue.modifie.ligue"
  , labelId = "modifyLeagueButton"
  , msg = LeagueOpenForm league_id
  , caption = "Modification de la ligue"
  , img = "img/edit-16x16.png"
  , minimalRights = Director
  }

--
-- toolbar button BackToLeagueList
--    route to the OthersLeagues page
--
toolbarButtonBackToLeaguesList : ToolbarButton
toolbarButtonBackToLeaguesList =
  { buttonId = "ligue.retour.ligues"
  , labelId = "backToLeaguesListButton"
  , msg = RouteChanged (OthersLeagues NoQuery)
  , caption = "Retour à la liste des ligues"
  , img = "img/arrow-left-16x16.png"
  , minimalRights = Visitor
  }

--
-- toolbar button CreateTournament
--    creates a tournament for the selected league
--    -> Int : the league id
--    -> Int : the tournament id / 0 for new one
--
toolbarButtonCreateTournament : Int -> ToolbarButton
toolbarButtonCreateTournament league_id =
  { buttonId = "ligues.creation.tournoi"
  , labelId = "createTournamentButton"
  , msg = RouteChanged (CurrentLeague NoQuery) --TODO -TournamentOpenForm league_id 0
  , caption = "Création d'un nouveau tournoi pour cette ligue"
  , img = "img/plus-16x16.png"
  , minimalRights = Director
  }

--
-- toolbar button ModifyTournament
--    modify a tournament for the selected league
--    -> Int : the league id
--    -> Int : the tournament id / 0 for new one
--
toolbarButtonModifyTournament : Int -> Int -> ToolbarButton
toolbarButtonModifyTournament league_id tournament_id =
  { buttonId = "ligues.modify.tournoi"
  , labelId = "modifyTournamentButton"
  , msg = TournamentOpenForm tournament_id
  , caption = "Modification du tournoi"
  , img = "img/edit-16x16.png"
  , minimalRights = Director
  }

--
-- toolbar button BackToLeague
--    route to the CurrentLeague or OthersLeagues
--
toolbarButtonBackToLeague : Int -> Bool -> ToolbarButton
toolbarButtonBackToLeague league_id fromCurrentLeague =
  { buttonId = "ligue.retour.ligue"
  , labelId = "backToLeagueButton"
  , msg =
    if fromCurrentLeague then
      RouteChanged (CurrentLeague NoQuery)
    else
      RouteChanged (OthersLeagues (QueryLeague league_id))
  , caption = "Retour à la ligue"
  , img = "img/arrow-left-16x16.png"
  , minimalRights = Visitor
  }

--
-- toolbar button CreateTeam
--    creates a team
--
toolbarButtonCreateTeam : ToolbarButton
toolbarButtonCreateTeam =
  { buttonId = "team.creation"
  , labelId = "createTeamButton"
  , msg = TeamOpenForm 0
  , caption = "Création d'une nouvelle équipe"
  , img = "img/plus-16x16.png"
  , minimalRights = Director
  }

--
