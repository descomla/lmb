module SessionError exposing (SessionError(..))

--
-- Session actions errors
--
type SessionError
  = NoError
  | ProfileNotFound  -- Update/Delete action - Login not found
  | WrongLoginOrPassword -- login - password mismatch
  | HttpError String
