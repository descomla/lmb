module LeaguesPages exposing (LeaguesPages(..))


type LeaguesPages
  = Default
  | LeagueForm
  | CreateTournament Int -- League ID
  | DisplayLeague Int -- League ID
  | DisplayTournament Int -- League ID
