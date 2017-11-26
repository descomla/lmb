module Msg exposing (..)

import Http exposing (..)

import UserModel exposing (UserProfile, UserProfiles)
import LeaguesModel exposing (League, Leagues)
import TournamentsModel exposing (Tournament, Tournaments)

import Table exposing (State)

type Msg
  = NoOp
  -- Init
  | CurrentLeagueLoaded (Result Error League)
  -- Navigation
  | NavigationHome
  | NavigationPlayers
  | NavigationTeams
  | NavigationCurrentLeague -- CurrentLeague
  | NavigationOthersLeagues -- OthersLeagues
  | NavigationCreateLeague
  | NavigationCreateTournament Int -- with league id
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
  | LeagueFormNameChange String
  | LeagueFormKindChange String
  | LeagueFormNbTournamentsChange String
  | LeagueFormCreate
  | OnCreateLeagueResult (Result Error League)
  | OnEditLeague Int
  | OnDeleteLeague Int
  -- Tournaments
  | OnEditTournament Int
  | OnDeleteTournament Int
