module Routes exposing (Route(..), fromUrl, toUrlString, urlParser)

import Url
import Url.Parser as Url


type Route
    = Home
    | GettingStarted
    | Alert
    | Badge
    | Button
    | Container
    | Dropdown
    | Form
    | FormCheckbox
    | FormNumber
    | FormPassword
    | FormRadio
    | FormRange
    | FormSelect
    | FormText
    | FormTextarea
    | Icon
    | Navbar
    | Pagination
    | Table
    | Typography
    | Examples
    | Sandbox
    | NotFound



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

                Alert ->
                    [ "alert" ]

                Badge ->
                    [ "badge" ]

                Button ->
                    [ "button" ]

                Container ->
                    [ "container" ]

                Dropdown ->
                    [ "dropdown" ]

                Form ->
                    [ "form" ]

                FormCheckbox ->
                    [ "form-checkbox" ]

                FormNumber ->
                    [ "form-number" ]

                FormPassword ->
                    [ "form-password" ]

                FormRadio ->
                    [ "form-radio" ]

                FormRange ->
                    [ "form-range" ]

                FormSelect ->
                    [ "form-select" ]

                FormText ->
                    [ "form-text" ]

                FormTextarea ->
                    [ "form-textarea" ]

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

                Examples ->
                    [ "examples" ]

                Sandbox ->
                    [ "sandbox" ]

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
        , Url.map Alert (Url.s "alert")
        , Url.map Badge (Url.s "badge")
        , Url.map Button (Url.s "button")
        , Url.map Container (Url.s "container")
        , Url.map Dropdown (Url.s "dropdown")
        , Url.map Form (Url.s "form")
        , Url.map FormCheckbox (Url.s "form-checkbox")
        , Url.map FormNumber (Url.s "form-number")
        , Url.map FormPassword (Url.s "form-password")
        , Url.map FormRadio (Url.s "form-radio")
        , Url.map FormRange (Url.s "form-range")
        , Url.map FormSelect (Url.s "form-select")
        , Url.map FormText (Url.s "form-text")
        , Url.map FormTextarea (Url.s "form-textarea")
        , Url.map Icon (Url.s "icon")
        , Url.map Navbar (Url.s "navbar")
        , Url.map Pagination (Url.s "pagination")
        , Url.map Table (Url.s "table")
        , Url.map Typography (Url.s "typography")
        , Url.map Examples (Url.s "examples")
        , Url.map Sandbox (Url.s "sandbox")
        ]
