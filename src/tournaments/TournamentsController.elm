module TournamentsController exposing (..)

type alias TournamentsController =
  { id : Int
  }
{--
update : Msg -> Tournament -> (Tournament, Cmd Msg)
update msg model =
  case msg of
    DeleteTournament id ->
      (model, Cmd.none)
    -- Others messages not processed
    other ->
      ( model, Cmd.none)

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
  in
    Http.request
      { method = "DELETE"
      , headers = []
      , url = databaseTournamentsUrl ++ (String.fromInt tournament_id)
      , body = Http.emptyBody
      , expect = Http.expectJson OnDeletedTournamentResult decoder
      , timeout = Nothing
      , tracker = Nothing
      }
--}
