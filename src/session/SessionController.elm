module SessionController exposing (createSession, requestLogin, clearSessionError, clearSession, updateSessionUser)

import Http exposing (post)
import Time exposing (..)
import Json.Encode exposing (encode)

import Msg exposing (..)
import Addresses exposing (..)
import SessionModel exposing (Session, newSession, defaultSession)
import SessionInput exposing (SessionInput)
import SessionDecoder exposing (decoderSession, encoderSession)
import SessionError exposing (..)

import UserModel exposing (..)
import UserDecoder exposing (decoderUserProfiles)

--
-- Create a new session
--
createSession : Posix -> Cmd Msg
createSession time =
  let
    m = String.fromInt (Time.toMillis utc time)
  in
    requestCreateSession (newSession m)

-- request Session creation
requestCreateSession: Session -> Cmd Msg
requestCreateSession session =
  let
    json = encoderSession session
    jsonbody = Http.stringBody "application/json" (Json.Encode.encode 0 json)
  in
    Http.post
      { url = databaseSessionUrl
      , body = jsonbody
      , expect = Http.expectJson SessionResult decoderSession
      }

-- request Login
requestLogin : SessionInput -> Cmd Msg
requestLogin input =
  let
    url = databaseUsersUrl ++ "?login=" ++ input.login ++ "&password=" ++ input.password
  in
    Http.get
      { url = url
      , expect = Http.expectJson OnLoginResult decoderUserProfiles
      }

-- clear session error
clearSessionError : SessionInput -> SessionInput
clearSessionError input =
   { input | error = NoError }

-- Update session user
updateSessionUser : Session -> UserProfile -> Session
updateSessionUser session profile =
  let
      r1 = { session | firstName = profile.firstName }
      r2 = { r1 | lastName = profile.lastName }
      r3 = { r2 | login = profile.login }
  in
      { r3 | rights = profile.rights }

-- Clear session user
clearSession : Session -> Session
clearSession session =
  { defaultSession | sessionId = session.sessionId }
