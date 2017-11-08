module ViewUserInfo exposing (..)

import Html exposing (..)

import User exposing (..)
import Actions exposing (..)

-- User info display
viewUserInfo : User -> Html Msg
viewUserInfo user =
  if user.status == Undefined then
    viewLoginForm user
  else
    viewConnectedUser user

viewLoginForm : User -> Html Msg
viewLoginForm user =
    let
      result = "Utilisateur : [] Mot de passe : [] [Se connecter]"
    in
      Html.text result

viewConnectedUser : User -> Html Msg
viewConnectedUser user =
  let
    result = "Connecté en tant que " ++ user.firstName ++ " " ++ user.lastName ++ " (" ++ user.login ++ ") [Se déconnecter]"
  in
    Html.text result
