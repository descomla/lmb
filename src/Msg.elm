module Msg exposing (..)

import Http exposing (..)
import Url exposing (..)
import Time exposing (..)
import Browser exposing (..)
import File exposing (..)

import Color exposing (..)

import Session exposing (Session)
import UserModel exposing (UserProfile, UserProfiles)

import League exposing (League, Leagues)
import Tournaments exposing (Tournament, Tournaments)

import Table exposing (State)
import Route exposing (Route)
import Teams exposing (Team, Teams)

type RequestErrorType
  = InvalidLeagueType
  | HttpFail Error


type Msg
  = NoOp
  | DatabaseRequestResult RequestErrorType
  -- Init
  | AdjustZone Time.Zone
  | TickTime Time.Posix
  | UrlChanged Url
  | RouteChanged Route
  | LinkClicked Browser.UrlRequest
  | SessionResult (Result Error Session)
  | CurrentLeagueLoaded (Result Error League)
  -- Users
  | Login
  | Logout
  | LoginChange String
  | PasswordChange String
  | OnLoginResult (Result Error UserProfiles)
  | OnProfilesLoaded (Result Error UserProfiles)
  -------------------------------------
  --
  -- Leagues
  --
  -------------------------------------
  | OnLeaguesLoaded (Result Error Leagues)
  -- Leagues table events
  | LeagueSortChange Table.State
  | LeagueFilterChange String
  -- Display a league
  | LeagueDisplay Int
  -- League Form
  | LeagueFormNameChange String
  | LeagueFormKindChange String
  | LeagueFormNbTournamentsChange String
  -- League Creation
  | LeagueOpenForm Int -- 0 for creation / id for update
  | LeagueValidateForm
  | LeagueCancelForm
  | LeagueValidateFormResult (Result Error League)
  -- League Deletion
  | LeagueDelete Int
  | LeagueConfirmDelete String
  | LeagueDeleteResult (Result Error League)
  ---------------------------------------
  --
  -- Tournaments
  --
  ---------------------------------------
  | OnTournamentsLoaded (Result Error Tournaments)
  | TournamentUpdateResult (Result Error Tournament)
  -- Display a tournament
  | TournamentDisplay Int
  -- Tournament add team
  | TournamentAddTeam Int Int -- tournament id / team id
  -- Tournament Creation
  | TournamentOpenForm Int -- 0 for creation / id for update
  | TournamentValidateForm
  | TournamentCancelForm
  | TournamentValidateResult (Result Error Tournament)
  -- Tournament Deletion
  | TournamentDelete Int
  | TournamentConfirmDelete String
  | TournamentDeletedResult (Result Error Tournament)
  ----------------------------------------
  --
  -- Teams
  --
  ----------------------------------------
  | OnTeamsLoaded (Result Error Teams)
  -- Teams table events
  | TeamFilterNameChange String
  -- Team Creation
  | TeamOpenForm Int -- 0 for creation / id for update
  | TeamValidateForm
  | TeamCancelForm
  | TeamValidateResult (Result Error Team)
  -- Team Form
  | TeamFormNameChange String
  | TeamFormColorChange Color
  | TeamFormLogoChange String
  | TeamFormLogoUpload
  | TeamFormLogoGotFile File
  | TeamFormPictureChange String
  | TeamFormPictureUpload
  | TeamFormPictureGotFile File
  -- Team Deletion
  | TeamDelete Int
  | TeamConfirmDelete String
  | TeamDeletedResult (Result Error Team)
