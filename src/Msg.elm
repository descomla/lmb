module Msg exposing (..)

import UserModel exposing (UserProfiles, UserProfile)
import Http exposing (..)

type Msg
  = NoOp
  | NavigationHome
  | NavigationPlayers
  | NavigationTeams
  | NavigationCurrentLeague
  | NavigationOthersLeagues
  | NavigationHelp
  | HttpFail Http.Error
  | UserProfilesLoaded (Result Error UserProfiles)
  | LoginChange String
  | PasswordChange String
  | Login
  | OnLoginResult (Result Error UserProfile)
  | Logout
