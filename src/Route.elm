module Route exposing (..)

import Addresses exposing (siteMainUrl)
import Navigation exposing (Location)
import UrlParser exposing ((</>), (<?>), s, top)

import Debug exposing (..)

-- ROUTE
type Route
  = Home
  | Players
  | Teams
  | CurrentLeague
  | OthersLeagues
  | Help


--
-- Debug function for Route Module
--
debugRoute : String -> a -> a
debugRoute s a =
    --Debug.log s a
    a

--
-- parse URL and get the Route from Location
--
parseURL : Location -> Route
parseURL location =
  let
      l = debugRoute "parseURL location.pathname = " location.pathname
      p = debugRoute "parseURL pathname = " (UrlParser.parsePath UrlParser.string location)
      r = UrlParser.parsePath parser location
  in
      case r of
        Just route ->
          debugRoute "parseURL route = " route--(path2RouteEx p)
        Nothing ->
          debugRoute "parseURL route = Nothing -> " Home

--
-- Convert Route to URL
--
route2URL : Route -> String
route2URL route =
    siteMainUrl ++ (route2PathName route)

--
-- Convert Route to Path string
--
route2PathName : Route -> String
route2PathName route =
    case route of
        Home -> "home"
        Players -> "players"
        Teams -> "teams"
        CurrentLeague -> "current"
        OthersLeagues -> "leagues"
        Help -> "help"

--
-- Convert string pathName to Route
--
path2RouteEx : Maybe String -> Route
path2RouteEx p =
    case p of
        Just s ->
          path2Route s
        Nothing ->
          path2Route ""

path2Route : String -> Route
path2Route p =
      let
        r = debugRoute "path2Route p = " p
      in
        Home

--parser : UrlParser.Parser (Route -> a) a
--parser =
--    UrlParser.oneOf ((List.map parseCase [Home, Players, Teams, CurrentLeague, OthersLeagues, Help]) :: (UrlParser.map Home <| UrlParser.top))
--
--parseCase : Route -> (parser a b)
--parseCase route =
--   (UrlParser.map route <| UrlParser.s (routeToPath route))
parser : UrlParser.Parser (Route -> a) a
parser =
      UrlParser.oneOf
        [ UrlParser.map Home <| UrlParser.top
        , UrlParser.map Home <| UrlParser.s "home"
        , UrlParser.map Players <| UrlParser.s "players"
        , UrlParser.map Teams <| UrlParser.s "teams"
        , UrlParser.map CurrentLeague <| UrlParser.s "current"
        , UrlParser.map OthersLeagues <| UrlParser.s "leagues"
        , UrlParser.map Help <| UrlParser.s "help"
        ]
