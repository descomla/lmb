module ViewUserInfo exposing (viewUserInfo)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import UserModel exposing (UserModel)
import UserStatus exposing (..)
import UserActionError exposing (..)
import Msg exposing (..)

errorToString : UserActionError -> String
errorToString err =
  case err of
    NoError ->
      ""
    ProfileNotFound ->
      "Utilisateur inconnu."
    WrongPassword ->
      "Mot de passe erroné."
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


-- User info display
viewUserInfo : UserModel -> Html Msg
viewUserInfo userModel =
  let
    status = userModel.status
  in
    case status of
      NotConnected ->
        viewLoginForm userModel
      Connected ->
        viewConnectedUser userModel

viewLoginForm : UserModel -> Html Msg
viewLoginForm userModel =
  Html.div [ class "menuLogin" ]
  [ Html.table []
    [ Html.tr []
      [ Html.td [][ Html.label [][ text "Utilisateur:" ] ]
      , Html.td [][ Html.input [ type_ "text", id "login", onInput LoginChange, placeholder "login", value userModel.userInput.login ][] ]
      , Html.td [][ Html.label [][ text "Mot de passe:" ] ]
      , Html.td [][ Html.input [ type_ "password", id "password", onInput PasswordChange, placeholder "password", value userModel.userInput.password ][] ]
      , Html.td [][ Html.label [ id "loginButton", onClick Login ][ text "Se connecter"] ]
      , Html.td [ class "messageErreur" ][ text (errorToString userModel.userError) ]
      ]
    ]
  ]

viewConnectedUser : UserModel -> Html Msg
viewConnectedUser userModel =
  Html.div [ class "menuLogin" ]
    [ text "Connecté en tant que "
    , label [ class "messageInfo" ][ text (userModel.profile.firstName ++ " " ++ userModel.profile.lastName ++ " (" ++ userModel.profile.login ++ ") ") ]
    , label [ id "loginButton", onClick Logout ][ text "Se déconnecter"]
  ]
