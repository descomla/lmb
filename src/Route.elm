module Route exposing (..)

import Addresses exposing (siteMainUrl)
import Url exposing (..)
import Url.Parser exposing ((</>), (<?>), s, top)

import Debug exposing (..)

-- ROUTE
type Route
  = Home
  | Players
  | Teams
  | CurrentLeague
  | OthersLeagues
  | Configuration
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
parseURL : Url.Url -> Route
parseURL url =
  let
      l = debugRoute "parseURL location.pathname = " url.path
--      p = debugRoute "parseURL pathname = " (Url.Parser.parsePath Url.Parser.string url.path)
      r = Url.Parser.parse parser url
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
        Configuration -> "config"
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
--    UrlParser.oneOf ((List.map parseCase [Home, Players, Teams, CurrentLeague, OthersLeagues, Configuration Help]) :: (UrlParser.map Home <| UrlParser.top))
--
--parseCase : Route -> (parser a b)
--parseCase route =
--   (UrlParser.map route <| UrlParser.s (routeToPath route))
parser : Url.Parser.Parser (Route -> a) a
parser =
      Url.Parser.oneOf
        [ Url.Parser.map Home <| Url.Parser.top
        , Url.Parser.map Home <| Url.Parser.s "home"
        , Url.Parser.map Players <| Url.Parser.s "players"
        , Url.Parser.map Teams <| Url.Parser.s "teams"
        , Url.Parser.map CurrentLeague <| Url.Parser.s "current"
        , Url.Parser.map OthersLeagues <| Url.Parser.s "leagues"
        , Url.Parser.map Configuration <| Url.Parser.s "config"
        , Url.Parser.map Help <| Url.Parser.s "help"
        ]
