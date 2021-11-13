module UserError exposing (..)
--
-- User actions errors
--
type UserError
  = NoError
  | ExistingLogin -- creating the profile - Login already exists
  | IncorrectLogin -- creating the profile - Login not respecting rules
  | IncorrectPassword -- creating the profile - Password not respecting rules
  | EmptyFirstName -- creating the profile - firstName not respecting rules
  | EmptyLastName -- creating the profile - lastName not respecting rules
  | HttpError String
