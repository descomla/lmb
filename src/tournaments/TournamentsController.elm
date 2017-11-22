module TournamentsController exposing (update, requestTournamentFromLeagueById)

import Http exposing (send, get)

import Msg exposing (..)

import TournamentsModel exposing (..)
import TournamentsDecoder exposing (decoderTournament)

mainUrl : String
mainUrl =
  "http://localhost:3000/tournaments/"

update : Msg -> Tournament -> (Tournament, Cmd Msg)
update msg model =
  case msg of
    EditTournament id ->
      (model, Cmd.none)
    DeleteTournament id ->
      (model, Cmd.none)
    -- Others messages not processed
    other ->
      ( model, Cmd.none)

-- request a tournament for a league
requestTournamentFromLeagueById : Int -> Int -> Cmd Msg
requestTournamentFromLeagueById league_id tournament_id =
  let
    url =
      mainUrl ++ "?id=" ++ (toString tournament_id)
  in
    Http.send (LeaguesTournamentItemLoaded league_id) (Http.get url decoderTournament)
