module LeagueType exposing (LeagueType(..), leagueTypeToDisplayString, leagueTypeToDatabaseString, leagueTypeFromDatabaseString)

type LeagueType
  = SingleEvent
  | LeagueWithRanking
  | LeagueWithoutRanking

-- Handle conversion from LeagueType to String
leagueTypeToDisplayString : LeagueType -> String
leagueTypeToDisplayString t =
  case t of
    SingleEvent ->
      "Tournoi unique"
    LeagueWithRanking ->
      "Ligue à classement"
    LeagueWithoutRanking ->
      "Ligue sans classement"

-- Handle conversion from LeagueType to String
leagueTypeToDatabaseString : LeagueType -> String
leagueTypeToDatabaseString t =
  case t of
    SingleEvent ->
      "SingleEvent"
    LeagueWithRanking ->
      "LeagueWithRanking"
    LeagueWithoutRanking ->
      "LeagueWithoutRanking"

-- Handle conversion from LeagueType to String
leagueTypeFromDatabaseString : String -> Maybe LeagueType
leagueTypeFromDatabaseString s =
  if s == "SingleEvent" then
    Just SingleEvent
  else if s == "LeagueWithRanking" then
    Just LeagueWithRanking
  else if s == "LeagueWithoutRanking" then
    Just LeagueWithoutRanking
  else
    Nothing
