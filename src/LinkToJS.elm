port module LinkToJS exposing (..)

{--
//////////////////////////////////////////////////////////////////////////////
-- communication Elm -> JS
//////////////////////////////////////////////////////////////////////////////
--}
port requestDeleteLeagueConfirmation : String -> Cmd msg
port requestDeleteTournamentConfirmation : String -> Cmd msg

{--
//////////////////////////////////////////////////////////////////////////////
-- communication JS -> Elm
//////////////////////////////////////////////////////////////////////////////
--}

-- -- recuperation du modele XML en js dans elm
port confirmDeleteLeague : (String -> msg) -> Sub msg
port confirmDeleteTournament : (String -> msg) -> Sub msg
--
-- -- selection : recuperation de la selection js dans elm
-- port scenarioSelected : (String -> msg) -> Sub msg
-- port validateProject : (String -> msg) -> Sub msg
-- port validateScenario : (String -> msg) -> Sub msg
