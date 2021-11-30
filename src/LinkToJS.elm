port module LinkToJS exposing (..)

{--
//////////////////////////////////////////////////////////////////////////////
-- communication Elm -> JS
//////////////////////////////////////////////////////////////////////////////
--}
port requestDeleteLeagueConfirmation : String -> Cmd msg
port requestDeleteTournamentConfirmation : String -> Cmd msg
port requestDeleteTeamConfirmation : String -> Cmd msg
port requestRemoveTournamentTeamConfirmation : String -> Cmd msg
port requestDeletePhaseConfirmation : String -> Cmd msg
port requestDeletePouleConfirmation : String -> Cmd msg

{--
//////////////////////////////////////////////////////////////////////////////
-- communication JS -> Elm
//////////////////////////////////////////////////////////////////////////////
--}

-- -- recuperation du modele XML en js dans elm
port confirmDeleteLeague : (String -> msg) -> Sub msg
port confirmDeleteTournament : (String -> msg) -> Sub msg
port confirmDeleteTeam : (String -> msg) -> Sub msg
port confirmRemoveTournamentTeam : (String -> msg) -> Sub msg
port confirmDeletePhase : (String -> msg) -> Sub msg
port confirmDeletePoule : (String -> msg) -> Sub msg
--
-- -- selection : recuperation de la selection js dans elm
-- port scenarioSelected : (String -> msg) -> Sub msg
-- port validateProject : (String -> msg) -> Sub msg
-- port validateScenario : (String -> msg) -> Sub msg

encode : Int -> String
encode i =
  String.fromInt i

encode2 : Int -> Int -> String
encode2 i j =
  String.join "-" ( List.map String.fromInt [ i, j ] )

encode3 : Int -> Int -> Int -> String
encode3 i j k =
  String.join "-" ( List.map String.fromInt [ i, j, k ] )

decode : String -> Int
decode s =
  Maybe.withDefault 0 (String.toInt s)

decode2 : String -> (Int, Int)
decode2 s =
  let
    ids = List.map decode (String.split "-" s)
    mb_i = List.head ids
    mb_j = List.head (List.drop 1 ids)
  in
    (Maybe.withDefault 0 mb_i, Maybe.withDefault 0 mb_j)

decode3 : String -> (Int, Int, Int)
decode3 s =
  let
    ids = List.map decode (String.split "-" s)
    mb_i = List.head ids
    mb_j = List.head (List.drop 1 ids)
    mb_k = List.head (List.drop 2 ids)
  in
    (Maybe.withDefault 0 mb_i, Maybe.withDefault 0 mb_j, Maybe.withDefault 0 mb_k)
