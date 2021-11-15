module SessionInput exposing (..)

import SessionError exposing (..)

type alias SessionInput =
  { login : String
  , password : String
  , error : SessionError
  }

defaultSessionInput : SessionInput
defaultSessionInput =
  { login = ""
  , password = ""
  , error = NoError
  }

-- clear session error
clearSessionError : SessionInput -> SessionInput
clearSessionError input =
   { input | error = NoError }
