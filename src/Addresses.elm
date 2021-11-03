module Addresses exposing (..)

mainUrl : String
mainUrl =
  "http://localhost:3000/"

usersUrl : String
usersUrl =
  mainUrl ++ "users/"

leaguesUrl : String
leaguesUrl =
  mainUrl ++ "leagues/"

currentLeagueUrl : String
currentLeagueUrl =
  mainUrl ++ "currentLeague/"

tournamentsUrl : String
tournamentsUrl =
  mainUrl ++ "tournaments/"
