module Addresses exposing (..)

databaseMainUrl : String
databaseMainUrl =
  "http://localhost:3000/"

databaseSessionUrl : String
databaseSessionUrl =
  databaseMainUrl ++ "session/"

databaseUsersUrl : String
databaseUsersUrl =
  databaseMainUrl ++ "users/"

databaseLeaguesUrl : String
databaseLeaguesUrl =
  databaseMainUrl ++ "leagues/"

databaseCurrentLeagueUrl : String
databaseCurrentLeagueUrl =
  databaseMainUrl ++ "currentLeague/"

databaseTournamentsUrl : String
databaseTournamentsUrl =
  databaseMainUrl ++ "tournaments/"


siteMainUrl : String
siteMainUrl =
    "http://lmb.local.com/"
