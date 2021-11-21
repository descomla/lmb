module Teams exposing (..)

--
-- Team
--
type alias Team =
  { id : Int
  , name : String
  , textcolor : String
  }

type alias Teams = List Team

defaultTeam : Team
defaultTeam =
  { id = 0
  , name = ""
  , textcolor = "#000000"
  }


-- get Team Data
getTeam : Int -> Teams -> Maybe Team
getTeam team_id teams =
  let
    result = List.filter (\t -> t.id == team_id) teams
  in
    if (List.length result) == 0 then
      Debug.log ("No team #" ++ (String.fromInt team_id)) Nothing
    else
      if (List.length result) > 1 then
        Debug.log ("More than one team #" ++ (String.fromInt team_id)) Nothing
      else
        List.head result
