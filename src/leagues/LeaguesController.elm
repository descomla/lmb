module LeaguesController exposing (create, update, requestLeagues, updateLeagueFormValue, checkLeagueForm, checkLeagueFormInput)

import Http exposing (get, send)
import CmdExtra exposing (createCmd)
import Json.Encode exposing (..)

import Msg exposing (..)
import LeaguesModel exposing (..)
import LeagueType exposing (..)
import LeaguesDecoder exposing (..)
import TournamentsModel exposing (..)
import TournamentsController exposing (..)
import Addresses exposing (..)

create : LeaguesModel -> (LeaguesModel, Cmd Msg)
create model =
    ( model, requestCreateLeague (retrieveFreeId model.leagues) model.leagueForm )

update : Msg -> LeaguesModel -> (LeaguesModel, Cmd Msg)
update msg model =
  case msg of
    -- Table sort change
    LeaguesSortChange s ->
      ( { model | sortState = s }, Cmd.none )
    -- Filter input changed
    LeaguesFilterChange s ->
      ( { model | leagueFilter = s }, Cmd.none )
    -- Decode leagues from database
    LeaguesLoaded result ->
      case result of
        Ok myLeagues ->
            ({ model | leagues = myLeagues },
              requestTournaments myLeagues)
        Err error ->
          (model, CmdExtra.createCmd (HttpFail error))
    -- Others messages not processed
    other ->
      ( model, Cmd.none)

checkLeagueFormInput : Msg -> String
checkLeagueFormInput msg =
  case msg of
    LeagueFormNameChange s ->
      if String.isEmpty s then
        "Le nom de la ligue ne doit pas être vide !"
      else
        ""
    LeagueFormKindChange s ->
      case (leagueTypeFromDatabaseString s) of
        Nothing -> "Le type de ligue (" ++ s ++ ") est invalide !"
        Just kind -> ""
    LeagueFormNbTournamentsChange s ->
      case (String.toInt s) of
        Ok n -> ""
        Err err -> "Valeur '" ++ s ++ "' invalide !"
    -- Others messages not processed
    other ->
      ""
checkLeagueForm : LeagueForm -> String
checkLeagueForm f =
    if String.isEmpty f.name then
      "Le nom de la ligue ne doit pas être vide !"
    else
      case f.kind of
        Nothing -> "Le type de ligue est invalide !"
        Just kind ->
          ""

updateLeagueFormValue : Msg -> LeagueForm -> LeagueForm
updateLeagueFormValue msg lf =
  case msg of
    LeagueFormNameChange s ->
      { lf | name = s }
    LeagueFormKindChange s ->
      { lf | kind = (leagueTypeFromDatabaseString s) }
    LeagueFormNbTournamentsChange s ->
      let
        nb =
          case (String.toInt s) of
            Ok n -> n
            Err err -> 0
      in
      { lf | nbRankingTournaments = nb }
    -- Others messages not processed
    other -> lf

-- request all leagues
requestLeagues : Cmd Msg
requestLeagues =
  Http.send LeaguesLoaded (Http.get leaguesUrl decoderLeagues)

-- request all tournaments associted with leagues
requestTournaments : Leagues -> Cmd Msg
requestTournaments leagues =
  Cmd.batch (List.map requestTournamentsFromLeague leagues)

-- request all tournaments for a league
requestTournamentsFromLeague : League -> Cmd Msg
requestTournamentsFromLeague league =
  Cmd.batch (List.map (requestTournamentFromLeagueById league.id) (extractTournamentIds league.tournaments))

extractTournamentIds : List Tournament -> List Int
extractTournamentIds tournaments =
  List.map (.id) tournaments

-- request league creation
requestCreateLeague : Int -> LeagueForm -> Cmd Msg
requestCreateLeague newId league =
  let
    json = Json.Encode.object
      [ ("id", Json.Encode.int newId)
      , ("name", Json.Encode.string league.name)
      , ("kind", Json.Encode.string (leagueTypeToDatabaseString (Maybe.withDefault LeagueType.SingleEvent league.kind)))
      , ("nbRankingTournaments", Json.Encode.int league.nbRankingTournaments)
      ]
    jsonbody = Http.stringBody "application/json" (Json.Encode.encode 0 json)

    request = Http.request
      { method = "POST"
      , headers = []
      , url = leaguesUrl
      , body = jsonbody
      , expect = Http.expectJson decoderLeague
      , timeout = Maybe.Nothing
      , withCredentials = False
      }
  in
    Http.send OnCreateLeagueResult request


retrieveFreeId : Leagues -> Int
retrieveFreeId leagues =
  let
    maxId = retrieveMaxId leagues
  in
    case maxId of
      Just value ->
        (1 + value)
      Nothing ->
        1

retrieveMaxId : Leagues -> Maybe Int
retrieveMaxId leagues =
    List.maximum (List.map .id leagues)
