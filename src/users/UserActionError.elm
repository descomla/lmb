module UserActionError exposing (UserActionError(NoError, ProfileNotFound, WrongLoginOrPassword, ExistingLogin, IncorrectLogin, IncorrectPassword, EmptyFirstName, EmptyLastName))

--
-- User actions errors
--
type UserActionError
  = NoError
  | ProfileNotFound  -- Update/Delete action - Login not found
  | WrongLoginOrPassword -- login - password mismatch
  | ExistingLogin -- creating the profile - Login already exists
  | IncorrectLogin -- creating the profile - Login not respecting rules
  | IncorrectPassword -- creating the profile - Password not respecting rules
  | EmptyFirstName -- creating the profile - firstName not respecting rules
  | EmptyLastName -- creating the profile - lastName not respecting rules
