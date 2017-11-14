module UserController exposing (update)

import Msg exposing (..)
import UserModel exposing (..)

import UserStatus exposing (..)
import UserActionError exposing (..)
import UserDecoder exposing (..)

import Http exposing (..)

mainUrl : String
mainUrl =
  "http://localhost:3000/users/"

update : Msg -> UserModel -> (UserModel, Cmd Msg)
update msg model =
  case msg of
    -- Login input changed by user
    LoginChange s ->
      let
        input = { login = s, password = model.userInput.password }
      in
        ( { model | userInput = input }, Cmd.none)
    -- Password input changed by user
    PasswordChange s ->
      let
        input = { login = model.userInput.login, password = s }
      in
        ( { model | userInput = input }, Cmd.none)
    -- Login Action
    Login ->
      let
        url = mainUrl ++ "?login=" ++ model.userInput.login ++ "&password=" ++ model.userInput.password
        m = { model | userError = (HttpError url) }
      in
        ( m, Http.send OnLoginResult (Http.get url decoderUserProfiles) )
    -- Login request result
    OnLoginResult result ->
      let
        newModel = case result of
          Ok users ->
              { profile = Maybe.withDefault defaultUserProfile (List.head users)
                , status = Connected
                , userInput = defaultUserConnectionInput
                , userError = NoError
                , users = model.users }
          Err error ->
              { profile = defaultUserProfile
                , status = NotConnected
                , userInput = defaultUserConnectionInput
                , userError = HttpError (toString error)-- model.userError --WrongLoginOrPassword
                , users = model.users }
      in
        ( newModel, Cmd.none)
    -- Logout Action
    Logout ->
      ( { profile = defaultUserProfile
        , status = NotConnected
        , userInput = defaultUserConnectionInput
        , userError = NoError
        , users = model.users }, Cmd.none )
    -- Users request result
    OnProfilesLoaded result ->
      case result of
        Ok profiles ->
          ( { model | users = profiles }, Cmd.none)
        Err err ->
          ( { model | userError = (HttpError (toString err)) }, Cmd.none)
    other ->
      ( model, Cmd.none)
--
-- Check existing login
--
loginExists : String -> UserModel -> Bool
loginExists login model =
  let
    sublist = List.filter (isSameLogin login) model.users
  in
    if (List.length sublist) == 0 then
      False
    else
      True

-- --
-- -- Get the User from his login
-- --
-- readUserFromLogin : UserModel -> (UserActionError, Maybe UserProfile)
-- readUserFromLogin model =
--   let
--     -- get users with the same login
--     sublist = List.filter (isSameLogin model.userInput.login) model.users
--   in
--       if (List.length sublist) == 0 then -- no match for the login
--         (WrongLoginOrPassword, Nothing)
--       else
--         (NoError, List.head sublist) -- login found at least one time
--
-- --
-- -- Get the User from his login
-- --
-- readUserFromLoginPassword : UserModel -> (UserActionError, Maybe UserProfile)
-- readUserFromLoginPassword model =
--   let
--     -- get the profile from the login
--     (errorLogin, profileByLogin) = readUserFromLogin model
--   in
--     if errorLogin == NoError then -- login found
--       -- check password match
--       if isSamePassword model.userInput.password (Maybe.withDefault defaultUserProfile profileByLogin) then
--         (NoError, profileByLogin) -- successfull
--       else
--         -- password mismatch
--         (WrongLoginOrPassword, Nothing)
--     else
--       -- login not found
--       (errorLogin, Nothing)

--
-- Add a new User to the list
--
createUser : UserProfile -> UserModel -> UserModel
createUser profile model =
    let
      -- compute final error
      err =
        -- get User profile from login
        if loginExists profile.login model then
          ExistingLogin -- do not create a user if login already exists
        else
          -- check profile with rules
          validateProfile profile

      newList =
        if err == NoError then -- if does not exists and validates rules
          List.append model.users (List.singleton profile)
        else -- an error occured => model unchanges
          model.users
    in
        { profile = model.profile
        , status = model.status
        , userInput = model.userInput
        , userError = err -- update error code
        , users = newList } -- and user list

--
-- Update an existing User of the list
--
updateUser : UserProfile -> UserModel -> UserModel
updateUser profile model =
    if loginExists profile.login model then -- if login exists
      -- delete profile and then create the new profile
      createUser profile (deleteUser profile model)
    else -- profile does not exist
      { model | userError = ProfileNotFound }

--
-- Update an existing User of the list
--
deleteUser : UserProfile -> UserModel -> UserModel
deleteUser profile model =
    if loginExists profile.login model then
      let
        sublist = List.filter (isDifferentLogin model.profile.login) model.users
        newModel = { model | users = sublist }
      in
        { newModel | userError = NoError }
    else -- profile does not exist
      { model | userError = ProfileNotFound }

--
-- Check rules for user creation
--
validateProfile : UserProfile -> UserActionError
validateProfile profile =
    if String.isEmpty profile.login then
      IncorrectLogin
    else if validatePassword profile.password then
      IncorrectPassword
    else if String.isEmpty profile.firstName then
      EmptyFirstName
    else if String.isEmpty profile.firstName then
      EmptyLastName
    else
      NoError

--
-- Check rules for password creation
--
validatePassword : String -> Bool
validatePassword pswd =
  String.isEmpty pswd

--
-- compare logins
--
isSameLogin : String -> UserProfile -> Bool
isSameLogin login profile =
  if (String.toLower login) == (String.toLower profile.login) then
    True
  else
    False

isDifferentLogin : String -> UserProfile -> Bool
isDifferentLogin login profile =
  if isSameLogin login profile then
    False
  else
    True

--
-- Check Login & Password
--
isSamePassword : String -> UserProfile -> Bool
isSamePassword pswd profile =
  if pswd == profile.password then
    True
  else
    False
