module TeamFormData exposing (TeamFormData, defaultTeamFormData,
  fillForm, setName, setColor, setLogo, setPicture )

import Color exposing (..)
import Teams exposing (Team)

--
-- Team Form
--
type alias TeamFormData =
  { id : Int
  , displayed : Bool
  , name : String
  , colors : Color
  , logo : String
  , picture : String
  }

defaultTeamFormData : TeamFormData
defaultTeamFormData =
  { id = 0
  , displayed = False
  , name = ""
  , colors = Color.rgb255 0 0 0
  , logo = ""
  , picture = ""
  }

-- Fill the Team Form Data from a Team
fillForm : Team -> TeamFormData
fillForm team =
  { id = team.id
  , displayed = True
  , name = team.name
  , colors = team.colors
  , logo = team.logo
  , picture = ""
  }

-- Fill the name of Team Form Data
setName : String -> TeamFormData -> TeamFormData
setName s data =
  { data | name = s }

-- Fill the color of Team Form Data
setColor : Color -> TeamFormData -> TeamFormData
setColor s data =
  { data | colors = s }

-- Fill the logo of Team Form Data
setLogo : String -> TeamFormData -> TeamFormData
setLogo s data =
  { data | logo = s }

-- Fill the picture of Team Form Data
setPicture : String -> TeamFormData -> TeamFormData
setPicture s data =
  { data | picture = s }
