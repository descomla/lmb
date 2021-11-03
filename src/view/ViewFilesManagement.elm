module ViewFilesManagement exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Msg exposing (..)


import LocalModel exposing (..)

-- Files Management Display
viewFilesMngt : Model -> Html Msg
viewFilesMngt model =
  Html.div [ class "menuLogin" ]  []

{-
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

errorToString : UserActionError -> String
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
-}
