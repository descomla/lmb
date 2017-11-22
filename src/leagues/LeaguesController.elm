module LeaguesController exposing (update, requestLeagues)

import Http exposing (send, get)
import Task exposing (..)

import Msg exposing (..)
import LeaguesModel exposing (..)
import LeaguesDecoder exposing (..)
import TournamentsModel exposing (..)
import TournamentsController exposing (..)

mainUrl : String
mainUrl =
  "http://localhost:3000/leagues/"

update : Msg -> LeaguesModel -> (LeaguesModel, Cmd Msg)
update msg model =
  case msg of
    -- Table sort change
    LeaguesSortChange s ->
      ( { model | sortState = s }, Cmd.none )
    -- Filter input changed
    LeaguesFilterChange s ->
      ( { model | leagueFilter = s }, Cmd.none )
    -- Decode leagues from database
    LeaguesLoaded result ->
      case result of
        Ok myLeagues ->
            ({ model | leagues = myLeagues },
              requestTournaments myLeagues)
        Err error ->
          (model, send (HttpFail error))
    -- Others messages not processed
    other ->
      ( model, Cmd.none)

-- request all leagues
requestLeagues : Cmd Msg
requestLeagues =
  Http.send LeaguesLoaded (Http.get mainUrl decoderLeagues)

-- request all tournaments associted with leagues
requestTournaments : Leagues -> Cmd Msg
requestTournaments leagues =
  Cmd.batch (List.map requestTournamentsFromLeague leagues)

-- request all tournaments for a league
requestTournamentsFromLeague : League -> Cmd Msg
requestTournamentsFromLeague league =
  Cmd.batch (List.map (requestTournamentFromLeagueById league.id) (extractTournamentIds league.tournaments))

extractTournamentIds : List Tournament -> List Int
extractTournamentIds tournaments =
  List.map (.id) tournaments

------------------------------------------------------------------------------------
send : Msg -> Cmd Msg
send msg =
  Task.succeed msg
  |> Task.perform identity
