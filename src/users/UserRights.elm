module UserRights exposing (UserRights(..), isUpperOrEqualRights)
--
-- User Rights
--
type UserRights
  = Administrator
  | Director
  | Visitor

isUpperOrEqualRights : UserRights -> UserRights -> Bool
isUpperOrEqualRights expected tested =
  case expected of
    Administrator ->
      case tested of
        Administrator ->
          True
        Director ->
          False
        Visitor ->
          False
    Director ->
      case tested of
        Administrator ->
          True
        Director ->
          True
        Visitor ->
          False
    Visitor ->
      case tested of
        Administrator ->
          True
        Director ->
          True
        Visitor ->
          True
