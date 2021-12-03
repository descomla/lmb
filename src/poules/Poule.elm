module Poule exposing (..)

--
-- Poule
--
type alias Poule =
  { id : Int
  , name : String
  , status : PouleStatus
  , pointsVictory : Int
  , pointsDefeat : Int
  , pointsNull : Int
  , goalAverage : Int
  }

type PouleStatus
  = Pending -- En attente
  | Running -- En cours
  | Terminated -- Terminée

defaultPoule : Poule
defaultPoule =
  { id = 0
  , name = ""
  , status = Pending
  , pointsVictory = 10000
  , pointsDefeat = 0
  , pointsNull = 100
  , goalAverage = 0
  }

setPouleId : Int -> Poule -> Poule
setPouleId i poule =
  { poule | id = i }

setPouleName : String -> Poule -> Poule
setPouleName s poule =
  { poule | name = s }

setPouleStatus : PouleStatus -> Poule -> Poule
setPouleStatus s poule =
  { poule | status = s }

setPouleVictory : Int -> Poule -> Poule
setPouleVictory p poule =
  { poule | pointsVictory = p }

setPouleDefeat : Int -> Poule -> Poule
setPouleDefeat p poule =
  { poule | pointsDefeat = p }

setPouleNull : Int -> Poule -> Poule
setPouleNull p poule =
  { poule | pointsNull = p }

-- the list contains the poule
containsPoule : Poule -> List Poule -> Bool
containsPoule poule poules =
  List.length (List.filter (\p -> p.id == poule.id ) poules) == 1

-- create/update a poule from a poule list
createUpdatePoule : Poule -> List Poule -> List Poule
createUpdatePoule poule poules =
  if poules |> containsPoule poule then
    poules |> updatePoule poule
  else
    poules |> addPoule poule

-- update a poule from a poule list
addPoule : Poule -> List Poule -> List Poule
addPoule poule poules =
  List.append poules (List.singleton poule)

-- update a poule from a poule list
updatePoule : Poule -> List Poule -> List Poule
updatePoule poule poules =
  List.map (\p -> if p.id == poule.id then poule else p ) poules

-- remove a poule from a poule list
removePoule : Int -> List Poule -> List Poule
removePoule poule_id poules =
  List.filter (\p -> p.id /= poule_id) poules
