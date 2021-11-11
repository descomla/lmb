module LeaguesController exposing (create, update, delete, requestLeagues, updateLeagueFormValue, checkLeagueForm, checkLeagueFormInput)

import Http exposing (get, send)
import CmdExtra exposing (createCmd)
import Json.Encode exposing (..)
import Json.Decode exposing (..)

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
            ({ model | leagues = myLeagues }, requestTournaments)
        Err error ->
          (model, CmdExtra.createCmd (HttpFail error))
    TournamentsLoaded result ->
      case result of
        Ok myTournaments ->
          let
            myLeagues = updateTournaments model.leagues myTournaments
          in
            ({ model | leagues = myLeagues }, Cmd.none)
        Err error ->
          (model, CmdExtra.createCmd (HttpFail error))
    -- Others messages not processed
    other ->
      ( model, Cmd.none)

delete : Int -> LeaguesModel -> (LeaguesModel, Cmd Msg)
delete league_id model =
    ( model, requestDeleteLeague league_id )

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
-- check rules for league form
checkLeagueForm : LeagueForm -> String
checkLeagueForm f =
    if String.isEmpty f.name then
      "Le nom de la ligue ne doit pas être vide !"
    else
      case f.kind of
        Nothing -> "Le type de ligue est invalide !"
        Just kind ->
          ""
-- League form real-time input update
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
  Http.send LeaguesLoaded (Http.get databaseLeaguesUrl decoderLeagues)

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
      , url = databaseLeaguesUrl
      , body = jsonbody
      , expect = Http.expectJson decoderLeague
      , timeout = Maybe.Nothing
      , withCredentials = False
      }
  in
    Http.send OnCreateLeagueResult request

-- request league creation
requestDeleteLeague : Int -> Cmd Msg
requestDeleteLeague league_id =
  let
    decoder =
      -- since the api returns an empty object on delete success,
      -- let's have the success value be the value that was
      -- passed in originally so it can be used elsewhere
      -- to remove itself
      Json.Decode.succeed defaultLeague

    request = Http.request
      { method = "DELETE"
      , headers = []
      , url = databaseLeaguesUrl ++ (toString league_id)
      , body = Http.emptyBody
      , expect = Http.expectJson decoder
      , timeout = Maybe.Nothing
      , withCredentials = False
      }
  in
    Http.send OnDeletedLeagueResult request

-- get the last free id for a new league
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

-- get the maximum id value in the leagues list
retrieveMaxId : Leagues -> Maybe Int
retrieveMaxId leagues =
    List.maximum (List.map .id leagues)

-- fill tournmanents into the leagues list
updateTournaments : Leagues -> Tournaments -> Leagues
updateTournaments leagues tournaments =
  List.map (selectTournaments tournaments) leagues

-- selects tournaments for the league and updates the league object
selectTournaments : Tournaments -> League -> League
selectTournaments tournaments league =
  let
    myTournaments = List.filter (compareLeagueId league) tournaments
  in
    { league | tournaments = myTournaments }

-- compare the league id with the tournament league id
compareLeagueId : League -> Tournament -> Bool
compareLeagueId league tournament =
   if league.id == tournament.league_id then
     True
   else
     False
