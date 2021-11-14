module LeaguesController exposing (createLeague, deleteLeague, updateLeague, validateLeagueForm, retrieveLeagues, retrieveCurrentLeague)

import Http exposing (get, request)
import CmdExtra exposing (createCmd)
import Json.Encode exposing (..)
import Json.Decode exposing (..)

import Msg exposing (..)
import Addresses exposing (..)

import LeagueType exposing (..)
import League exposing (League, Leagues, defaultLeague, retrieveFreeId)
import LeaguesModel exposing (LeaguesModel)
import LeagueFormData exposing (LeagueFormData)
import LeaguesDecoder exposing (decoderLeague, decoderLeagues)

--
-- Create a new League from LeaguFormData
--
createLeague : LeagueFormData -> LeaguesModel -> (LeaguesModel, Cmd Msg)
createLeague data model =
  let
    free_id = retrieveFreeId model.leagues
    json = Json.Encode.object
      [ ("id", Json.Encode.int free_id)
      , ("name", Json.Encode.string data.name)
      , ("kind", Json.Encode.string (leagueTypeToDatabaseString (Maybe.withDefault LeagueType.SingleEvent data.kind)))
      , ("nbRankingTournaments", Json.Encode.int data.nbRankingTournaments)
      ]
    jsonbody = Http.stringBody "application/json" (Json.Encode.encode 0 json)
    request = -- request league creation
      Http.post
        { url = databaseLeaguesUrl
        , body = jsonbody
        , expect = Http.expectJson LeagueValidateFormResult decoderLeague
        }
  in
    ( model, request )

--
-- Delete a League
--
deleteLeague : League -> LeaguesModel -> (LeaguesModel, Cmd Msg)
deleteLeague league model =
  let
    decoder =
      -- since the api returns an empty object on delete success,
      -- let's have the success value be the value that was
      -- passed in originally so it can be used elsewhere
      -- to remove itself
      Json.Decode.succeed defaultLeague
    request =
      Http.request
        { method = "DELETE"
        , headers = []
        , url = databaseLeaguesUrl ++ (String.fromInt league.id)
        , body = Http.emptyBody
        , expect = Http.expectJson LeagueDeleteResult decoder
        , timeout = Nothing
        , tracker = Nothing
        }
  in
    ( model, request )


--
-- Update a new League from LeaguFormData
--
validateLeagueForm : LeagueFormData -> LeaguesModel -> (LeaguesModel, Cmd Msg)
validateLeagueForm data model =
  let
    json = Json.Encode.object
      [ ("id", Json.Encode.int data.id)
      , ("name", Json.Encode.string data.name)
      , ("kind", Json.Encode.string (leagueTypeToDatabaseString (Maybe.withDefault LeagueType.SingleEvent data.kind)))
      , ("nbRankingTournaments", Json.Encode.int data.nbRankingTournaments)
      ]
    jsonbody = Http.stringBody "application/json" (Json.Encode.encode 0 json)
    request = -- request league update
      Http.request
        { method = "PATCH"
        , headers = []
        , url = databaseLeaguesUrl ++ (String.fromInt data.id)
        , body = jsonbody
        , expect = Http.expectJson LeagueValidateFormResult decoderLeague
        , timeout = Nothing
        , tracker = Nothing
        }
  in
    ( model, request )

--
-- Update a new League from LeaguFormData
--
updateLeague : League -> LeaguesModel -> (LeaguesModel, Cmd Msg)
updateLeague league model =
  let
    json = Json.Encode.object
      [ ("id", Json.Encode.int league.id)
      , ("name", Json.Encode.string league.name)
      , ("kind", Json.Encode.string (leagueTypeToDatabaseString league.kind))
      , ("nbRankingTournaments", Json.Encode.int league.nbRankingTournaments)
      , ("tournaments", Json.Encode.list Json.Encode.int league.tournaments)
      ]
    jsonbody = Http.stringBody "application/json" (Json.Encode.encode 0 json)
    request = -- request league update
      Http.request
        { method = "PATCH"
        , headers = []
        , url = databaseLeaguesUrl ++ (String.fromInt league.id)
        , body = jsonbody
        , expect = Http.expectJson LeagueValidateFormResult decoderLeague
        , timeout = Nothing
        , tracker = Nothing
        }
  in
    ( model, request )

-- request all leagues
retrieveLeagues : Cmd Msg
retrieveLeagues =
  Http.get
    { url = databaseLeaguesUrl
    , expect = Http.expectJson OnLeaguesLoaded decoderLeagues
    }

retrieveCurrentLeague : Cmd Msg
retrieveCurrentLeague =
  Http.get
    { url = databaseCurrentLeagueUrl
    , expect = Http.expectJson CurrentLeagueLoaded decoderLeague
    }




{--

-- fill tournmanents into the leagues list
updateTournaments : Leagues -> Tournaments -> Leagues
updateTournaments leagues tournaments =
  List.map (selectTournaments tournaments) leagues

-- selects tournaments for the league and updates the league object
selectTournaments : Tournaments -> League -> League
selectTournaments tournaments league =
  let
    myTournaments = List.filter (matchLeagueAndTournament league) tournaments
  in
    { league | tournaments = myTournaments }

-- compare the league id with the tournament league id
matchLeagueAndTournament : League -> Tournament -> Bool
matchLeagueAndTournament league tournament =
   (league.id == tournament.league_id)

   --}
