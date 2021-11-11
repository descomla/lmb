module SessionModel exposing (Session, newSession, defaultSession, isSessionConnected)

import UserRights exposing (..)

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
