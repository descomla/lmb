module Msg exposing (..)

import Http exposing (..)
import Url exposing (..)
import Time exposing (..)
import Browser exposing (..)

import SessionModel exposing (Session)
import UserModel exposing (UserProfile, UserProfiles)
import LeaguesModel exposing (League, Leagues)
import TournamentsModel exposing (Tournament, Tournaments)

import Table exposing (State)
import Route exposing (Route)

type Msg
  = NoOp
  | HttpFail Error
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
  | LeaguesLoaded (Result Error Leagues)
  | LeaguesSortChange Table.State
  | LeaguesFilterChange String
  | DisplayLeague Int
  -- League Form
  | LeagueFormNameChange String
  | LeagueFormKindChange String
  | LeagueFormNbTournamentsChange String
  -- League Creation
  | OpenLeagueForm Int -- 0 for creation / id for update
  | ValidateLeagueForm
  | CancelLeagueForm
  | OnCreateLeagueResult (Result Error League)
  -- League Deletion
  | DeleteLeague Int
  | ConfirmDeleteLeague String
  | OnDeletedLeagueResult (Result Error League)
  ---------------------------------------
  --
  -- Tournaments
  --
  ---------------------------------------
  | TournamentsLoaded (Result Error Tournaments)
  | DisplayTournament Int
  -- Tournament Creation
  | OpenTournamentForm Int -- 0 for creation / id for update
  | ValidateTournamentForm
  | CancelTournamentForm
  | OnCreateTournamentResult (Result Error Tournament)
  -- Tournament Deletion
  | DeleteTournament Int
  | ConfirmDeleteTournament String
  | OnDeletedTournamentResult (Result Error Tournament)
