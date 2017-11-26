module CmdExtra exposing (createCmd)

import Msg exposing (..)
import Task exposing (succeed, perform)

createCmd : Msg -> Cmd Msg
createCmd msg =
  Task.succeed msg
  |> Task.perform identity
