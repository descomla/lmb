port module LinkToJS exposing ( userProfilesLoaded )

{--
//////////////////////////////////////////////////////////////////////////////
-- communication Elm -> JS
//////////////////////////////////////////////////////////////////////////////
--}
port userProfilesLoaded : String -> Cmd msg

{--
//////////////////////////////////////////////////////////////////////////////
-- communication JS -> Elm
//////////////////////////////////////////////////////////////////////////////
--}

-- -- recuperation du modele XML en js dans elm
-- port decodeFromXML : (String -> msg) -> Sub msg
--
-- -- selection : recuperation de la selection js dans elm
-- port scenarioSelected : (String -> msg) -> Sub msg
-- port validateProject : (String -> msg) -> Sub msg
-- port validateScenario : (String -> msg) -> Sub msg
