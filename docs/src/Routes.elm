module Routes exposing (Route(..), fromUrl, toUrlString, urlParser)

import Url
import Url.Parser as Url


type Route
    = Home
    | GettingStarted
    | NotFound
    | Button
    | Alert
    | Badge
    | Container
    | Dropdown
    | Icon
    | Navbar
    | Pagination
    | Table
    | Typography



-- converts a route to a URL string


toUrlString : Route -> String
toUrlString route =
    let
        pieces =
            case route of
                Home ->
                    []

                GettingStarted ->
                    [ "getting-started" ]

                Button ->
                    [ "button" ]

                Alert ->
                    [ "alert" ]

                Badge ->
                    [ "badge" ]

                Container ->
                    [ "container" ]

                Dropdown ->
                    [ "dropdown" ]

                Icon ->
                    [ "icon" ]

                Navbar ->
                    [ "navbar" ]

                Pagination ->
                    [ "pagination" ]

                Table ->
                    [ "table" ]

                Typography ->
                    [ "typography" ]

                NotFound ->
                    [ "oops" ]
    in
    "#/" ++ String.join "/" pieces



-- converts a URL to a route


fromUrl : Url.Url -> Route
fromUrl url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Url.parse urlParser
        |> Maybe.withDefault NotFound



-- parser to turn a URL into a route


urlParser : Url.Parser (Route -> a) a
urlParser =
    Url.oneOf
        [ Url.map Home Url.top
        , Url.map GettingStarted (Url.s "getting-started")
        , Url.map Button (Url.s "button")
        , Url.map Badge (Url.s "badge")
        , Url.map Container (Url.s "container")
        , Url.map Dropdown (Url.s "dropdown")
        , Url.map Icon (Url.s "icon")
        , Url.map Navbar (Url.s "navbar")
        , Url.map Pagination (Url.s "pagination")
        , Url.map Table (Url.s "table")
        , Url.map Typography (Url.s "typography")
        , Url.map Alert (Url.s "alert")
        ]
