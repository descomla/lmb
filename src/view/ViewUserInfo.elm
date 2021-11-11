module ViewUserInfo exposing (viewUserInfo)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Msg exposing (..)

import SessionModel exposing (..)
import SessionInput exposing (..)
import SessionError exposing (..)

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
      , Html.td [][ Html.label [ id "loginButton", onClick Login ][ text "Se connecter"] ]
      , Html.td [ class "messageErreur" ][ text (errorToString input.error) ]
      ]
    ]
  ]

viewConnectedUser : Session -> Html Msg
viewConnectedUser session =
  Html.div [ class "menuLogin" ]
    [ text "Connecté en tant que "
    , label
      [ class "messageInfo" ]
      [ text (session.firstName  ++ " " ++ session.lastName ++ " (" ++ session.login ++ ") ") ]
    , label
      [ id "loginButton", onClick Logout ]
      [ text "Se déconnecter"]
  ]

errorToString : SessionError -> String
errorToString err =
  case err of
    NoError ->
      ""
    ProfileNotFound ->
      "Profile utilisateur inconnu."
    WrongLoginOrPassword ->
      "Login ou Mot de passe erroné."
    ExistingLogin ->
      "L'utilisateur existe déjà."
    IncorrectLogin ->
      "Le nom d'utilisateur ne respecte pas les règles."
    IncorrectPassword ->
      "Le mot de passe ne respecte par les règles."
    EmptyFirstName ->
      "Prénom vide."
    EmptyLastName ->
      "Nom de famille vide."
    HttpError err ->
      "Http error : " ++ err
