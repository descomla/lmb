module ViewTeams exposing (viewTeams)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy2)

import Color exposing (Color)
import Colors exposing (fromCssString, colorSelectionList, styleColor)

import Table exposing (..)
import TableCommon exposing (..)
import TableActionButtons exposing (..)

import Toolbar exposing (..)

import Model exposing (..)
import Msg exposing (..)

import Teams exposing (..)
import TeamsModel exposing (TeamsModel)
import TeamFormData exposing (TeamFormData)

import UserRights exposing (..)
import ViewUnderConstruction exposing (viewUnderConstruction)

{--

Teams navigation page display

--}
viewTeams: Model -> Html Msg
viewTeams model =
  if model.teamsModel.formData.displayed then
    viewTeamForm model.session.rights model.teamsModel.formData
  else
    viewTeamsList model.session.rights model.teamsModel

{--

List of teams

--}

-- Teams List page
viewTeamsList : UserRights -> TeamsModel -> Html Msg
viewTeamsList rights model =
  div [ class "fullWidth" ]
    [ div [ class "titre" ] [ text "Les équipes" ] -- Titre
    , div [class "paragraphe" ]
      [ br [][]
      , div [ class "texte" ]
        [ label [][ text "Chercher une équipe :" ]
        , Html.input [ type_ "text"
          , id "teams.recherche.ligue"
          , onInput TeamFilterNameChange
          , placeholder "nom de l'équipe"
          , value model.teamFilter
          ] []
        ]
        , br [][]
        , div [ id "teams.liste" ]
          [ lazy2 viewTeamsTable model.teams rights
          , br [][]
          , lazy2 viewToolbar rights [ toolbarButtonCreateTeam  ] -- Create team action button
          ]
      ]
    ]


-- Leagues table
viewTeamsTable : Teams -> UserRights -> Html Msg
viewTeamsTable teams rights =
    Table.view (teamsTableConfig rights) (Table.initialSort "Nom de l'équipe") teams

-- Teams table configuration
teamsTableConfig : UserRights -> Table.Config Team Msg
teamsTableConfig rights =
  Table.customConfig
  { toId = .name
  , toMsg = noSorter
  , columns =
    [ Table.veryCustomColumn
      { name = "Logo"
      , viewData = teamLogoToHtmlDetails
      , sorter = Table.unsortable
      }
    , Table.veryCustomColumn
      { name = "Nom de l'équipe"
      , viewData = teamNameToHtmlDetails
      , sorter = Table.unsortable
      }
    , Table.veryCustomColumn
      { name = "Nombre de tournois"
      , viewData = tournamentsNumberToHtmlDetails
      , sorter = Table.unsortable
      }
    , Table.veryCustomColumn
      { name = "Nombre de matchs joués"
      , viewData = gamesNumberToHtmlDetails
      , sorter = Table.unsortable
      }
    , teamsImgActionList rights "Actions" .id
    ]
    , customizations = tableCustomizations
  }

teamLogoToHtmlDetails : Team -> HtmlDetails msg
teamLogoToHtmlDetails team =
    urlToHtmlDetails 60 60 team.logo

teamNameToHtmlDetails : Team -> HtmlDetails msg
teamNameToHtmlDetails team =
    stringToColorHtmlDetails team.colors team.name

tournamentsNumberToHtmlDetails : Team -> HtmlDetails msg
tournamentsNumberToHtmlDetails team =
    stringToHtmlDetails (String.fromInt 0) -- TODO Display Team with statistics

gamesNumberToHtmlDetails : Team -> HtmlDetails msg
gamesNumberToHtmlDetails team =
    stringToHtmlDetails (String.fromInt 0) -- TODO Display Team with statistics

teamsImgActionList : UserRights -> String -> (data -> Int) -> Column data Msg
teamsImgActionList rights name toInt =
   Table.veryCustomColumn
     { name = name
     , viewData = (teamsActionsDetails rights) << toInt
     , sorter = Table.unsortable
     }

teamsActionsDetails : UserRights -> Int -> HtmlDetails Msg
teamsActionsDetails rights team_id =
  renderActionButtons rights
    [ actionButton "EditTeam" (TeamOpenForm team_id) "img/edit-16x16.png" Director
    , actionButton "DeleteTeam" (TeamDelete team_id) "img/delete-16x16.png" Director
    ]


{--

Teams form

--}

-- Team Form
viewTeamForm : UserRights -> TeamFormData -> Html Msg
viewTeamForm rights data =
  div [ class "fullWidth" ]
    [ div [ class "titre" ] [ text "Création / Edition d'une équipe" ] -- Titre --TODO reprendre pour contextualiser le titre
    , div [class "paragraphe" ]
      [ label [] [ text "Nom de l'équipe :" ]
      , Html.input [ type_ "text"
        , id "teamFormName"
        , onInput TeamFormNameChange
        , placeholder "nom de l'équipe"
        , value data.name
        ] []
      , br [][]
      , label [][ text "Couleur de base (format #RRVVBB) :" ]
      , Html.input [ type_ "text"
        , id "teamFormColor"
        , onInput (\s -> TeamFormColorChange (Colors.fromCssString s))
        , placeholder "#000000"
        , value (Colors.toCssString data.colors)
        , styleColor data.colors
        ] []
      , Colors.colorSelectionList TeamFormColorChange -- liste des couleurs prédéfinies
      , br [][]
      , label [][ text "Logo :" ]
      , div []
        [ button [ onClick TeamFormLogoUpload ][ text "Logo..." ]
--      , Html.input [ type_ "file"
--        , id "teamFormLogo"
--        , onInput TeamFormLogoChange
--        , placeholder ""
--        , value data.logo
--        ] []
        , div
          [ style "width" "60px"
          , style "height" "60px"
          , style "background-image" ("url('" ++ data.logo ++ "')")
          , style "background-position" "center"
          , style "background-repeat" "no-repeat"
          , style "background-size" "contain"
          ] []
        ]
      , br [][]
      , label [][ text "Picture :" ]
      , div []
        [ button [ onClick TeamFormPictureUpload ][ text "Photo d'équipe..." ]
--      , Html.input [ type_ "file"
--        , id "teamFormPicture"
--        , onInput TeamFormPictureChange
--        , placeholder ""
--        , value data.picture
--        ] []
        , div
          [ style "width" "160px"
          , style "height" "120px"
          , style "background-image" ("url('" ++ data.picture ++ "')")
          , style "background-position" "center"
          , style "background-repeat" "no-repeat"
          , style "background-size" "contain"
          ] []
        ]
      , br [][]
      , lazy2 viewToolbar rights [ toolbarButtonValidate TeamValidateForm, toolbarButtonCancel TeamCancelForm ]
      ]
    ]
