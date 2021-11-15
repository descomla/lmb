module ViewUserInfo exposing (viewUserInfo)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Msg exposing (..)

import Session exposing (..)
import SessionInput exposing (..)

-- User info display
viewUserInfo : Session -> SessionInput -> Html Msg
viewUserInfo session input =
  if (isSessionConnected session) then
    viewConnectedUser session
  else
    viewLoginForm input

viewLoginForm : SessionInput -> Html Msg
viewLoginForm input =
  Html.div [ class "menuLogin" ]
  [ Html.table []
    [ Html.tr []
      [ Html.td [][ Html.label [][ text "Utilisateur:" ] ]
      , Html.td [][ Html.input [ type_ "text", id "login", onInput LoginChange, placeholder "login", value input.login ][] ]
      , Html.td [][ Html.label [][ text "Mot de passe:" ] ]
      , Html.td [][ Html.input [ type_ "password", id "password", onInput PasswordChange, placeholder "password", value input.password ][] ]
      , Html.td [][ Html.div [ id "loginButton", onClick Login ][ img [ src "img/arrow-left-16x16.png" ][] ] ]-- [ text "Se connecter"] ]
      ]
    ]
  ]

viewConnectedUser : Session -> Html Msg
viewConnectedUser session =
  Html.div [ class "menuLogin" ]
  [ Html.table []
    [ Html.tr []
      [ Html.td [][ Html.label [][ text "Connecté en tant que " ] ]
      , Html.td [][ Html.label [ class "messageInfo" ]
        [ text (session.firstName  ++ " " ++ session.lastName ++ " (" ++ session.login ++ ") ") ] ]
      , Html.td [][ Html.div [ id "loginButton", onClick Logout ][ img [ src "img/Logout-16x16.png" ][] ] ]-- [ text "Se déconnecter"] ]
      ]
    ]
  ]
