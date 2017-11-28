module ViewLeague exposing (viewCurrentLeague, viewOthersLeagues)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onMouseOver )
import Html.Lazy exposing (lazy, lazy2)

import Table exposing (..)
import Toolbar exposing (..)

import Msg exposing (..)
import Model exposing (..)

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
          lazy viewTournamentTable league.tournaments ]
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
  , msg = NavigationCreateTournament league_id
  , caption = "Création d'un nouveau tournoi pour cette ligue"
  , minimalRights = Director
  }

toolbarButtonModifyLeague : Int -> ToolbarButton
toolbarButtonModifyLeague league_id =
  { buttonId = "ligue.modifie.ligue"
  , labelId = "modifyLeagueButton"
  , msg = NavigationModifyLeague league_id
  , caption = "Modification de la ligue"
  , minimalRights = Director
  }

toolbarButtonCreateLeague : ToolbarButton
toolbarButtonCreateLeague =
  { buttonId = "ligue.creation.ligue"
  , labelId = "createLeagueButton"
  , msg = NavigationCreateLeague
  , caption = "Création d'une nouvelle ligue"
  , minimalRights = Director
  }

toolbarButtonBackToLeaguesList : ToolbarButton
toolbarButtonBackToLeaguesList =
  { buttonId = "ligue.retour.ligues"
  , labelId = "backToLeaguesListButton"
  , msg = NavigationOthersLeagues
  , caption = "Retour à la liste des ligues"
  , minimalRights = Visitor
  }

{--

List of tournaments for a league

--}
-- Leagues table
viewTournamentTable : Tournaments -> Html Msg
viewTournamentTable tournois =
    Table.view tournamentTableConfig (Table.initialSort "Nom du tournoi") tournois

-- Leagues table configuration
tournamentTableConfig : Table.Config Tournament Msg
tournamentTableConfig =
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
    , tournamentImgActionList "Actions" .id
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
    stringToHtmlDetails (toString tournois.maxTeams)

tournamentImgActionList : String -> (data -> Int) -> Column data Msg
tournamentImgActionList name toInt =
   Table.veryCustomColumn
     { name = name
     , viewData = tournamentActionsDetails << toInt
     , sorter = Table.unsortable
     }

tournamentActionsDetails : Int -> HtmlDetails Msg
tournamentActionsDetails i =
    HtmlDetails [ class "image_a_cliquer"]
    [ actionButton "EditTournament" (NavigationDisplayTournament i) "img/validate.png"
    , actionButton "DeleteTournament" (TournamentDeleteAction i) "img/delete.png"
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
        viewLeaguesList model.userModel.profile.rights model.leaguesModel
      LeagueForm ->
        viewLeagueForm model.leaguesModel
      CreateTournament league_id ->
        viewCreateTournament league_id
      DisplayLeague league_id ->
        viewLeagueDisplay model.userModel.profile.rights (getLeague league_id model.leaguesModel) False
      DisplayTournament tournament_id ->
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
      [ div [ class "texte" ] [
        label [][ text "Chercher une ligue :" ]
        , input [
          class "champTexte"
          , id "ligues.recherche.ligue"
          , maxlength 255
          , size 8
          , style [("min-width", "300px")]
          , onInput LeaguesFilterChange
          , type_ "text"
          , placeholder "nom de la ligue"
          ] []
        ]
        , br [][]
        , div [ id "ligues.liste", class "texte" ] [ lazy viewLeagueTable model ]
        , br [][]
        , lazy2 viewToolbar rights [ toolbarButtonCreateLeague  ] -- Create tournament action button
      ]
    ]

-- Leagues table
viewLeagueTable : LeaguesModel -> Html Msg
viewLeagueTable model =
  let
    -- filter By name
    lowerFilter =
      String.toLower model.leagueFilter

    acceptableLeagues =
      List.filter (String.contains lowerFilter << String.toLower << .name) model.leagues

  in
    Table.view leagueTableConfig model.sortState acceptableLeagues

-- Leagues table configuration
leagueTableConfig : Table.Config League Msg
leagueTableConfig =
  Table.customConfig
  { toId = .name
  , toMsg = LeaguesSortChange
  , columns =
    [ Table.dataToStringColumn "NOM DE LA LIGUE" leagueNameToHtmlDetails .name
    , Table.dataToStringColumn "TYPE DE LIGUE" leagueTypeToHtmlDetails leagueToLeagueTypeString
    , Table.dataToIntColumn "NB TOURNOIS CLASSEMENT" leagueTournamentsToHtmlDetails leagueTournamentsToInt
    , leagueImgActionList "ACTIONS" .id
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
    stringToHtmlDetails (toString (leagueTournamentsToInt league))

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

leagueImgActionList : String -> (data -> Int) -> Column data Msg
leagueImgActionList name toInt =
   Table.veryCustomColumn
     { name = name
     , viewData = leagueActionsDetails << toInt
     , sorter = Table.decreasingBy toInt
     }

leagueActionsDetails : Int -> HtmlDetails Msg
leagueActionsDetails i =
    HtmlDetails [ class "image_a_cliquer"]
    [ actionButton "EditLeague" (NavigationDisplayLeague i) "img/validate.png"
    , actionButton "DeleteLeague" (LeagueDeleteAction i) "img/delete.png"
    ]

actionButton : String -> msg -> String -> Html msg
actionButton ident msg imgSrc =
    Html.button
        [ id ident, onClick msg ]
        [ img [src imgSrc, width 15][] ]


{--

League Form

--}
viewLeagueForm : LeaguesModel -> Html Msg
viewLeagueForm model =
  div [ class "corps" ]
  [ div [ class "fullWidth" ][ div [class "titre"][text "Création / Edition d'une ligue"] ]
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
      , select [ id "ligue.creamodi.type"
        , style [("width", "50%")]
        , onInput LeagueFormKindChange
        ]
         (List.map leagueTypeOption [SingleEvent, LeagueWithRanking, LeagueWithoutRanking])
      , br [][]
      , text "Nombre de tournois comptants pour le classement, sur la totalité :"
      , input [ --class "champTexte"
        id "ligue.creamodi.nb_tournoi_class"
        , onInput LeagueFormNbTournamentsChange
        , maxlength 2
        , size 5
        , value (toString model.leagueForm.nbRankingTournaments)
        , type_ "number"][]
      , br [][]
      , div [ class "champ_a_cliquer"
        {--, onmouseover "this.style.cursor='pointer'"--}
        , onClick LeagueFormCreate
        , style [("cursor","pointer")]
        ]
        [ text "Créer la ligue"]
      , div [ class "champ_a_cliquer"
        {--, onmouseover "this.style.cursor='pointer'"--}
        , onClick NavigationOthersLeagues
        , style [("cursor","pointer")]
        ]
        [text "Annuler"]
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
