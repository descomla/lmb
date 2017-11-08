module ViewUserInfo exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
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
  Html.div [ class "menuLogin" ]
  [ Html.label [][ text "Utilisateur:" ]
  , Html.input [ type_ "text", id "login", onInput LoginChange, placeholder "login" ][ ]
  , Html.label [][ text "Mot de passe:" ]
  , Html.input [ type_ "password", id "password", onInput PasswordChange, placeholder "password" ][ ]
  , Html.label [ id "loginButton", onClick Login ][ text "Se connecter"]
  ]

viewConnectedUser : User -> Html Msg
viewConnectedUser user =
  let
    result = "Connecté en tant que " ++ user.firstName ++ " " ++ user.lastName ++ " (" ++ user.login ++ ")"
  in
  Html.div [ class "menuLogin" ][
    text result, div [ id "loginButton", onClick Logout ][ text "Se déconnecter"]
  ]
