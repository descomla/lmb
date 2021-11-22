module DatabaseRequests exposing (validateLeagueForm, updateLeague, deleteLeague,
  retrieveLeagues, retrieveCurrentLeague,
  createSession, requestLogin,
  retrieveTournaments, updateTournament, deleteTournament,
  retrieveTeams, validateTeamForm, deleteTeam )

import Http exposing (get, post, request)
import Time exposing (..)
import Msg exposing(..)
import Addresses exposing (..)
import CmdExtra exposing (..)

import Json.Encode exposing (..)
import Json.Decode exposing (..)

import LeagueType exposing (..)
import League exposing (League, Leagues, defaultLeague)
import LeaguesModel exposing (LeaguesModel)
import LeagueFormData exposing (LeagueFormData)
import LeaguesCodec exposing (decoderLeague, decoderLeagues)

import Session exposing (Session, newSession, defaultSession)
import SessionInput exposing (SessionInput)
import SessionCodec exposing (decoderSession, encoderSession)

import UserModel exposing (..)
import UserCodec exposing (decoderUserProfiles)

import Tournaments exposing (Tournament, defaultTournament)
import TournamentsCodec exposing (decoderTournaments, decoderTournament)

import Teams exposing (Teams, Team, defaultTeam)
import TeamsCodec exposing (decoderTeams, decoderTeam, encoderTeam, encoderTeamForm)
import TeamFormData exposing (TeamFormData)

-- get the last free id from a list
retrieveFreeId : List a -> (a -> Int) -> Int
retrieveFreeId liste toInt =
  let
    maxId = retrieveMaxId liste toInt
  in
    case maxId of
      Just value ->
        (1 + value)
      Nothing ->
        1

-- get the maximum id value in the leagues list
retrieveMaxId : List a -> (a -> Int) -> Maybe Int
retrieveMaxId liste toInt =
    List.maximum (List.map toInt liste)

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
    free_id = retrieveFreeId leagues .id
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
--      , ("tournaments", Json.Encode.list Json.Encode.int league.tournaments)
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

--
-- requests all tournaments
--
retrieveTournaments : Cmd Msg
retrieveTournaments =
  Http.get
    { url = databaseTournamentsUrl
    , expect = Http.expectJson OnTournamentsLoaded decoderTournaments
    }

--
-- Update a tournament
--
updateTournament : Tournament -> Cmd Msg
updateTournament tournament =
  let
    json = Json.Encode.object
      [ ("id", Json.Encode.int tournament.id)
      , ("name", Json.Encode.string tournament.name)
      , ("maxTeams", Json.Encode.int tournament.maxTeams)
      , ("league_id", Json.Encode.int tournament.league_id)
      , ("teams", Json.Encode.list encoderTeam tournament.teams)
      ]
    jsonbody = Http.stringBody "application/json" (Json.Encode.encode 0 json)
  in
    Http.request
      { method = "POST" -- "UPDATE"
      , headers = []
      , url = databaseTournamentsUrl ++ (String.fromInt tournament.id)
      , body = jsonbody
      , expect = Http.expectJson TournamentUpdateResult decoderTournament
      , timeout = Nothing
      , tracker = Nothing
      }

--
-- Delete a League
--
deleteTournament : Tournament -> Cmd Msg
deleteTournament tournament =
  let
    decoder =
      -- since the api returns an empty object on delete success,
      -- let's have the success value be the value that was
      -- passed in originally so it can be used elsewhere
      -- to remove itself
      Json.Decode.succeed defaultTournament
  in
    Http.request
      { method = "DELETE"
      , headers = []
      , url = databaseTournamentsUrl ++ (String.fromInt tournament.id)
      , body = Http.emptyBody
      , expect = Http.expectJson TournamentDeletedResult decoder
      , timeout = Nothing
      , tracker = Nothing
      }

--
-- requests all teams
--
retrieveTeams : Cmd Msg
retrieveTeams =
  Http.get
    { url = databaseTeamsUrl
    , expect = Http.expectJson OnTeamsLoaded decoderTeams
    }

--
-- Update or create a new Team from TeamFormData
--
validateTeamForm : TeamFormData -> Teams -> Cmd Msg
validateTeamForm data teams =
  if data.id == 0 then
    createTeam data teams
  else
    patchTeam data

--
-- Create a new Team from TeamFormData
--
createTeam : TeamFormData -> Teams -> Cmd Msg
createTeam data teams =
  let
    free_id = retrieveFreeId teams .id
    json = TeamsCodec.encoderTeamForm { data | id = free_id }
    jsonbody = Http.stringBody "application/json" (Json.Encode.encode 0 json)
  in
    Http.post
      { url = databaseTeamsUrl
      , body = jsonbody
      , expect = Http.expectJson TeamValidateResult decoderTeam
      }

--
-- Patch a Team from TeamFormData
--
patchTeam : TeamFormData -> Cmd Msg
patchTeam data =
  let
    json = TeamsCodec.encoderTeamForm data
    jsonbody = Http.stringBody "application/json" (Json.Encode.encode 0 json)
  in
    Http.request
      { method = "PATCH"
      , headers = []
      , url = databaseTeamsUrl ++ (String.fromInt data.id)
      , body = jsonbody
      , expect = Http.expectJson TeamValidateResult decoderTeam
      , timeout = Nothing
      , tracker = Nothing
      }

--
-- Delete a Team
--
deleteTeam : Team -> Cmd Msg
deleteTeam team =
  let
    decoder =
      -- since the api returns an empty object on delete success,
      -- let's have the success value be the value that was
      -- passed in originally so it can be used elsewhere
      -- to remove itself
      Json.Decode.succeed defaultTeam
  in
    Http.request
      { method = "DELETE"
      , headers = []
      , url = databaseTeamsUrl ++ (String.fromInt team.id)
      , body = Http.emptyBody
      , expect = Http.expectJson TeamDeletedResult decoder
      , timeout = Nothing
      , tracker = Nothing
      }
