module Page.Navbar exposing (Context, Model, Msg(..), init, update, view)

{-| Navbar component
-}

import Element exposing (Color, Element, fill, height, spacing, width)
import FontAwesome.Solid
import Routes
import SharedState exposing (SharedState, SharedStateUpdate)
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Container as Container
import UiFramework.Dropdown as Dropdown
import UiFramework.Navbar as Navbar
import UiFramework.Types exposing (Role(..))
import UiFramework.Typography as Typography
import Util
import View.Component as Component exposing (componentNavbar, viewHeader)



-- UIFRAMEWORK TYPE


type alias UiElement msg =
    WithContext Context msg



-- MODEL


type alias Model =
    { complexNavTheme : Role
    , complexNavMenuState : Bool
    , complexNavDropdownState : ComplexDropdownState
    }


init : ( Model, Cmd Msg )
init =
    ( { complexNavTheme = Light
      , complexNavMenuState = False
      , complexNavDropdownState = AllClosed
      }
    , Cmd.none
    )



-- Context


type alias Context =
    { purpleColor : Color
    , complexNavTheme : Role
    , complexNavState : Navbar.NavbarState ComplexDropdownState
    }


toContext : Model -> SharedState -> UiContextual Context
toContext model sharedState =
    { device = sharedState.device
    , parentRole = Nothing
    , themeConfig = SharedState.getThemeConfig sharedState.theme
    , purpleColor = sharedState.purpleColor
    , complexNavTheme = model.complexNavTheme
    , complexNavState =
        { toggleMenuState = model.complexNavMenuState
        , dropdownState = model.complexNavDropdownState
        }
    }



-- VIEW


view : SharedState -> Model -> Element Msg
view sharedState model =
    UiFramework.uiColumn
        [ width fill, height fill ]
        [ viewHeader
            { title = "Navbar"
            , description = "A concise header for branding, navigation, and other elements."
            }
        , Container.simple
            [ Element.paddingXY 0 64 ]
          <|
            UiFramework.uiRow [ width fill ]
                [ Container.simple
                    [ width <| Element.fillPortion 1
                    , height fill
                    ]
                  <|
                    componentNavbar NavigateTo Routes.Navbar
                , Container.simple [ width <| Element.fillPortion 6 ] <| content
                ]
        ]
        |> UiFramework.toElement (toContext model sharedState)


content : UiElement Msg
content =
    UiFramework.uiColumn
        [ width fill
        , spacing 64
        ]
        [ basicExample
        , complexExample
        ]


type SimpleDropdownState
    = NoDropdowns


basicExample : UiElement Msg
basicExample =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.title "Basic Example"
        , Component.wrappedText "Navbars are easy to create, but need some wiring to set up, as it requires states to handle the responsive behaviour."
        , Navbar.default NoOp
            |> Navbar.withBrand (Element.text "Navbar")
            |> Navbar.withMenuItems
                [ Navbar.linkItem NoOp
                    |> Navbar.withMenuIcon FontAwesome.Solid.home
                    |> Navbar.withMenuTitle "Home"
                , Navbar.linkItem NoOp
                    |> Navbar.withMenuIcon FontAwesome.Solid.book
                    |> Navbar.withMenuTitle "Blog"
                , Navbar.linkItem NoOp
                    |> Navbar.withMenuIcon FontAwesome.Solid.addressBook
                    |> Navbar.withMenuTitle "Contact"
                , Navbar.linkItem NoOp
                    |> Navbar.withMenuTitle "No Icon"
                ]
            |> Navbar.view { toggleMenuState = False, dropdownState = NoDropdowns }
        , basicExampleCode
        , Component.wrappedText "Because of the flags, you'll also need to configure an index.html file. Below is a simple setup you can use yourself."
        , basicHtmlCode
        ]


basicExampleCode : UiElement Msg
basicExampleCode =
    """
import Browser
import Browser.Events
import Element exposing (Device)
import Html exposing (Html)
import FontAwesome.Solid
import FontAwesome.Styles
import UiFramework
import UiFramework.Configuration exposing (ThemeConfig, defaultThemeConfig)
import UiFramework.ResponsiveUtils exposing (classifyDevice)
import UiFramework.Navbar as Navbar exposing (NavbarState)


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


init : Flags -> (Model, Cmd Msg)
init flags =
    ( { navState = 
        { toggleMenuState = False
        , dropdownState = NoDropdown
        }
      , device = classifyDevice flags
      , theme = defaultThemeConfig
      }
    , Cmd.none)


-- since there are no dropdowns we can just define our type like this


type DropdownState
    = NoDropdown

-- toggle is when the navbar collapses the menu


type Msg 
    = ToggleNavbar
    | WindowSizeChange WindowSize
    | NoOp


-- handle Navbar messages


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of 
        ToggleNavbar ->
            let
                navState = model.navState
                newNavState =
                    { navState | toggleMenuState = not navState.toggleMenuState}
            in
            ( { model | navState = newNavState }
            , Cmd.none
            )

        WindowSizeChange windowSize ->
            ( { model | device = classifyDevice windowSize}
            , Cmd.none 
            )
        
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
        |> Navbar.withMenuItems
            -- Navbar.linkItem accepts a msg type that triggers when the screen width is too small
            [ Navbar.linkItem NoOp 
                |> Navbar.withMenuIcon FontAwesome.Solid.home
                |> Navbar.withMenuTitle "Home"
            , Navbar.linkItem NoOp
                |> Navbar.withMenuIcon FontAwesome.Solid.book
                |> Navbar.withMenuTitle "Blog"
            , Navbar.linkItem NoOp
                |> Navbar.withMenuIcon FontAwesome.Solid.addressBook
                |> Navbar.withMenuTitle "Contact"
            , Navbar.linkItem NoOp
                |> Navbar.withMenuTitle "No Icon"
            ]
        |> Navbar.view model.navState
        |> UiFramework.toElement context
        |> Element.layout []
        |> (\\elem ->
            Html.div []
                [ FontAwesome.Styles.css
                , elem 
                ]
            )



-- subscribe to window changes


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize
        (\\x y ->
            WindowSizeChange (WindowSize x y)
        )"""
        |> Util.uiHighlightCode "elm"


basicHtmlCode : UiElement Msg
basicHtmlCode =
    """
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Basic Ui Bootstrap Example</title>
    <meta name="description" content="A Small Demo Application using Elm-Ui-Bootstrap">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body>
    <div id="elm"></div>
    <script src="elm.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
    <script>
        var app = Elm.Main.init({
            node: document.getElementById('elm'),
            flags: {
                height: window.innerHeight,
                width: window.innerWidth
            }
        })
    </script>
</body>

</html>"""
        |> Util.uiHighlightCode "html"


type ComplexDropdownState
    = AllClosed
    | ThemeSelectOpen


complexExample : UiElement Msg
complexExample =
    UiFramework.flatMap
        (\context ->
            UiFramework.uiColumn
                [ width fill
                , Element.spacing 32
                ]
                [ Component.title "Customization"
                , Component.wrappedText "Navbars at the moment are pretty rigid, but there is a small amount of customization you can do. You can use Roles defined in UiFramework.Types to change the background color, and add dropdowns. In this navbar, we have a dropdown where we can change the background color based on three roles."
                , Navbar.default ToggleComplexNav
                    |> Navbar.withBackground context.complexNavTheme
                    |> Navbar.withBrand (Element.text "Navbar")
                    |> Navbar.withMenuItems
                        [ Navbar.linkItem NoOp
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
                    |> Navbar.view context.complexNavState
                , Component.wrappedText "Below is the code you'll have to change in order to implement this new navbar."
                , complexNavbarCode
                ]
        )


complexNavbarCode : UiElement Msg
complexNavbarCode =
    """
import UiFramework.Dropdown as Dropdown
import UiFramework.Types exposing (Role(..))


type alias Model =
    { navState : NavbarState DropdownState
    , device : Device
    , theme : ThemeConfig
    , navTheme : Role
    }


init : Flags -> (Model, Cmd Msg)
init flags =
    ( { navState = 
        { toggleMenuState = False
        , dropdownState = AllClosed
        }
      , device = classifyDevice flags
      , theme = defaultThemeConfig
      }
    , Cmd.none)


type DropdownState
    = AllClosed
    | ThemeSelectOpen



type Msg 
    = ...
    | ToggleDropdown
    | ChangeNavTheme Role
    
    
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of 
        ...
        ToggleDropdown ->
            let
                navState = model.navState
                newDropdown = 
                    if navState.dropdownState == ThemeSelectOpen then
                        AllClosed

                    else
                        ThemeSelectOpen
                newNavState = { navState | dropdownState = newDropdown}
            in
            ( { model | navState = newNavState}
            , Cmd.none
            )
        
        ChangeNavTheme role ->
            update 
                ToggleDropdown
                { model | navTheme = role }


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
        |> (\\elem ->
            Html.div []
                [ FontAwesome.Styles.css
                , elem 
                ]
            )"""
        |> Util.uiHighlightCode "elm"



-- UPDATE


type Msg
    = NoOp
    | NavigateTo Routes.Route
    | ToggleDropdown
    | ToggleComplexNav
    | ChangeNavTheme Role


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, SharedState.NoUpdate )

        NavigateTo route ->
            ( model, Util.navigate sharedState.navKey route, SharedState.NoUpdate )

        ToggleDropdown ->
            let
                newDropdownState =
                    if model.complexNavDropdownState == ThemeSelectOpen then
                        AllClosed

                    else
                        ThemeSelectOpen
            in
            ( { model | complexNavDropdownState = newDropdownState }
            , Cmd.none
            , SharedState.NoUpdate
            )

        ToggleComplexNav ->
            ( { model | complexNavMenuState = not model.complexNavMenuState }
            , Cmd.none
            , SharedState.NoUpdate
            )

        ChangeNavTheme role ->
            ( { model | complexNavTheme = role, complexNavDropdownState = AllClosed }
            , Cmd.none
            , SharedState.NoUpdate
            )
