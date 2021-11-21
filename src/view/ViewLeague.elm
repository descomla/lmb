module ViewLeague exposing (viewCurrentLeague, viewOthersLeagues)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onMouseOver )
import Html.Lazy exposing (lazy, lazy2)

import Table exposing (..)
import TableCommon exposing (..)
import TableActionButtons exposing (..)

import Toolbar exposing (..)

import Msg exposing (..)
import Model exposing (..)
import Route exposing (..)

import UserRights exposing (..)

import League exposing (League)
import LeagueType exposing (..)
import LeaguesPages exposing (..)
import LeaguesModel exposing (LeaguesModel, getLeague, getCurrentLeague, setTournaments, getLeagueTournaments)

import Tournaments exposing (Tournament, Tournaments)

import ViewTournament exposing (..)
import ViewError exposing (..)
import ViewUnderConstruction exposing (..)

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
viewCurrentLeague : Model -> Html Msg
viewCurrentLeague model =
    case model.route of
      CurrentLeague s ->
        case s of
          NoQuery ->
            viewCurrentLeagueDefault model
          QueryTournament i ->
            viewTournament i True model
          others ->
            viewError ("Route " ++ (route2URL model.route) ++ " invalide pour 'Les autres ligues' !!!")
      others ->
        viewError ("Route " ++ (route2URL model.route) ++ " invalide pour 'Ligue courante' !!!")

{--

CurrentLeague navigation page display

--}
viewOthersLeagues : Model -> Html Msg
viewOthersLeagues model =
    case model.route of
      OthersLeagues s ->
        case s of
          NoQuery ->
            viewLeaguesList model.session.rights model.leaguesModel
          QueryLeague league ->
            viewOthersLeaguesDefault league model
          QueryTournament tournament ->
            viewTournament tournament False model
          QueryLeagueTournament league tournament ->
            viewTournament tournament False model

      others ->
        viewError ("Route " ++ (route2URL model.route) ++ " invalide pour 'Les autres ligues' !!!")
{--
      LeagueInputForm ->
        viewLeagueForm model.leaguesModel
      CreateTournament league_id ->
        viewCreateTournament league_id
      LeagueContent league_id ->
        viewLeagueDisplay model.session.rights (getLeague league_id model.leaguesModel) False
      TournamentContent tournament_id ->
--}

viewCurrentLeagueDefault : Model -> Html Msg
viewCurrentLeagueDefault model =
  let
    league = getCurrentLeague model.leaguesModel
  in
    viewLeagueDisplay league True model.leaguesModel model.session.rights

viewOthersLeaguesDefault : Int -> Model -> Html Msg
viewOthersLeaguesDefault league_id model =
  let
    league = getLeague league_id model.leaguesModel
  in
    viewLeagueDisplay league False model.leaguesModel model.session.rights

viewLeagueDisplay : League -> Bool -> LeaguesModel -> UserRights -> Html Msg
viewLeagueDisplay league isCurrentLeague model rights =
  div [ class "fullWidth" ]
    [ div [ class "titre" ] [ text league.name ] -- Titre
    , div [ class "soustitre" ][ text "Tournois" ] -- Sous-titre
    , div [class "paragraphe" ]--class "paragraphe" ]
      [ br [][]
      , div [ id "liste_tournois" ] -- liste des tournois de la ligue
        [ lazy2 viewTournamentTable (getLeagueTournaments league model) rights ]
      , br [][]
      , lazy2 viewToolbar rights [ toolbarButtonCreateTournament league.id  ] -- Create tournament action button
      , br [][]
      ]
    , div [ class "soustitre" ][ text "Classement" ] -- Sous-titre
    , div [ class "paragraphe" ]
      [ br [][]
      , div [ id "classement" ] -- classement de la ligue
        [ lazy viewClassementTable league ]
      , br [][]
      , if isCurrentLeague then -- Modification of the league actions button
          lazy2 viewToolbar rights [ toolbarButtonModifyLeague league.id ]
        else -- Modification of the league actions button + Back to leagues list action button
          lazy2 viewToolbar rights [ toolbarButtonModifyLeague league.id, toolbarButtonBackToLeaguesList ]
      ]
    ]

{--

List of tournaments for a league

--}
-- Leagues table
viewTournamentTable : Tournaments -> UserRights -> Html Msg
viewTournamentTable tournois rights =
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
    [ actionButton "EditTournament" (TournamentDisplay i) "img/arrow-right-16x16.png" Visitor
    , actionButton "DeleteTournament" (TournamentDelete i) "img/delete-16x16.png" Director
    ]

{--

Classement

--}
viewClassementTable : League -> Html Msg
viewClassementTable league =
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
        , Html.input [ type_ "text"
          , id "ligues.recherche.ligue"
          , onInput LeagueFilterChange
          , placeholder "nom de la ligue"
          , value model.leagueFilter
          ] []
        ]
        , br [][]
        , div [ id "ligues.liste", class "paragraphe" ]
          [ lazy2 viewLeagueTable rights model
          , br [][]
          , lazy2 viewToolbar rights [ toolbarButtonCreateLeague  ] -- Create tournament action button
          ]
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
  , toMsg = LeagueSortChange
  , columns =
    [ Table.dataToStringColumn "NOM DE LA LIGUE" leagueNameToHtmlDetails .name
    , Table.dataToStringColumn "TYPE DE LIGUE" leagueTypeToHtmlDetails leagueToLeagueTypeString
    , Table.dataToIntColumn "NB TOURNOIS CLASSEMENT" leagueTournamentsToHtmlDetails leagueTournamentsToInt
    , (leagueImgActionList rights) "ACTIONS" .id
    ]
    , customizations = tableCustomizations
  }

leagueImgActionList : UserRights -> String -> (data -> Int) -> Column data Msg
leagueImgActionList rights name toInt =
   Table.veryCustomColumn
     { name = name
     , viewData = (leagueActionsDetails rights) << toInt
     , sorter = Table.unsortable
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

leagueActionsDetails : UserRights -> Int -> HtmlDetails Msg
leagueActionsDetails rights i =
  renderActionButtons rights
    [ actionButton "EditLeague" (LeagueDisplay i) "img/arrow-right-16x16.png" Visitor
    , actionButton "DeleteLeague" (LeagueDelete i) "img/delete-16x16.png" Director
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
        , onClick LeagueValidateForm
        , style "cursor" "pointer"
        ]
        [ text "Créer la ligue"]
      , div
        [ class "champ_a_cliquer"
        , onClick LeagueCancelForm
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
