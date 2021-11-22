module Colors exposing (colorSelectionList, fromCssString, toCssString, styleColor)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onMouseOver )

import Color exposing (..)
import Hex exposing (toString, fromString)

authorizedCharacters : List Char
authorizedCharacters =
  [ '0', '1', '2', '3', '4', '5', '6', '7', '8'
  , 'A', 'B', 'C', 'D', 'E', 'F'
  , 'a', 'b', 'c', 'd', 'e', 'f'
  ]

predefinedColors : List Color
predefinedColors =
  [ red, orange, yellow, green, blue, purple, brown
  , lightRed, lightOrange, lightYellow, lightGreen, lightBlue, lightPurple, lightBrown
  , darkRed, darkOrange, darkYellow, darkGreen, darkBlue, darkPurple, darkBrown
  , white, lightGrey, grey, darkGrey, lightCharcoal, charcoal, darkCharcoal, black
  , lightGray, gray, darkGray
  ]

{--
  Colors manipulation
--}

-- get a valid color code from the CSS string
fromCssString : String -> Color
fromCssString s =
  if String.isEmpty s then
    Color.black
  else
    let
      rvb =
        if (String.startsWith "#" s) then (String.dropLeft 1 s) else s
      rvb6 =
        if (String.length rvb) < 6 then
          String.append rvb (String.repeat (6 - (String.length rvb)) "0")
        else
          String.left 6 rvb

      listchar = String.toList rvb6
      correctedList = List.map (\c -> if List.member c authorizedCharacters then c else '0') listchar
      result = String.fromList correctedList
      rouge = case ( Hex.fromString ( String.left 2 result ) ) of
          Ok r -> r
          Err err -> 0
      vert = case ( Hex.fromString ( String.left 2 ( String.right 4 result ) ) ) of
          Ok r -> r
          Err err -> 0
      bleu = case ( Hex.fromString ( String.right 2 result ) ) of
          Ok r -> r
          Err err -> 0
    in
      Color.rgb255 rouge vert bleu


-- format a RGB color code starting with '#'
toCssString : Color -> String
toCssString colors =
  let
    components = toRgba colors
    rouge = floatToHexString components.red
    vert = floatToHexString components.green
    bleu = floatToHexString components.blue
  in
    String.cons '#' ( String.concat [ rouge, vert, bleu ] )

floatToHexString : Float -> String
floatToHexString f =
  let
    v = Hex.toString ( round (f * 255) )
  in
    case String.length v of
      0 -> "00"
      1 -> String.append "0" v
      others -> v

{--
  Colors selection DIV
--}
colorSelectionList : (Color -> msg) -> Html msg
colorSelectionList toMsg  =
  div [ class "color-toolbar" ]
    ( List.map (colorSelectionItem toMsg) predefinedColors )

colorSelectionItem : (Color -> msg) -> Color -> Html msg
colorSelectionItem toMsg color =
  div [ class "color-spacing", onClick (toMsg color) ]
    [ div [ class "color-square", style "background-color" ( toCssString color ) ] [] ]

styleColor : Color -> Html.Attribute msg
styleColor c =
  style "color" ( if (c == Color.white) then (toCssString Color.black) else (toCssString c) )
