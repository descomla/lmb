module UserModel exposing (UserProfile, defaultUserProfile, UserProfiles)

import UserRights exposing (..)

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
