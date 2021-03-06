module TournamentsController exposing (update, delete, requestTournaments)

import Http exposing (send, get)
import Json.Decode exposing (..)

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

delete : Int -> Cmd Msg
delete tournament_id =
    requestDeleteTournament tournament_id

-- request Tournament creation
requestDeleteTournament : Int -> Cmd Msg
requestDeleteTournament tournament_id =
  let
    decoder =
      -- since the api returns an empty object on delete success,
      -- let's have the success value be the value that was
      -- passed in originally so it can be used elsewhere
      -- to remove itself
      Json.Decode.succeed defaultTournament

    request = Http.request
      { method = "DELETE"
      , headers = []
      , url = tournamentsUrl ++ (toString tournament_id)
      , body = Http.emptyBody
      , expect = Http.expectJson decoder
      , timeout = Maybe.Nothing
      , withCredentials = False
      }
  in
    Http.send OnDeletedTournamentResult request
