module User exposing (..)

-- User data model
type alias User =
  { status : UserStatus
  , login : String
  , firstName : String
  , lastName : String
}

type UserStatus
 = Undefined
 | Connected

defaultUser : User
defaultUser =
  { status = Undefined
  , login = ""
  , firstName = "unknown"
  , lastName = "unknown"
  }
