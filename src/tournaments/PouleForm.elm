module PouleForm exposing (..)

import Poule exposing (..)

--
-- PouleForm
--
type alias PouleForm =
  { displayed : Bool
  , id : Int
  , tid : Int
  , pid : Int
  , name : String
  , status : PouleStatus
  , pointsVictory : Int
  , pointsDefeat : Int
  , pointsNull : Int
  , goalAverage : Int
  }

defaultPouleForm : PouleForm
defaultPouleForm =
  { displayed = False
  , id = 0
  , tid = 0
  , pid = 0
  , name = ""
  , status = Pending
  , pointsVictory = 10000
  , pointsDefeat = 0
  , pointsNull = 100
  , goalAverage = 0
  }

initPouleForm : Int -> Int -> Poule -> PouleForm
initPouleForm tid pid poule =
  { displayed = True
  , id = poule.id
  , tid = tid
  , pid = pid
  , name = poule.name
  , status = poule.status
  , pointsVictory = poule.pointsVictory
  , pointsDefeat = poule.pointsDefeat
  , pointsNull = poule.pointsNull
  , goalAverage = poule.goalAverage
  }

convertPoule : PouleForm -> Poule
convertPoule poule =
  { id = poule.id
  , name = poule.name
  , status = poule.status
  , pointsVictory = poule.pointsVictory
  , pointsDefeat = poule.pointsDefeat
  , pointsNull = poule.pointsNull
  , goalAverage = poule.goalAverage
  }
{--

    SETTERS

--}
setPouleFormId : Int -> PouleForm -> PouleForm
setPouleFormId i pouleForm =
  { pouleForm | id = i  }

setPouleFormName : String -> PouleForm -> PouleForm
setPouleFormName s pouleForm =
  { pouleForm | name = s  }

setPouleFormVictory : Int -> PouleForm -> PouleForm
setPouleFormVictory d pouleForm =
  { pouleForm | pointsVictory = d  }

setPouleFormDefeat : Int -> PouleForm -> PouleForm
setPouleFormDefeat d pouleForm =
  { pouleForm | pointsDefeat = d  }

setPouleFormNull : Int -> PouleForm -> PouleForm
setPouleFormNull d pouleForm =
  { pouleForm | pointsNull = d  }

setPouleFormGoalAverage : Int -> PouleForm -> PouleForm
setPouleFormGoalAverage d pouleForm =
  { pouleForm | goalAverage = d  }
