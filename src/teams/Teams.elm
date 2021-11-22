module Teams exposing (..)

import Color exposing (Color)
--
-- Team
--
type alias Team =
  { id : Int
  , name : String
  , colors : Color
  , logo : String
  , picture : String
  }

type alias Teams = List Team

defaultTeam : Team
defaultTeam =
  { id = 0
  , name = ""
  , colors = Color.rgb255 0 0 0
  , logo = ""
  , picture = ""
  }


-- get Team Data
getTeam : Int -> Teams -> Maybe Team
getTeam team_id teams =
  let
    result = List.filter (\t -> t.id == team_id) teams
  in
    if List.isEmpty result then
      Debug.log ("Aucune équipe #" ++ (String.fromInt team_id)) Nothing
    else if (List.length result) > 1 then
      Debug.log ("Trop d'équipes' #" ++ (String.fromInt team_id)) Nothing
    else
      List.head result
