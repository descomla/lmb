module SessionController exposing (..)

import Http exposing (get, send)
import Time exposing (..)
import Json.Encode exposing (encode)

import Msg exposing (..)
import Addresses exposing (..)
import SessionModel exposing (Session, newSession, defaultSession)
import SessionInput exposing (SessionInput)
import SessionDecoder exposing (decoderSession, encoderSession)
import SessionError exposing (..)

import UserModel exposing (..)

--
-- Create a new session
--
createSession : Time -> Cmd Msg
createSession time =
  let
    m = toString (Time.inMilliseconds time)
  in
    requestCreateSession (newSession m)

-- request Session creation
requestCreateSession: Session -> Cmd Msg
requestCreateSession session =
  let
    json = encoderSession session
    jsonbody = Http.stringBody "application/json" (Json.Encode.encode 0 json)

    request = Http.request
      { method = "POST"
      , headers = []
      , url = databaseSessionUrl
      , body = jsonbody
      , expect = Http.expectJson decoderSession
      , timeout = Maybe.Nothing
      , withCredentials = False
      }
  in
    Http.send SessionResult request

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
