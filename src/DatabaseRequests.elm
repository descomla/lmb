module DatabaseRequests exposing (validateLeagueForm, updateLeague, deleteLeague,
  retrieveLeagues, retrieveCurrentLeague,
  createSession, requestLogin )

import Http exposing (get, post, request)
import Time exposing (..)
import Msg exposing(..)
import Addresses exposing (..)
import CmdExtra exposing (..)

import Json.Encode exposing (..)
import Json.Decode exposing (..)

import LeagueType exposing (..)
import League exposing (League, Leagues, defaultLeague, retrieveFreeId)
import LeaguesModel exposing (LeaguesModel)
import LeagueFormData exposing (LeagueFormData)
import LeaguesDecoder exposing (decoderLeague, decoderLeagues)

import Session exposing (Session, newSession, defaultSession)
import SessionInput exposing (SessionInput)
import SessionDecoder exposing (decoderSession, encoderSession)
import SessionError exposing (..)

import UserModel exposing (..)
import UserDecoder exposing (decoderUserProfiles)

--
-- Update or create a new League from LeaguFormData
--
validateLeagueForm : LeagueFormData -> Leagues -> Cmd Msg
validateLeagueForm data leagues =
  case data.kind of
    Nothing ->
      CmdExtra.createCmd (DatabaseRequestResult InvalidLeagueType)
    Just kind ->
      let
        skind = leagueTypeToDatabaseString kind
      in
        if data.id == 0 then
          createLeague leagues skind data.name data.nbRankingTournaments
        else
          patchLeague data.id skind data.name data.nbRankingTournaments

--
-- Create a new League from LeaguFormData
--
createLeague : Leagues -> String -> String -> Int -> Cmd Msg
createLeague leagues skind name nb =
  let
    free_id = retrieveFreeId leagues
    json = Json.Encode.object
      [ ("id", (Json.Encode.int free_id))
      , ("name", Json.Encode.string name)
      , ("kind", Json.Encode.string skind)
      , ("nbRankingTournaments", Json.Encode.int nb)
      ]
    jsonbody = Http.stringBody "application/json" (Json.Encode.encode 0 json)
  in
    Http.post
      { url = databaseLeaguesUrl
      , body = jsonbody
      , expect = Http.expectJson LeagueValidateFormResult decoderLeague
      }

--
-- Patch a League from LeaguFormData
--
patchLeague : Int -> String -> String -> Int -> Cmd Msg
patchLeague  id skind name nb =
  let
    json = Json.Encode.object
      [ ("id", Json.Encode.int id)
      , ("name", Json.Encode.string name)
      , ("kind", Json.Encode.string skind)
      , ("nbRankingTournaments", Json.Encode.int nb)
      ]
    jsonbody = Http.stringBody "application/json" (Json.Encode.encode 0 json)
  in
    Http.request
      { method = "PATCH"
      , headers = []
      , url = databaseLeaguesUrl ++ (String.fromInt id)
      , body = jsonbody
      , expect = Http.expectJson LeagueValidateFormResult decoderLeague
      , timeout = Nothing
      , tracker = Nothing
      }

--
-- Update a new League from LeaguFormData
--
updateLeague : League -> Cmd Msg
updateLeague league =
  let
    json = Json.Encode.object
      [ ("id", Json.Encode.int league.id)
      , ("name", Json.Encode.string league.name)
      , ("kind", Json.Encode.string (leagueTypeToDatabaseString league.kind))
      , ("nbRankingTournaments", Json.Encode.int league.nbRankingTournaments)
      , ("tournaments", Json.Encode.list Json.Encode.int league.tournaments)
      ]
    jsonbody = Http.stringBody "application/json" (Json.Encode.encode 0 json)
  in
    Http.request
      { method = "POST" -- "UPDATE"
      , headers = []
      , url = databaseLeaguesUrl ++ (String.fromInt league.id)
      , body = jsonbody
      , expect = Http.expectJson LeagueValidateFormResult decoderLeague
      , timeout = Nothing
      , tracker = Nothing
      }

--
-- Delete a League
--
deleteLeague : League -> Cmd Msg
deleteLeague league =
  let
    decoder =
      -- since the api returns an empty object on delete success,
      -- let's have the success value be the value that was
      -- passed in originally so it can be used elsewhere
      -- to remove itself
      Json.Decode.succeed defaultLeague
  in
    Http.request
      { method = "DELETE"
      , headers = []
      , url = databaseLeaguesUrl ++ (String.fromInt league.id)
      , body = Http.emptyBody
      , expect = Http.expectJson LeagueDeleteResult decoder
      , timeout = Nothing
      , tracker = Nothing
      }


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


--
-- Create a new session
--
createSession : Posix -> Cmd Msg
createSession time =
  let
    m = String.fromInt (Time.toMillis utc time)
  in
    requestCreateSession (newSession m)

-- request Session creation
requestCreateSession: Session -> Cmd Msg
requestCreateSession session =
  let
    json = encoderSession session
    jsonbody = Http.stringBody "application/json" (Json.Encode.encode 0 json)
  in
    Http.post
      { url = databaseSessionUrl
      , body = jsonbody
      , expect = Http.expectJson SessionResult decoderSession
      }

-- request Login
requestLogin : SessionInput -> Cmd Msg
requestLogin input =
  let
    url = databaseUsersUrl ++ "?login=" ++ input.login ++ "&password=" ++ input.password
  in
    Http.get
      { url = url
      , expect = Http.expectJson OnLoginResult decoderUserProfiles
      }
