module ViewHome exposing (viewHome)

import Html exposing (..)
import Html.Attributes exposing (..)

import Model exposing (..)
import Msg exposing (..)

viewHome : Model -> Html Msg
viewHome model =
  div [ class "fullWidth" ]
    [ div [ class "titre" ] [ text "Accueil" ]
    , div [ class "texte", style "text-align" "center" ]
      [ text " Bienvenue sur le site du monobasket français."
      , br [][]
      , text "Le but de celui-ci est de rassembler les documents, et les résultats des championnats, matchs, tournois de monobasket en France"
      , br [][]
      , text "Le site est actuellement en construction, particulièrement sur la partie design et 'présentation'"
      , br [][]
      , text "Si vous rencontrez un bug sur le site, n'hésitez pas à m'en faire part pour correction,"
      , a [href "mailto:lmb@monocycle.info"][text "par mail"]
      ]
    ]
