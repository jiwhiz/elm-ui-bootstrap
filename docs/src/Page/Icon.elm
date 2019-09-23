module Page.Icon exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Common exposing (code, componentNavbar, highlightCode, moduleLayout, section, title, viewHeader, wrappedText)
import Element
import Element.Font as Font
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



-- UIFRAMEWORK TYPE


type alias UiElement msg =
    WithContext {} msg



-- MODEL


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )


toContext : SharedState -> UiContextual {}
toContext sharedState =
    { device = sharedState.device
    , parentRole = Nothing
    , themeConfig = sharedState.themeConfig
    }



-- VIEW


view : SharedState -> Model -> Element.Element Msg
view sharedState model =
    moduleLayout
        { title = "Icon"
        , description = "FontAwesome 5 Icons with Bootstrap"
        , navigateToMsg = NavigateTo
        , currentRoute = Routes.Icon
        , content = content
        }
        |> UiFramework.toElement (toContext sharedState)


content : UiElement Msg
content =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 64
        ]
        [ gettingStarted
        , basicExample
        , realLifeUses
        , configuration
        ]


gettingStarted : UiElement Msg
gettingStarted =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ title "Getting Started"
        , UiFramework.uiParagraph []
            [ UiFramework.uiText "Currently elm-ui-bootstrap supports "
            , UiFramework.uiLink
                { url = "https://fontawesome.com/icons"
                , label = "Font Awesome icons"
                }
            , UiFramework.uiText ". In order to use use Font Awesome, you need to install "
            , UiFramework.uiLink
                { url = "https://github.com/lattyware/elm-fontawesome"
                , label = "lattyware/elm-fontawesome"
                }
            , UiFramework.uiText ". For example:"
            ]
        , installFontAwesomeCode
        , UiFramework.uiParagraph []
            [ UiFramework.uiText "A stylesheet needs to be added in order for the icons to render properly. The "
            , code "FontAwesome.Styles.css"
            , UiFramework.uiText " is a nice Html function you can easily put in your code (after rendering it from a "
            , code "UiElement"
            , UiFramework.uiText " type) to easily add in all the necessary styles. Here is an example:"
            ]
        , gettingStartedCode
        ]


installFontAwesomeCode : UiElement Msg
installFontAwesomeCode =
    Common.highlightCode "bash"
        """
elm install lattyware/elm-fontawesome
"""


gettingStartedCode : UiElement Msg
gettingStartedCode =
    Common.highlightCode "elm"
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
    }
"""


basicExample : UiElement Msg
basicExample =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ title "Basic Example"
        , UiFramework.uiParagraph
            []
            [ UiFramework.uiText "Basic icons are rendered directly with "
            , code "Icon.simple"
            , UiFramework.uiText " function:"
            ]
        , Icon.simple FontAwesome.Solid.cog
        , basicExampleCode
        ]


basicExampleCode : UiElement Msg
basicExampleCode =
    Common.highlightCode "elm"
        """
import UiFramework.Icon as Icon
import FontAwesome.Solid


cogIcon =
    Icon.simple FontAwesome.Solid.cog
"""


type DropdownState
    = AllDown


realLifeUses : UiElement Msg
realLifeUses =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ title "Using Icons"
        , UiFramework.uiParagraph
            []
            [ UiFramework.uiText "With  "
            , code "Icon.fontawesome"
            , UiFramework.uiText " function, you can create an Icon value and pass it around."
            , UiFramework.uiText "For example, you can add icon to buttons or navbars easily. "
            ]
        , UiFramework.uiRow
            [ Element.spacing 8 ]
            [ Button.default
                |> Button.withLabel "Github"
                |> Button.withIcon (Icon.fontAwesome FontAwesome.Brands.github)
                |> Button.view
            , Button.default
                |> Button.withLabel "Check"
                |> Button.withIcon (Icon.fontAwesome FontAwesome.Solid.check)
                |> Button.withRole Success
                |> Button.view
            ]
        , iconButtonCode
        , Navbar.default NoOp
            |> Navbar.withBrand (Element.text "Navbar")
            |> Navbar.withMenuItems
                [ Navbar.linkItem NoOp
                    |> Navbar.withMenuIcon (Icon.fontAwesome FontAwesome.Solid.home)
                    |> Navbar.withMenuTitle "Home"
                , Navbar.linkItem NoOp
                    |> Navbar.withMenuIcon (Icon.fontAwesome FontAwesome.Solid.book)
                    |> Navbar.withMenuTitle "Blog"
                , Navbar.linkItem NoOp
                    |> Navbar.withMenuIcon (Icon.fontAwesome FontAwesome.Solid.addressBook)
                    |> Navbar.withMenuTitle "Contact"
                ]
            |> Navbar.view { toggleMenuState = False, dropdownState = AllDown }
        , iconNavbarCode
        ]


iconButtonCode : UiElement Msg
iconButtonCode =
    Common.highlightCode "elm"
        """
import FontAwesome.Brands
import FontAwesome.Solid
import UiFramework.Button as Button
import UiFramework.Icon as Icon

iconButtons =
    UiFramework.uiRow 
        [ spacing 8 ]
        [ Button.default
            |> Button.withLabel "Github"
            |> Button.withIcon (Icon.fontAwesome FontAwesome.Brands.github)
            |> Button.view
        , Button.default
            |> Button.withLabel "Check"
            |> Button.withIcon (Icon.fontAwesome FontAwesome.Solid.check)
            |> Button.withRole Success
            |> Button.view 
        ]
"""


iconNavbarCode : UiElement Msg
iconNavbarCode =
    Common.highlightCode "elm"
        """
import FontAwesome.Solid
import UiFramework.Icon as Icon
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
            |> Navbar.withMenuIcon (Icon.fontAwesome FontAwesome.Solid.home)
            |> Navbar.withMenuTitle "Home"
        , Navbar.linkItem NoOp
            |> Navbar.withMenuIcon (Icon.fontAwesome FontAwesome.Solid.book)
            |> Navbar.withMenuTitle "Blog"
        , Navbar.linkItem NoOp
            |> Navbar.withMenuIcon (Icon.fontAwesome FontAwesome.Solid.addressBook)
            |> Navbar.withMenuTitle "Contact"
        ]
    |> Navbar.view {toggleMenuState = False, dropdownState = AllDown}
"""


configuration : UiElement Msg
configuration =
    UiFramework.uiColumn
        [ Element.spacing 48
        , Element.width Element.fill
        ]
        [ UiFramework.uiColumn
            [ Element.spacing 16 ]
            [ title "Configurations"
            , UiFramework.uiParagraph []
                [ UiFramework.uiText
                    """
Icon module also supports Font Awesome styling through configuration, such as 
sizing, spinning, rotating, stacking, etc. Starting from the 
"""
                , code "Icon.fontawesome"
                , UiFramework.uiText " function, or "
                , code "Icon.text"
                , UiFramework.uiText " function."
                ]
            ]
        , sizeConfigs
        , spinConfigs
        ]


sizeConfigs : UiElement Msg
sizeConfigs =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "Sizing"
        , wrappedText
            """
Icons inherit font size of their parent container, but you can also speicify the size.
Size type includes following:
"""
        , sizeTypeCode
        , wrappedText
            """
And for Num, you can set from 2 to 10, which means double the size to 10 times the size.
"""
        , UiFramework.uiWrappedRow
            [ Element.spacing 10
            , Element.width Element.fill
            ]
            ([ Icon.Xs, Icon.Sm, Icon.Regular, Icon.Lg ]
                ++ (List.range 2 7 |> List.map (\n -> Icon.Num n))
                |> List.map
                    (\size ->
                        Icon.fontAwesome
                            FontAwesome.Solid.camera
                            |> Icon.withSize size
                            |> Icon.withExtraAttributes [ Element.alignBottom ]
                            |> Icon.view
                    )
            )
        , sizingCode
        ]


sizeTypeCode : UiElement Msg
sizeTypeCode =
    Common.highlightCode "elm"
        """
type Size
    = Xs
    | Sm
    | Lg
    | Num Int
    | Regular
"""


sizingCode : UiElement Msg
sizingCode =
    Common.highlightCode "elm"
        """
UiFramework.uiWrappedRow
    [ Element.spacing 10
    , Element.width Element.fill
    ]
    ([ Icon.Xs, Icon.Sm, Icon.Regular, Icon.Lg ]
        ++ (List.range 2 7 |> List.map (
 -> Icon.Num n))
        |> List.map
            (\\size ->
                Icon.fontAwesome
                    FontAwesome.Solid.camera
                    |> Icon.withSize size
                    |> Icon.withExtraAttributes [ Element.alignBottom ]
                    |> Icon.view
            )
    )
"""


spinConfigs : UiElement Msg
spinConfigs =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "Spinning"
        , wrappedText
            """
To make the spinning icons, just use Icon.withSpin function
"""
        , UiFramework.uiWrappedRow
            [ Element.spacing 10
            , Element.width Element.fill
            ]
            ([ FontAwesome.Solid.circleNotch
             , FontAwesome.Solid.fan
             , FontAwesome.Solid.spinner
             , FontAwesome.Solid.sync
             , FontAwesome.Solid.asterisk
             , FontAwesome.Solid.slash
             ]
                |> List.map
                    (\icon ->
                        Icon.fontAwesome icon
                            |> Icon.withSize (Icon.Num 2)
                            |> Icon.withSpin
                            |> Icon.view
                    )
            )
        , spinningCode
        ]


spinningCode : UiElement Msg
spinningCode =
    Common.highlightCode "elm"
        """
UiFramework.uiWrappedRow
    [ Element.spacing 10
    , Element.width Element.fill
    ]
    ([ FontAwesome.Solid.circleNotch
     , FontAwesome.Solid.fan
     , FontAwesome.Solid.spinner
     , FontAwesome.Solid.sync
     , FontAwesome.Solid.asterisk
     , FontAwesome.Solid.slash
     ]
        |> List.map
            (\\icon ->
                Icon.fontAwesome icon
                    |> Icon.withSize (Icon.Num 2)
                    |> Icon.withSpin
                    |> Icon.view
            )
    )
"""



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
            ( model, Navigation.pushUrl sharedState.navKey (Routes.toUrlString route), NoUpdate )
