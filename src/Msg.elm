module Msg exposing (..)

import Http exposing (..)
import Url exposing (..)
import Time exposing (..)
import Browser exposing (..)
import File exposing (..)
import Date exposing (..)
import Table exposing (State)

import Route exposing (Route)

import Color exposing (..)

import Session exposing (Session)

import UserModel exposing (UserProfile, UserProfiles)

import League exposing (League, Leagues)

import Tournaments exposing (Tournament, Tournaments)

import Phase exposing (PhaseType, PouleData)
import PhaseFormEvent exposing (..)

import Poule exposing (..)
import PouleFormEvent exposing (..)

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
  -- League Deletion
  | LeagueDelete Int
  | LeagueConfirmDelete String
  -- League request result
  | LeagueResult (Result Error League)
  ---------------------------------------
  --
  -- Tournaments
  --
  ---------------------------------------
  | OnTournamentsLoaded (Result Error Tournaments)
  -- Display a tournament
  | TournamentDisplay Int
  -- Tournament add team
  | TournamentAddTeam Int Int -- tournament id / team id
  | TournamentRemoveTeam Int Int -- tournament id / team id
  | TournamentConfirmRemoveTeam String -- tournament id / team id
  -- Tournament Creation
  | TournamentOpenForm Int -- 0 for creation / id for update
  | TournamentValidateForm
  | TournamentCancelForm
  -- Tournament Deletion
  | TournamentDelete Int
  | TournamentConfirmDelete String
  -- Tournament request result
  | TournamentResult (Result Error Tournament)
  ---------------------------------------
  --
  -- Phases
  --
  ---------------------------------------
  -- Tournament Phase Form
  | TournamentPhaseFormEvent PhaseFormEvent
  | TournamentPhaseValidateForm
  | TournamentPhaseCancelForm
  -- Tournament Phase Deletion
  | TournamentPhaseDelete Int Int -- tournament id / phase id
  | TournamentPhaseConfirmDelete String -- tournament id / phase id
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
  -- Team request result
  | TeamResult (Result Error Team)
  ----------------------------------------
  --
  -- Poules
  --
  ----------------------------------------
  | PouleDisplay Int Int Int --tournament_id phase_id poule_id
  -- Poule Creation
  | PouleFormInput PouleFormEvent
  | PouleValidateForm
  | PouleCancelForm
  -- Poule Deletion
  | PouleDelete Int Int Int --tournament_id phase_id poule_id
  | PouleConfirmDelete String
  ----------------------------------------
  --
  -- Matchs
  --
  ----------------------------------------
  | MatchPrint Int -- match id
  | MatchPrintAll Int Int -- tournament id / phase id
