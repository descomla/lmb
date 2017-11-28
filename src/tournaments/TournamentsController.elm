module TournamentsController exposing (update, requestTournaments)

import Http exposing (send, get)

import Msg exposing (..)

import TournamentsModel exposing (..)
import TournamentsDecoder exposing (decoderTournament, decoderTournaments)

import Addresses exposing (..)

update : Msg -> Tournament -> (Tournament, Cmd Msg)
update msg model =
  case msg of
    TournamentDeleteAction id ->
      (model, Cmd.none)
    -- Others messages not processed
    other ->
      ( model, Cmd.none)

-- request a tournament for a league
requestTournaments : Cmd Msg
requestTournaments =
  Http.send TournamentsLoaded (Http.get tournamentsUrl decoderTournaments)

replaceTournament : Tournament -> Tournaments -> Tournaments
replaceTournament tournament tournaments =
  List.map (substituteTournament tournament) tournaments

substituteTournament : Tournament -> Tournament -> Tournament
substituteTournament toUse toCompare =
  if toCompare.id == toUse.id then
    toUse
  else
    toCompare
