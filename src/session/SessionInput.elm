module SessionInput exposing (..)

type alias SessionInput =
  { login : String
  , password : String
  }

defaultSessionInput : SessionInput
defaultSessionInput =
  { login = ""
  , password = ""
  }

clearPassword : SessionInput -> SessionInput
clearPassword data =
  { login = data.login
  , password = ""
  }
