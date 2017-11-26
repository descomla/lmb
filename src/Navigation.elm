module Navigation exposing (..)

import LeaguesPages exposing (..)

type Navigation
 = Home
 | Players
 | Teams
 | CurrentLeague LeaguesPages
 | OthersLeagues LeaguesPages
 | Help
