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
  div [ class "menuLogin" ]
    [ div [][ Html.label [][ text "Utilisateur:" ] ]
    , div [][ Html.input [ type_ "text", id "login", onInput LoginChange, placeholder "login", value input.login ][] ]
    , div [][ Html.label [][ text "Mot de passe:" ] ]
    , div [][ Html.input [ type_ "password", id "password", onInput PasswordChange, placeholder "password", value input.password ][] ]
    , div [ class "actionButton", onClick Login ][ img [ src "img/arrow-right-16x16.png" ][] ]-- [ text "Se connecter"] ]
    ]

viewConnectedUser : Session -> Html Msg
viewConnectedUser session =
  div [ class "menuLogin" ]
    [ div [][ Html.label [][ text "Connecté en tant que " ] ]
    , div [][ Html.label []
      [ text (session.firstName  ++ " " ++ session.lastName ++ " (" ++ session.login ++ ") ") ] ]
    , div [][ div [ class "actionButton", onClick Logout ][ img [ src "img/Logout-16x16.png" ][] ] ]-- [ text "Se déconnecter"] ]
    ]
