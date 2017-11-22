module ViewLeague exposing (viewCurrentLeague, viewOthersLeagues)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onMouseOver)
import Html.Lazy exposing (lazy)

import Table exposing (..)

import Msg exposing (..)
import Model exposing (..)

import LeaguesModel exposing (..)
import LeagueType exposing (..)

-- get the current league data
getCurrentLeague : LeaguesModel -> League
getCurrentLeague model =
  let
    temp = List.filter (\ league -> (league.id == model.currentLeague.id)) model.leagues
  in
    if List.isEmpty temp then
      { defaultLeague | name = "Aucune ligue !" }
    else if (List.length temp) > 1 then
      { defaultLeague | name = "Trop de ligues !" }
    else
      Maybe.withDefault defaultLeague (List.head temp)

{--

CurrentLeague navigation page display

--}
viewCurrentLeague : LeaguesModel -> Html Msg
viewCurrentLeague model =
  let
    currentLeague = getCurrentLeague model
  in
    div [ class "fullWidth" ]
      [ div [ class "titre" ] [ text currentLeague.name ]
      , div [ style [("text-align","center")]] [ img [ src "img/Under-construction.png" ][] ]
      , div [ class "contentBody", style [("text-align","center"), ("font-size", "1.25em")] ] [ text "Site en construction." ]
      ]

{--

CurrentLeague navigation page display

--}
viewOthersLeagues : Model -> Html Msg
viewOthersLeagues model =
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
        , div [ id "ligues.liste", class "texte" ] [ lazy viewLeagueTable model.leaguesModel ]
        , br [][]
        , div [ id "ligues.creation.ligue"
          , class "champ_a_cliquer"
          --, onMouseOver "this.style.cursor='pointer'"
          --, CreateLeague
          --, style [("cursor", "pointer")]
          ]
          [ text "Création d'une nouvelle ligue"]
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
    Table.view tableConfig model.sortState acceptableLeagues

-- Leagues table configuration
tableConfig : Table.Config League Msg
tableConfig =
  Table.customConfig
  { toId = .name
  , toMsg = LeaguesSortChange
  , columns =
    [ Table.dataToStringColumn "NOM DE LA LIGUE" leagueNameToHtmlDetails .name
    , Table.dataToStringColumn "TYPE DE LIGUE" leagueTypeToHtmlDetails leagueTypeToString
    , Table.dataToIntColumn "NB TOURNOIS CLASSEMENT" leagueTournamentsToHtmlDetails leagueTournamentsToInt
    , imgActionList "ACTIONS" .id
    ]
    , customizations = tableCustomizations
  }

-- Handle conversion from LeagueType to String
leagueTypeToString : League -> String
leagueTypeToString league =
  case league.kind of
    SingleEvent ->
      "Tournoi unique"
    LeagueWithRanking ->
      "Ligue à classement"
    LeagueWithoutRanking ->
      "Ligue sans classement"

-- Handle conversion from LeagueType to HtmlDetails msg
leagueNameToHtmlDetails : League -> HtmlDetails msg
leagueNameToHtmlDetails league =
    stringToHtmlDetails league.name

-- Handle conversion from LeagueType to HtmlDetails msg
leagueTypeToHtmlDetails : League -> HtmlDetails msg
leagueTypeToHtmlDetails league =
    stringToHtmlDetails (leagueTypeToString league)

-- Handle conversion from List to number of its elements as a string
leagueTournamentsToHtmlDetails : League -> HtmlDetails Msg
leagueTournamentsToHtmlDetails league =
    stringToHtmlDetails (toString (leagueTournamentsToInt league))

-- Handle conversion from List to number of its elements as a string
leagueTournamentsToInt : League -> Int
leagueTournamentsToInt league =
    List.length league.tournaments

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

imgActionList : String -> (data -> Int) -> Column data Msg
imgActionList name toInt =
   Table.veryCustomColumn
     { name = name
     , viewData = actionsDetails << toInt
     , sorter = Table.unsortable
     }

actionsDetails : Int -> HtmlDetails Msg
actionsDetails i =
    HtmlDetails [ class "image_a_cliquer"]
    [ actionButton "EditTournament" (Msg.EditTournament i) "img/validate.png"
    , actionButton "DeleteTournament" (Msg.DeleteTournament i) "img/delete.png"
    ]

actionButton : String -> msg -> String -> Html msg
actionButton ident msg imgSrc =
    Html.button
        [ id ident, onClick msg ]
        [ img [src imgSrc, width 15][] ]
