module UserModel exposing (UserModel, defaultUserModel, UserConnectionInput, defaultUserConnectionInput, UserProfile, defaultUserProfile, UserProfiles)

import UserActionError exposing (..)
import UserStatus exposing (..)
import UserRights exposing (..)

type alias UserModel =
  { profile : UserProfile
    , status : UserStatus
    , userInput : UserConnectionInput
    , userError : UserActionError
  }

defaultUserModel : UserModel
defaultUserModel =
  { profile = defaultUserProfile
  , status = NotConnected
  , userInput = defaultUserConnectionInput
  , userError = NoError }

--
-- User Input Connection Info
--
type alias UserConnectionInput =
  { login : String
  , password : String
}

defaultUserConnectionInput : UserConnectionInput
defaultUserConnectionInput =
  { login = ""
  , password = "" }

--
-- User Profile
--
type alias UserProfile =
  { login : String
  , password : String
  , rights : UserRights
  , firstName : String
  , lastName : String
}

type alias UserProfiles = List UserProfile

defaultUserProfile : UserProfile
defaultUserProfile =
    { login = ""
    , password = ""
    , rights = Visitor
    , firstName = ""
    , lastName = ""
  }
