module Route exposing (Route(..), Query(..), parseURL, route2URL)

import Addresses exposing (siteMainUrl)
import Url exposing (Url)
import Url.Parser exposing (Parser, oneOf, top, s, (<?>), map)
import Url.Parser.Query as Query exposing (int)

import Debug exposing (..)

-- ROUTE
type Route
  = Home
  | Players
  | Teams
  | CurrentLeague Query
  | OthersLeagues Query
  | Configuration
  | Help

type Query
  = NoQuery
  | QueryLeague Int -- league_id
  | QueryTournament Int -- tournament_id
  | QueryLeagueTournament Int Int -- league_id + tournament_id

{--
--
-- QueryParameters for parsing URL
--
--}
type alias QueryParameters =
  { league : Maybe Int
  , tournament : Maybe Int
  }

--
-- Debug function for Route Module
--
debugRoute : String -> a -> a
debugRoute s a =
    Debug.log s a


--
-- parse URL and get the Route from Location
--
parseURL : Url.Url -> Route
parseURL url =
  let
      l = debugRoute "parseURL url.pathname = " url.path
      q = debugRoute "parseURL url.query = " url.query
      f = debugRoute "parseURL url.fragment = " url.fragment
--      p = debugRoute "parseURL pathname = " (Url.Parser.parsePath Url.Parser.string url.path)
      resultRoute = Url.Parser.parse parserRoute url
--      resultQuery = Url.Parser.Query.query parserQuery url
  in
      case resultRoute of
        Just route ->
          debugRoute "parseURL route = " route--(path2RouteEx p)
        Nothing ->
          debugRoute "parseURL route = Nothing -> " Home

-- Parse URL to get the main Route
parserRoute : Url.Parser.Parser (Route -> a) a
parserRoute =
  oneOf
    [ map Home <| Url.Parser.top
    , map Home <| Url.Parser.s "home"
    , map Players <| Url.Parser.s "players"
    , map Teams <| Url.Parser.s "teams"
    , map Configuration <| Url.Parser.s "config"
    , map Help <| Url.Parser.s "help"
    , map queryToCurrentLeague <| Url.Parser.s "current"
        <?> Query.int "ligue"
        <?> Query.int "tournoi"
    , map queryToOthersLeagues <| Url.Parser.s "leagues"
        <?> Query.int "ligue"
        <?> Query.int "tournoi"
    ]

{--
-- Parse URL to get the Query part
parserQuery : Url.Parser.Query.Parser QueryParameters
parserQuery =
  Url.Parser.Query.map
    QueryParameters
    (Url.Parser."ligue" <=> Url.Parser.Query.int <&> Url.Parser.Query.s "tournoi" <=> Url.Parser.Query.int)
--}

-- converter for query result on Current League
queryToCurrentLeague : Maybe Int -> Maybe Int -> Route
queryToCurrentLeague league tournament =
  case tournament of
    Just tournament_id -> -- display a tournament
      CurrentLeague (QueryTournament tournament_id)
    Nothing -> -- Only the league
      CurrentLeague NoQuery

-- converter for query result on Others Leagues
queryToOthersLeagues : Maybe Int -> Maybe Int -> Route
queryToOthersLeagues league tournament =
  case league of
    Just league_id -> -- display a league or a tournament
      -- depending on the tournament id parameter
      case tournament of
        Just tournament_id -> -- display a tournament
          OthersLeagues (QueryLeagueTournament league_id tournament_id)
        Nothing -> -- Only the league id =>
          OthersLeagues (QueryLeague league_id)
    Nothing -> -- League list
      OthersLeagues NoQuery

--
-- Convert Route to URL
--
route2URL : Route -> String
route2URL route =
    siteMainUrl ++ (route2PathName route) ++ (route2Query route)

--
-- Convert Route to Path string
--
route2PathName : Route -> String
route2PathName route =
    case route of
        Home -> "home"
        Players -> "players"
        Teams -> "teams"
        CurrentLeague q -> "current"
        OthersLeagues q -> "leagues"
        Configuration -> "config"
        Help -> "help"
--
-- Convert Route to Query
--
route2Query : Route -> String
route2Query route =
      case route of
        --
        -- current league query
        --
        CurrentLeague query ->
          case query of
            -- Invalid combination for this page
            QueryLeagueTournament league_id tournament_id -> "ERROR"
            -- Displaying a tournament on the current league page
            QueryTournament tournament_id -> -- tournament id
              "?tournoi=" ++ (String.fromInt tournament_id)
            -- Invalid combination for this page
            QueryLeague league_id -> "ERROR"
            -- Default display for current league
            NoQuery -> "" -- if no id => top withour query parameters
        --
        -- others leagues query
        --
        OthersLeagues query ->
          case query of
            -- Displaying a tournament for a specific league
            QueryLeagueTournament league_id tournament_id -> -- 2 query parameters
                  "?ligue=" ++ (String.fromInt league_id) ++ "&tournoi=" ++ (String.fromInt tournament_id)
            -- Invalid combination for this page
            QueryTournament tournament_id -> "ERROR"
            -- Displaying a specific league
            QueryLeague league_id ->
                  "?ligue=" ++ (String.fromInt league_id)
            -- Default display
            NoQuery -> "" -- if no id => top without query parameters
        -- Others
        Home -> ""
        Players -> ""
        Teams -> ""
        Configuration -> ""
        Help -> ""
