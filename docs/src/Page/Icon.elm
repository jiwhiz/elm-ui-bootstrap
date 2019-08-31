module Page.Icon exposing (Context, Model, Msg(..), init, update, view)

{-| Alert component
-}

import Element exposing (Color, Element, fill, height, spacing, width)
import FontAwesome.Brands
import FontAwesome.Solid
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Button as Button
import UiFramework.Container as Container
import UiFramework.Icon as Icon
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
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- Context


type alias Context =
    { purpleColor : Color }


toContext : SharedState -> UiContextual Context
toContext sharedState =
    { device = sharedState.device
    , parentRole = Nothing
    , themeConfig = SharedState.getThemeConfig sharedState.theme
    , purpleColor = sharedState.purpleColor
    }



-- VIEW


view : SharedState -> Model -> Element Msg
view sharedState model =
    UiFramework.uiColumn
        [ width fill, height fill ]
        [ viewHeader
            { title = "Icon"
            , description = "FontAwesome 5 Icons with Bootstrap"
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
                    componentNavbar NavigateTo Routes.Icon
                , Container.simple [ width <| Element.fillPortion 6 ] <| content
                ]
        ]
        |> UiFramework.toElement (toContext sharedState)


content : UiElement Msg
content =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 64
        ]
        [ basicExample
        , gettingStarted
        , realLifeUses
        ]


basicExample : UiElement Msg
basicExample =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.title "Basic Example"
        , Component.wrappedText "Basic icons are rendered with Lattyware's Elm FontAwesome module. It is converted to an Element type (from Elm ui), though unfortunately the conversion from the Element type to the UiElement type seems a bit weird."
        , UiFramework.fromElement (\_ -> Icon.view FontAwesome.Solid.cog)
        , basicExampleCode
        ]


basicExampleCode : UiElement Msg
basicExampleCode =
    """
import UiFramework
import UiFramework.Icon as Icon
import FontAwesome.Solid as Solid


cogIcon =
    UiFramework.fromElement (\\_ -> Icon.view FontAwesome.Solid.cog)"""
        |> Util.uiHighlightCode "elm"


gettingStarted : UiElement Msg
gettingStarted =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.title "Getting Started"
        , Component.wrappedText "A stylesheet needs to be added in order for the icons to render properly, though. the FontAwesome.Styles.css is a nice Html function you can easily put in your code (after rendering it from a UiElement type) to easily add in all the necessary styles. Here is an example:"
        , gettingStartedCode
        ]


gettingStartedCode : UiElement Msg
gettingStartedCode =
    """
import Browser
import FontAwesome.Styles

-- top level viewApplication (possibly put in Router.elm)
viewApplication : Model -> SharedState -> Browser.Document Msg
viewApplication model sharedState =
    { title = "My Website"
    , body =
        [ FontAwesome.Styles.css
        , view model sharedState
        ]
    }"""
        |> Util.uiHighlightCode "elm"


type DropdownState
    = AllDown


realLifeUses : UiElement Msg
realLifeUses =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.title "Using Icons"
        , Component.wrappedText "Using icons may seem rather painful by itself, but they are easily implemented in Navbars and Buttons, for example."
        , UiFramework.uiRow
            [ spacing 8 ]
            [ Button.default
                |> Button.withLabel "Github"
                |> Button.withIcon FontAwesome.Brands.github
                |> Button.view
            , Button.default
                |> Button.withLabel "Check"
                |> Button.withIcon FontAwesome.Solid.check
                |> Button.withRole Success
                |> Button.view
            ]
        , iconButtonCode
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
                ]
            |> Navbar.view { toggleMenuState = False, dropdownState = AllDown }
        , iconNavbarCode
        ]


iconButtonCode : UiElement Msg
iconButtonCode =
    """
import FontAwesome.Brands
import FontAwesome.Solid
import UiFramework.Button as Button
import Element exposing (spacing)

iconButtons =
    UiFramework.uiRow 
        [ spacing 8 ]
        [ Button.default
            |> Button.withLabel "Github"
            |> Button.withIcon FontAwesome.Brands.github
            |> Button.view
        , Button.default
            |> Button.withLabel "Check"
            |> Button.withIcon FontAwesome.Solid.check
            |> Button.withRole Success
            |> Button.view 
        ]"""
        |> Util.uiHighlightCode "elm"


iconNavbarCode : UiElement Msg
iconNavbarCode =
    """
import UiFramework.Navbar as Navbar


type DropdownState 
    = AllDown


type Msg
    = ToggleNav
    | NoOp

Navbar.default NoOp
    |> Navbar.withBrand (Element.text "Navbar")
    |> Navbar.withMenuItems
        [ Navbar.linkItem ToggleNav
            |> Navbar.withMenuIcon FontAwesome.Solid.home
            |> Navbar.withMenuTitle "Home"
        , Navbar.linkItem NoOp
            |> Navbar.withMenuIcon FontAwesome.Solid.book
            |> Navbar.withMenuTitle "Blog"
        , Navbar.linkItem NoOp
            |> Navbar.withMenuIcon FontAwesome.Solid.addressBook
            |> Navbar.withMenuTitle "Contact"
        ]
    |> Navbar.view {toggleMenuState = False, dropdownState = AllDown}"""
        |> Util.uiHighlightCode "elm"



-- UPDATE


type Msg
    = NoOp
    | NavigateTo Routes.Route


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )

        NavigateTo route ->
            ( model, Util.navigate sharedState.navKey route, NoUpdate )
