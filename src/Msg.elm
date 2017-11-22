module Msg exposing (..)

import Http exposing (..)

import UserModel exposing (UserProfile, UserProfiles)
import LeaguesModel exposing (Leagues)
import TournamentsModel exposing (Tournament, Tournaments)

import Table exposing (State)

type Msg
  = NoOp
  | NavigationHome
  | NavigationPlayers
  | NavigationTeams
  | NavigationCurrentLeague
  | NavigationOthersLeagues
  | NavigationHelp
  | HttpFail Http.Error
  -- Users
  | Login
  | Logout
  | LoginChange String
  | PasswordChange String
  | OnLoginResult (Result Error UserProfiles)
  | OnProfilesLoaded (Result Error UserProfiles)
  -- Leagues
  | LeaguesLoaded (Result Error Leagues)
  | LeaguesTournamentItemLoaded Int (Result Error Tournament)
  | LeaguesSortChange Table.State
  | LeaguesFilterChange String
  | CreateLeague
  -- Tournaments
  | EditTournament Int
  | DeleteTournament Int
