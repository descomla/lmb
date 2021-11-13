module LeaguesPages exposing (LeaguesPages(..))


type LeaguesPages
  = Default
  | LeagueInputForm
  | CreateTournament Int -- League ID
  | LeagueContent Int -- League ID
  | TournamentContent Int -- League ID
