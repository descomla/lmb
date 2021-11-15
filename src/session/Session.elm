module Session exposing (Session, newSession, defaultSession, isSessionConnected,
  clearSession, updateSessionUser)

import UserRights exposing (..)
import UserModel exposing (UserProfile)

type alias Session =
  { sessionId : String
    , login : String
    , rights : UserRights
    , firstName : String
    , lastName : String
  }

newSession : String -> Session
newSession s =
  { sessionId = s
  , login = ""
  , rights = Visitor
  , firstName = ""
  , lastName = ""
  }

defaultSession : Session
defaultSession =
  { sessionId = ""
  , login = ""
  , rights = Visitor
  , firstName = ""
  , lastName = ""
  }

isSessionConnected : Session -> Bool
isSessionConnected session =
    if session.login == "" then
      False
    else
      True

-- Clear session user
clearSession : Session -> Session
clearSession session =
  { defaultSession | sessionId = session.sessionId }

-- Update session user
updateSessionUser : Session -> UserProfile -> Session
updateSessionUser session profile =
  { sessionId = session.sessionId
  , login = profile.login
  , rights = profile.rights
  , firstName = profile.firstName
  , lastName = profile.lastName
  }
