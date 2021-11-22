module TeamsModel exposing (TeamsModel, defaultTeamsModel, clearTeamFilter,
  setTeams,
  displayTeamFormData, clearTeamFormData, initTeamFormData,
  setTeamFormName, setTeamFormColor, setTeamFormLogo, setTeamFormPicture)

import Table exposing (State)

import Color exposing (..)

import Teams exposing (Team, Teams)
import TeamFormData exposing (TeamFormData, defaultTeamFormData, fillForm, setName, setColor, setLogo, setPicture)

--
-- Leagues Model
--
type alias TeamsModel =
  { teamFilter : String -- search team by name
  , teams : Teams
  , formData : TeamFormData
  }

defaultTeamsModel : TeamsModel
defaultTeamsModel =
  { teamFilter = ""
  , teams = []
  , formData = defaultTeamFormData
  }

{--
--
-- TEAM FILTER
--
--}

-- Clear Team filter
clearTeamFilter : TeamsModel -> TeamsModel
clearTeamFilter model =
  { model | teamFilter = "" }

{--
--
-- TEAMS
--
--}

-- set the Teams list
setTeams : Teams -> TeamsModel -> TeamsModel
setTeams teams model =
  { model | teams = teams }

{--
--
-- TEAM FORM
--
--}

-- clear the FormData
displayTeamFormData : TeamsModel -> TeamsModel
displayTeamFormData model =
  let
    data = { defaultTeamFormData | displayed = True }
  in
  { model | formData = data }

-- clear the FormData
clearTeamFormData : TeamsModel -> TeamsModel
clearTeamFormData model =
  { model | formData = defaultTeamFormData }

-- init the FormData for creation
initTeamFormData : Team -> TeamsModel -> TeamsModel
initTeamFormData data model =
  { model | formData = fillForm data }

-- Fill the name of Team Form Data
setTeamFormName : String -> TeamsModel -> TeamsModel
setTeamFormName s model =
  { model | formData = setName s model.formData }

-- Fill the color of Team Form Data
setTeamFormColor : Color -> TeamsModel -> TeamsModel
setTeamFormColor s model =
  { model | formData = setColor s model.formData }

-- Fill the logo of Team Form Data
setTeamFormLogo : String -> TeamsModel -> TeamsModel
setTeamFormLogo s model =
  { model | formData = setLogo s model.formData }

-- Fill the picture of Team Form Data
setTeamFormPicture : String -> TeamsModel -> TeamsModel
setTeamFormPicture s model =
  { model | formData = setPicture s model.formData }
