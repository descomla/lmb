module ViewLeague exposing (viewCurrentLeague, viewOthersLeagues)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onMouseOver )
import Html.Lazy exposing (lazy, lazy2)

import Table exposing (..)
import TableActionButtons exposing (..)
import Toolbar exposing (..)

import Msg exposing (..)
import Model exposing (..)
import Route exposing (..)

import LeaguesPages exposing (..)
import TournamentsModel exposing (..)

import UserRights exposing (..)

import LeaguesModel exposing (..)
import LeagueType exposing (..)

-- debugString : LeaguesModel -> String
-- debugString model =
--   let
--     currentIdAsString = toString model.currentLeague.id
--     leaguesNames = List.intersperse ", " (List.map .name model.leagues)
--     leaguesIds = List.map .id model.leagues
--     leaguesIdsAsStrings = List.intersperse ", " (List.map toString leaguesIds)
--   in
--     " League " ++ currentIdAsString ++ " was not found in\n" ++ (String.concat leaguesIdsAsStrings) ++ "\n"  ++ (String.concat leaguesNames) ++ "\n"
--
{--

CurrentLeague navigation page display

--}
viewCurrentLeague : UserRights -> LeaguesPages -> LeaguesModel -> Html Msg
viewCurrentLeague rights page model =
    case page of
      Default ->
        viewCurrentLeagueDefault rights model
      CreateTournament league_id ->
        viewCreateTournament league_id
      others ->
        viewCurrentLeagueDefault rights model

viewCurrentLeagueDefault : UserRights -> LeaguesModel -> Html Msg
viewCurrentLeagueDefault rights model =
  let
    currentLeague = getCurrentLeague model
  in
    viewLeagueDisplay rights currentLeague True

viewLeagueDisplay : UserRights -> League -> Bool -> Html Msg
viewLeagueDisplay rights league isCurrentLeague =
  div [ class "corps" ]
    [ div [ class "fullWidth" ]
      [ div [ class "titre" ] [ text league.name ] ] -- Titre
    , div [ class "fullWidth" ] -- Content
      [ div [ class "texte "]
        [ div [ class "soustitre" ][ text "Tournois" ] -- Sous-titre
        , br [][]
        , div [ id "tournois.liste", class "texte" ]
          [ -- Debug -- text ("Nb Tournaments = " ++ (toString (List.length currentLeague.tournaments)))]
          lazy2 viewTournamentTable rights league.tournaments ]
        ]
      , br [][]
      , lazy2 viewToolbar rights [ toolbarButtonCreateTournament league.id  ] -- Create tournament action button
      , br [][]
      , div [ class "texte "]
        [ div [ class "soustitre" ][ text "Classement" ] -- Sous-titre
        , br [][]
        , div [ id "classement", class "texte" ]
          [ -- Debug -- text "Classement = "
          lazy viewClassementTable league ]
        ]
      , br [][]
      , if isCurrentLeague then
          lazy2 viewToolbar rights [ toolbarButtonModifyLeague league.id ] -- actions toolbar
        else
          lazy2 viewToolbar rights [ toolbarButtonModifyLeague league.id, toolbarButtonBackToLeaguesList ] -- actions toolbar
      ]
    ]

toolbarButtonCreateTournament : Int -> ToolbarButton
toolbarButtonCreateTournament league_id =
  { buttonId = "ligues.creation.tournoi"
  , labelId = "createTournamentButton"
  , msg = OpenTournamentForm league_id
  , caption = "Création d'un nouveau tournoi pour cette ligue"
  , minimalRights = Director
  }

toolbarButtonModifyLeague : Int -> ToolbarButton
toolbarButtonModifyLeague league_id =
  { buttonId = "ligue.modifie.ligue"
  , labelId = "modifyLeagueButton"
  , msg = OpenLeagueForm league_id
  , caption = "Modification de la ligue"
  , minimalRights = Director
  }

toolbarButtonCreateLeague : ToolbarButton
toolbarButtonCreateLeague =
  { buttonId = "ligue.creation.ligue"
  , labelId = "createLeagueButton"
  , msg = OpenLeagueForm 0
  , caption = "Création d'une nouvelle ligue"
  , minimalRights = Director
  }

toolbarButtonBackToLeaguesList : ToolbarButton
toolbarButtonBackToLeaguesList =
  { buttonId = "ligue.retour.ligues"
  , labelId = "backToLeaguesListButton"
  , msg = RouteChanged OthersLeagues
  , caption = "Retour à la liste des ligues"
  , minimalRights = Visitor
  }

{--

List of tournaments for a league

--}
-- Leagues table
viewTournamentTable : UserRights -> Tournaments -> Html Msg
viewTournamentTable rights tournois =
    Table.view (tournamentTableConfig rights) (Table.initialSort "Nom du tournoi") tournois

-- Leagues table configuration
tournamentTableConfig : UserRights -> Table.Config Tournament Msg
tournamentTableConfig rights =
  Table.customConfig
  { toId = .name
  , toMsg = noSorter
  , columns =
    [ Table.veryCustomColumn
      { name = "Nom du tournoi"
      , viewData = tournamentNameToHtmlDetails
      , sorter = Table.unsortable
      }
    , Table.veryCustomColumn
      { name = "Nombre d'équipe maximum"
      , viewData = tournamentMaxTeamsToHtmlDetails
      , sorter = Table.unsortable
      }
    , tournamentImgActionList rights "Actions" .id
    ]
    , customizations = tableCustomizations
  }

noSorter : State -> Msg
noSorter state =
  NoOp

tournamentNameToHtmlDetails : Tournament -> HtmlDetails msg
tournamentNameToHtmlDetails tournois =
    stringToHtmlDetails tournois.name

tournamentMaxTeamsToHtmlDetails : Tournament -> HtmlDetails msg
tournamentMaxTeamsToHtmlDetails tournois =
    stringToHtmlDetails (String.fromInt tournois.maxTeams)

tournamentImgActionList : UserRights -> String -> (data -> Int) -> Column data Msg
tournamentImgActionList rights name toInt =
   Table.veryCustomColumn
     { name = name
     , viewData = (tournamentActionsDetails rights) << toInt
     , sorter = Table.unsortable
     }

tournamentActionsDetails : UserRights -> Int -> HtmlDetails Msg
tournamentActionsDetails rights i =
  renderActionButtons rights
    [ actionButton "EditTournament" (DisplayTournament i) "img/validate.png" Visitor
    , actionButton "DeleteTournament" (DeleteTournament i) "img/delete.png" Director
    ]

{--

Classement

--}
viewClassementTable : League -> Html Msg
viewClassementTable league =
  div [][]

{--

CurrentLeague navigation page display

--}
viewOthersLeagues : LeaguesPages -> Model -> Html Msg
viewOthersLeagues page model =
    case page of
      Default ->
        viewLeaguesList model.session.rights model.leaguesModel
      LeagueInputForm ->
        viewLeagueForm model.leaguesModel
      CreateTournament league_id ->
        viewCreateTournament league_id
      LeagueContent league_id ->
        viewLeagueDisplay model.session.rights (getLeague league_id model.leaguesModel) False
      TournamentContent tournament_id ->
        div [][]

{--

List of existing leagues

--}
viewLeaguesList : UserRights -> LeaguesModel -> Html Msg
viewLeaguesList rights model =
  div [ class "corps" ]
    [ div [ class "fullWidth" ]
      [ div [ class "titre" ] [ text "Les ligues / matchs" ] ]
    , div [ class "fullWidth" ]
      [ div [ class "texte" ]
        [
          label [][ text "Chercher une ligue :" ]
        , input
          [
            class "champTexte"
            , id "ligues.recherche.ligue"
            , maxlength 255
            , size 8
            , style "min-width" "300px"
            , onInput LeaguesFilterChange
            , type_ "text"
            , placeholder "nom de la ligue"
          ] []
        ]
        , br [][]
        , div [ id "ligues.liste", class "texte" ]
          [ lazy2 viewLeagueTable rights model ]
        , br [][]
        , lazy2 viewToolbar rights [ toolbarButtonCreateLeague  ] -- Create tournament action button
      ]
    ]

-- Leagues table
viewLeagueTable : UserRights -> LeaguesModel -> Html Msg
viewLeagueTable rights model =
  let
    -- filter By name
    lowerFilter =
      String.toLower model.leagueFilter

    acceptableLeagues =
      List.filter (String.contains lowerFilter << String.toLower << .name) model.leagues

  in
    Table.view (leagueTableConfig rights) model.sortState acceptableLeagues

-- Leagues table configuration
leagueTableConfig : UserRights -> Table.Config League Msg
leagueTableConfig rights =
  Table.customConfig
  { toId = .name
  , toMsg = LeaguesSortChange
  , columns =
    [ Table.dataToStringColumn "NOM DE LA LIGUE" leagueNameToHtmlDetails .name
    , Table.dataToStringColumn "TYPE DE LIGUE" leagueTypeToHtmlDetails leagueToLeagueTypeString
    , Table.dataToIntColumn "NB TOURNOIS CLASSEMENT" leagueTournamentsToHtmlDetails leagueTournamentsToInt
    , (leagueImgActionList rights) "ACTIONS" .id
    ]
    , customizations = tableCustomizations
  }

-- Handle conversion from LeagueType to HtmlDetails msg
leagueNameToHtmlDetails : League -> HtmlDetails msg
leagueNameToHtmlDetails league =
    stringToHtmlDetails league.name

leagueToLeagueTypeString : League -> String
leagueToLeagueTypeString league =
  leagueTypeToDisplayString league.kind

-- Handle conversion from LeagueType to HtmlDetails msg
leagueTypeToHtmlDetails : League -> HtmlDetails msg
leagueTypeToHtmlDetails league =
    stringToHtmlDetails (leagueToLeagueTypeString league)

-- Handle conversion from List to number of its elements as a string
leagueTournamentsToHtmlDetails : League -> HtmlDetails Msg
leagueTournamentsToHtmlDetails league =
    stringToHtmlDetails (String.fromInt (leagueTournamentsToInt league))

-- Handle conversion from List to number of its elements as a string
leagueTournamentsToInt : League -> Int
leagueTournamentsToInt league =
    league.nbRankingTournaments

tableCustomizations : Customizations data msg
tableCustomizations =
  { tableAttrs = [class "tableau_recherche"]
  , caption = Nothing
  , thead = tableThead
  , tfoot = Nothing
  , tbodyAttrs = []
  , rowAttrs = tableRowAttrs
  }

tableThead : List (String, Status, Attribute msg) -> HtmlDetails msg
tableThead headers =
  HtmlDetails [] (List.map tableTheadHelp headers)

-- Handle conversion from LeagueType to HtmlDetails msg
stringToHtmlDetails : String -> HtmlDetails msg
stringToHtmlDetails str =
    HtmlDetails [ class "tableau_recherche_td" ] [ Html.text str ]

tableRowAttrs : data -> List (Attribute msg)
tableRowAttrs _ =
  [ class "tableau_recherche_tr" ]

tableTheadHelp : ( String, Status, Attribute msg ) -> Html msg
tableTheadHelp (name, status, onClick) =
    Html.th [ class "tableau_recherche_th", onClick ] (simpleTheadContent name status)

leagueImgActionList : UserRights -> String -> (data -> Int) -> Column data Msg
leagueImgActionList rights name toInt =
   Table.veryCustomColumn
     { name = name
     , viewData = (leagueActionsDetails rights) << toInt
     , sorter = Table.decreasingBy toInt
     }

leagueActionsDetails : UserRights -> Int -> HtmlDetails Msg
leagueActionsDetails rights i =
  renderActionButtons rights
    [ actionButton "EditLeague" (DisplayLeague i) "img/validate.png" Visitor
    , actionButton "DeleteLeague" (DeleteLeague i) "img/delete.png" Director
    ]

{--

League Form

--}
viewLeagueForm : LeaguesModel -> Html Msg
viewLeagueForm model =
  div [ class "corps" ]
  [ div [ class "fullWidth" ]
    [ div [class "titre"]
      [ text "Création / Edition d'une ligue" ]
    ]
  , div [ class "fullWidth" ]
    [ div [ ]--class "texte" ]
      [ text "Libellé de la ligue :"
      , input [ --class "champTexte"
        id "ligue.creamodi.libelle"
        , onInput LeagueFormNameChange
        , placeholder "nom de la ligue"
        , maxlength 255
        , size 50
        , value model.leagueForm.name
        , type_ "text" ][]
      , br [][]
      , text "Type de ligue :"
      , select
        [ id "ligue.creamodi.type"
        , style "width" "50%"
        , onInput LeagueFormKindChange
        ]
        ( List.map leagueTypeOption [SingleEvent, LeagueWithRanking, LeagueWithoutRanking] )
      , br [][]
      , text "Nombre de tournois comptants pour le classement, sur la totalité :"
      , input [ --class "champTexte"
        id "ligue.creamodi.nb_tournoi_class"
        , onInput LeagueFormNbTournamentsChange
        , maxlength 2
        , size 5
        , value (String.fromInt model.leagueForm.nbRankingTournaments)
        , type_ "number"][]
      , br [][]
      , div
        [ class "champ_a_cliquer"
        , onClick ValidateLeagueForm
        , style "cursor" "pointer"
        ]
        [ text "Créer la ligue"]
      , div
        [ class "champ_a_cliquer"
        , onClick CancelLeagueForm
        , style "cursor" "pointer"
        ]
        [ text "Annuler" ]
      ]
    ]
  ]

leagueTypeOption : LeagueType -> Html msg
leagueTypeOption leaguetype =
  option
    [value (leagueTypeToDatabaseString leaguetype)]
    [text (leagueTypeToDisplayString leaguetype)]


{--

Create Tournament Form

--}
viewCreateTournament : Int -> Html Msg
viewCreateTournament league_id =
  div [][]
