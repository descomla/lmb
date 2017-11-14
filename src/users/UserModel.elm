module UserModel exposing (UserModel, defaultUserModel, UserConnectionInput, defaultUserConnectionInput, UserProfile, UserProfiles, defaultUserProfile, login, logout, createUser, updateUser, deleteUser, decoderUserProfiles)

import Json.Decode exposing (Decoder, string, map)
import Json.Decode.Pipeline exposing (decode, required)

import UserActionError exposing (..)
import UserStatus exposing (..)
import UserRights exposing (..)

type alias UserModel =
  { profile : UserProfile
    , status : UserStatus
    , userInput : UserConnectionInput
    , userError : UserActionError
    , users : UserProfiles
  }

defaultUserModel : UserModel
defaultUserModel =
  { profile = defaultUserProfile
  , status = NotConnected
  , userInput = defaultUserConnectionInput
  , userError = NoError
  , users = [] }

type alias UserProfileAndStatus =
  {  }

--
-- User Input Connection Info
--
type alias UserConnectionInput =
  { login : String
  , password : String
}

defaultUserConnectionInput : UserConnectionInput
defaultUserConnectionInput =
  { login = ""
  , password = "" }

--
-- User Profile
--
type alias UserProfile =
  { login : String
  , password : String
  , rights : UserRights
  , firstName : String
  , lastName : String
}

type alias UserProfiles = List UserProfile

defaultUserProfile : UserProfile
defaultUserProfile =
    { login = ""
    , password = ""
    , rights = Visitor
    , firstName = ""
    , lastName = ""
  }

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

--
-- Get the User from his login
--
readUserFromLogin : UserModel -> (UserActionError, Maybe UserProfile)
readUserFromLogin model =
  let
    -- get users with the same login
    sublist = List.filter (isSameLogin model.userInput.login) model.users
  in
      if (List.length sublist) == 0 then -- no match for the login
        (ProfileNotFound, Nothing)
      else
        (NoError, List.head sublist) -- login found at least one time

--
-- Get the User from his login
--
readUserFromLoginPassword : UserModel -> (UserActionError, Maybe UserProfile)
readUserFromLoginPassword model =
  let
    -- get the profile from the login
    (errorLogin, profileByLogin) = readUserFromLogin model
  in
    if errorLogin == NoError then -- login found
      -- check password match
      if isSamePassword model.userInput.password (Maybe.withDefault defaultUserProfile profileByLogin) then
        (NoError, profileByLogin) -- successfull
      else
        -- password mismatch
        (WrongPassword, Nothing)
    else
      -- login not found
      (errorLogin, Nothing)

--
-- Login user
--
login : UserModel -> UserModel
login model =
  let
    -- get user from login & password
    (err, profile) = readUserFromLoginPassword model
  in
    if err == NoError then -- successfull
      { profile = Maybe.withDefault defaultUserProfile profile
      , status = Connected
      , userInput = defaultUserConnectionInput
      , userError = NoError
      , users = model.users }
    else -- login or password mismatch
      { profile = defaultUserProfile
      , status = NotConnected
      , userInput = defaultUserConnectionInput
      , userError = err
      , users = model.users }

--
-- Logout user
--
logout : UserModel -> UserModel
logout model =
      { profile = defaultUserProfile
      , status = NotConnected
      , userInput = defaultUserConnectionInput
      , userError = NoError
      , users = model.users }

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
    let
      err =
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
    in
      err

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

--
-- Json Decoder for UserProfile
--
decoderUserProfile : Decoder UserProfile
decoderUserProfile =
  Json.Decode.Pipeline.decode UserProfile
    |> Json.Decode.Pipeline.required "login" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "password" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "rights" decodeUserRights
    |> Json.Decode.Pipeline.required "firstName" (Json.Decode.string)
    |> Json.Decode.Pipeline.required "lastName" (Json.Decode.string)

--
-- Json Decoder for UserRights
--
decodeUserRights : Decoder UserRights
decodeUserRights =
  Json.Decode.string
    |> Json.Decode.andThen (\str ->
      case str of
        "Administrator" ->
          Json.Decode.succeed Administrator
        "Visitor" ->
          Json.Decode.succeed Visitor
        somethingElse ->
          Json.Decode.fail <| "Unknown UserRight " ++ somethingElse
    )

decoderUserProfiles : Decoder UserProfiles
decoderUserProfiles =
    Json.Decode.list decoderUserProfile
