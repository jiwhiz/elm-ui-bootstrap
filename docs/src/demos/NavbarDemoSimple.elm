module NavbarTestSimple exposing (main)

{-| Somehow Elm Analyze "encounters an error parsing the file" but it works and compiles so...-}

import Browser
import Browser.Events
import Element exposing (Device)
import FontAwesome.Solid
import FontAwesome.Styles
import Html exposing (Html)
import UiFramework
import UiFramework.Configuration exposing (ThemeConfig, defaultThemeConfig)
import UiFramework.Dropdown as Dropdown
import UiFramework.Navbar as Navbar exposing (NavbarState)
import UiFramework.ResponsiveUtils exposing (classifyDevice)
import UiFramework.Types exposing (Role(..))


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- keeps track of the state of the navbar in the model


type alias Model =
    { navState : NavbarState DropdownState
    , device : Device
    , theme : ThemeConfig
    , navTheme : Role
    }


type alias Flags =
    WindowSize


type alias WindowSize =
    { width : Int
    , height : Int
    }


{-| toggleMenuState dictates whether the navbar is "collapsed" or not
dropdownState dictates the dropdowns, but for now we don't have any
-}
init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { navState =
            { toggleMenuState = False
            , dropdownState = AllClosed
            }
      , device = classifyDevice flags
      , theme = defaultThemeConfig
      , navTheme = Light
      }
    , Cmd.none
    )



-- since there are no dropdowns we can just define our type like this


type DropdownState
    = AllClosed
    | ThemeSelectOpen



-- toggle is when the navbar collapses the menu


type Msg
    = WindowSizeChange WindowSize
    | ToggleNavbar -- toggle when the navbar collapses the menu
    | ToggleDropdown -- Toggle navbar dropdown(s)
    | ChangeNavTheme Role
    | NoOp



-- handle Navbar messages


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        WindowSizeChange windowSize ->
            ( { model | device = classifyDevice windowSize }
            , Cmd.none
            )

        ToggleNavbar ->
            let
                navState =
                    model.navState

                newNavState =
                    { navState | toggleMenuState = not navState.toggleMenuState }
            in
            ( { model | navState = newNavState }
            , Cmd.none
            )

        ToggleDropdown ->
            let
                navState =
                    model.navState

                newDropdown =
                    if navState.dropdownState == ThemeSelectOpen then
                        AllClosed

                    else
                        ThemeSelectOpen

                newNavState =
                    { navState | dropdownState = newDropdown }
            in
            ( { model | navState = newNavState }
            , Cmd.none
            )

        ChangeNavTheme role ->
            update
                ToggleDropdown
                { model | navTheme = role }

        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    let
        context =
            { device = model.device
            , parentRole = Nothing
            , themeConfig = model.theme
            }
    in
    Navbar.default ToggleNavbar
        |> Navbar.withBrand (Element.text "Navbar")
        |> Navbar.withBackground model.navTheme
        |> Navbar.withMenuItems
            [ Navbar.linkItem NoOp
                -- Navbar.linkItem accepts a msg type that dictates its action when clicked
                |> Navbar.withMenuIcon FontAwesome.Solid.home
                |> Navbar.withMenuTitle "Home"
            , Navbar.linkItem NoOp
                |> Navbar.withMenuIcon FontAwesome.Solid.book
                |> Navbar.withMenuTitle "Blog"
            , Dropdown.default ToggleDropdown ThemeSelectOpen
                |> Dropdown.withIcon FontAwesome.Solid.paintBrush
                |> Dropdown.withTitle "Theme"
                |> Dropdown.withMenuItems
                    [ Dropdown.menuLinkItem (ChangeNavTheme Light)
                        |> Dropdown.withMenuTitle "Light"
                    , Dropdown.menuLinkItem (ChangeNavTheme Primary)
                        |> Dropdown.withMenuTitle "Primary"
                    , Dropdown.menuLinkItem (ChangeNavTheme Dark)
                        |> Dropdown.withMenuTitle "Dark"
                    ]
                |> Navbar.DropdownItem
            ]
        |> Navbar.view model.navState
        |> UiFramework.toElement context
        |> Element.layout []
        |> (\elem ->
                Html.div []
                    [ FontAwesome.Styles.css
                    , elem
                    ]
           )



-- subscribe to window changes


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize
        (\x y ->
            WindowSizeChange (WindowSize x y)
        )
