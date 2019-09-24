module Page.Icon exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Common exposing (code, componentNavbar, highlightCode, moduleLayout, section, title, viewHeader, wrappedText)
import Element
import Element.Font as Font
import FontAwesome.Brands
import FontAwesome.Solid
import Html.Attributes
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


content =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 64
        ]
        [ gettingStarted
        , basicExample
        , realLifeUses
        , configuration
        , transform
        , layering
        ]


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


installFontAwesomeCode =
    Common.highlightCode "bash"
        """
elm install lattyware/elm-fontawesome
"""


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


basicExampleCode =
    Common.highlightCode "elm"
        """
import UiFramework.Icon as Icon
import FontAwesome.Solid


cogIcon =
    Icon.simple FontAwesome.Solid.cog
"""


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
            |> Navbar.view { toggleMenuState = False, dropdownState = False }
        , iconNavbarCode
        ]


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


iconNavbarCode =
    Common.highlightCode "elm"
        """
import FontAwesome.Solid
import UiFramework.Icon as Icon
import UiFramework.Navbar as Navbar


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
    |> Navbar.view {toggleMenuState = False, dropdownState = False}
"""


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
        , counterConfig
        , spinConfigs
        , pulseConfigs
        , borderConfigs
        ]


sizeConfigs =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "withSize"
        , wrappedText
            """
Icons inherit font size of their parent container, but you can also speicify the size by
using Icon.withSize function.
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


sizingCode =
    Common.highlightCode "elm"
        """
import FontAwesome.Solid
import UiFramework.Icon as Icon

UiFramework.uiWrappedRow
    [ Element.spacing 10
    , Element.width Element.fill
    ]
    ([ Icon.Xs, Icon.Sm, Icon.Regular, Icon.Lg ]
        ++ (List.range 2 7 |> List.map (\\n -> Icon.Num n))
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


counterConfig =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "withCounter"
        , wrappedText
            """
Use Icon.withCounter function to add a counter text at upper right corner of the icon.
"""
        , UiFramework.uiRow
            [ Element.spacing 20 ]
            [ Icon.fontAwesome FontAwesome.Solid.envelope
                |> Icon.withCounter { text = "2,999", attrs = [ Html.Attributes.style "background" "#FF6347" ] }
                |> Icon.withSize (Icon.Num 4)
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.globe
                |> Icon.withCounter { text = "!", attrs = [ Html.Attributes.style "background" "#FF6347" ] }
                |> Icon.withSize (Icon.Num 4)
                |> Icon.view
            ]
        , counterCode
        ]


counterCode =
    Common.highlightCode "elm"
        """
UiFramework.uiRow
    [ Element.spacing 20 ]
    [ Icon.fontAwesome FontAwesome.Solid.envelope
        |> Icon.withCounter { text = "2,999", attrs = [ Html.Attributes.style "background" "#FF6347" ] }
        |> Icon.withSize (Icon.Num 4)
        |> Icon.view
    , Icon.fontAwesome FontAwesome.Solid.globe
        |> Icon.withCounter { text = "!", attrs = [ Html.Attributes.style "background" "#FF6347" ] }
        |> Icon.withSize (Icon.Num 4)
        |> Icon.view
    ]
"""


spinConfigs =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "withSpin"
        , wrappedText
            """
To make the spinning icons, just use Icon.withSpin function.
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
        , wrappedText
            """
You can also make a spinnning icon from text.
"""
        , Icon.textIcon "rotate"
            |> Icon.withSpin
            |> Icon.withExtraAttributes [ Element.paddingXY 10 20 ]
            |> Icon.view
        , spinningTextCode
        ]


spinningCode =
    Common.highlightCode "elm"
        """
import FontAwesome.Solid
import UiFramework.Icon as Icon

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


spinningTextCode =
    Common.highlightCode "elm"
        """
import UiFramework.Icon as Icon

Icon.textIcon "rotate"
    |> Icon.withSpin
    |> Icon.view
"""


pulseConfigs =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "withPulse"
        , wrappedText
            """
Use Icon.withPulse function to make the icon rotating with 8 steps.
"""
        , Icon.fontAwesome FontAwesome.Solid.spinner
            |> Icon.withSize (Icon.Num 4)
            |> Icon.withPulse
            |> Icon.view
        , pulseCode
        ]


pulseCode =
    Common.highlightCode "elm"
        """
import FontAwesome.Solid
import UiFramework.Icon as Icon

Icon.fontAwesome FontAwesome.Solid.spinner
    |> Icon.withSize (Icon.Num 4)
    |> Icon.withPulse
    |> Icon.view
"""


borderConfigs =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "withBorder"
        , wrappedText
            """
Use Icon.withBortder function to add border.
"""
        , Icon.fontAwesome FontAwesome.Solid.arrowRight
            |> Icon.withSize (Icon.Num 2)
            |> Icon.withBorder
            |> Icon.view
        , borderCode
        ]


borderCode =
    Common.highlightCode "elm"
        """
import FontAwesome.Solid
import UiFramework.Icon as Icon

Icon.fontAwesome FontAwesome.Solid.arrowRight
    |> Icon.withSize (Icon.Num 4)
    |> Icon.withBorder
    |> Icon.view
"""


transform =
    UiFramework.uiColumn
        [ Element.spacing 48
        , Element.width Element.fill
        ]
        [ UiFramework.uiColumn
            [ Element.spacing 16 ]
            [ title "Transforms"
            , wrappedText
                """
We can use many transform functions to scale, position, flip, or rotate icons arbitrarily. 
"""
            ]
        , scaleConfigs
        , positionConfigs
        , rotationConfigs
        , flipConfigs
        , mixConfigs
        ]


scaleConfigs =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "withShrink and withGrow"
        , wrappedText
            """
Use Icon.withShrink or Icon.withGrow functions to scale icons. Units are 1/16em.
"""
        , UiFramework.uiRow [ Element.spacing 20 ]
            [ Icon.fontAwesome FontAwesome.Solid.seedling
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withShrink 8.0
                |> Icon.withBackground "#FFE4E1"
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.seedling
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withBackground "#FFE4E1"
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.seedling
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withGrow 6.0
                |> Icon.withBackground "#FFE4E1"
                |> Icon.view
            ]
        , scaleCode
        ]


scaleCode =
    Common.highlightCode "elm"
        """
import FontAwesome.Solid
import UiFramework
import UiFramework.Icon as Icon

UiFramework.uiRow [ Element.spacing 20 ]
    [ Icon.fontAwesome FontAwesome.Solid.seedling
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withShrink 8.0
        |> Icon.withBackground "#FFE4E1"
        |> Icon.view
    , Icon.fontAwesome FontAwesome.Solid.seedling
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withBackground "#FFE4E1"
        |> Icon.view
    , Icon.fontAwesome FontAwesome.Solid.seedling
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withGrow 6.0
        |> Icon.withBackground "#FFE4E1"
        |> Icon.view
    ]
"""


positionConfigs =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "withPosition"
        , wrappedText
            """
Use Icon.withPosUp, Icon.withPosDown, Icon.withPosLeft, Icon.withPosRight functions
to move icons up, down, left, or right.
"""
        , UiFramework.uiRow [ Element.spacing 20 ]
            [ Icon.fontAwesome FontAwesome.Solid.seedling
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withShrink 8.0
                |> Icon.withBackground "#FFE4E1"
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.seedling
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withShrink 8.0
                |> Icon.withBackground "#FFE4E1"
                |> Icon.withPosUp 6.0
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.seedling
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withShrink 8.0
                |> Icon.withBackground "#FFE4E1"
                |> Icon.withPosRight 6.0
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.seedling
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withShrink 8.0
                |> Icon.withBackground "#FFE4E1"
                |> Icon.withPosDown 6.0
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.seedling
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withShrink 8.0
                |> Icon.withBackground "#FFE4E1"
                |> Icon.withPosLeft 6.0
                |> Icon.view
            ]
        , positionCode
        ]


positionCode =
    Common.highlightCode "elm"
        """
import FontAwesome.Solid
import UiFramework
import UiFramework.Icon as Icon

UiFramework.uiRow [ Element.spacing 20 ]
    [ Icon.fontAwesome FontAwesome.Solid.seedling
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withShrink 8.0
        |> Icon.withBackground "#FFE4E1"
        |> Icon.view
    , Icon.fontAwesome FontAwesome.Solid.seedling
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withShrink 8.0
        |> Icon.withBackground "#FFE4E1"
        |> Icon.withPosUp 6.0
        |> Icon.view
    , Icon.fontAwesome FontAwesome.Solid.seedling
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withShrink 8.0
        |> Icon.withBackground "#FFE4E1"
        |> Icon.withPosRight 6.0
        |> Icon.view
    , Icon.fontAwesome FontAwesome.Solid.seedling
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withShrink 8.0
        |> Icon.withBackground "#FFE4E1"
        |> Icon.withPosDown 6.0
        |> Icon.view
    , Icon.fontAwesome FontAwesome.Solid.seedling
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withShrink 8.0
        |> Icon.withBackground "#FFE4E1"
        |> Icon.withPosLeft 6.0
        |> Icon.view
    ]
"""


rotationConfigs =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "withRotation"
        , wrappedText
            """
To rotate an icon, use Icon.withRotation, and passing a degree to rotate.
"""
        , UiFramework.uiRow [ Element.spacing 20 ]
            [ Icon.fontAwesome FontAwesome.Solid.seedling
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withRotation 90
                |> Icon.withBackground "#FFE4E1"
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.seedling
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withRotation 180
                |> Icon.withBackground "#FFE4E1"
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.seedling
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withRotation 30
                |> Icon.withBackground "#FFE4E1"
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.seedling
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withRotation -30
                |> Icon.withBackground "#FFE4E1"
                |> Icon.view
            ]
        , rotationCode
        ]


rotationCode =
    Common.highlightCode "elm"
        """
import FontAwesome.Solid
import UiFramework
import UiFramework.Icon as Icon

UiFramework.uiRow [ Element.spacing 20 ]
    [ Icon.fontAwesome FontAwesome.Solid.seedling
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withRotation 90
        |> Icon.withBackground "#FFE4E1"
        |> Icon.view
    , Icon.fontAwesome FontAwesome.Solid.seedling
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withRotation 180
        |> Icon.withBackground "#FFE4E1"
        |> Icon.view
    , Icon.fontAwesome FontAwesome.Solid.seedling
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withRotation 30
        |> Icon.withBackground "#FFE4E1"
        |> Icon.view
    , Icon.fontAwesome FontAwesome.Solid.seedling
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withRotation -30
        |> Icon.withBackground "#FFE4E1"
        |> Icon.view
    ]
"""


flipConfigs =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "withFlipV and withFlipH"
        , wrappedText
            """
Use Icon.withFlipV to flip icon vertically, and Icon.withFlipH to flip icon horizontally.
"""
        , UiFramework.uiRow [ Element.spacing 20 ]
            [ Icon.fontAwesome FontAwesome.Solid.seedling
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withBackground "#FFE4E1"
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.seedling
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withFlipV
                |> Icon.withBackground "#FFE4E1"
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.seedling
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withFlipH
                |> Icon.withBackground "#FFE4E1"
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.seedling
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withFlipV
                |> Icon.withFlipH
                |> Icon.withBackground "#FFE4E1"
                |> Icon.view
            ]
        , flipCode
        ]


flipCode =
    Common.highlightCode "elm"
        """
import FontAwesome.Solid
import UiFramework
import UiFramework.Icon as Icon

UiFramework.uiRow [ Element.spacing 20 ]
    [ Icon.fontAwesome FontAwesome.Solid.seedling
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withBackground "#FFE4E1"
        |> Icon.view
    , Icon.fontAwesome FontAwesome.Solid.seedling
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withFlipV
        |> Icon.withBackground "#FFE4E1"
        |> Icon.view
    , Icon.fontAwesome FontAwesome.Solid.seedling
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withFlipH
        |> Icon.withBackground "#FFE4E1"
        |> Icon.view
    , Icon.fontAwesome FontAwesome.Solid.seedling
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withFlipV
        |> Icon.withFlipH
        |> Icon.withBackground "#FFE4E1"
        |> Icon.view
    ]
"""


mixConfigs =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "Mix and match "
        , wrappedText
            """
All those above transform functions are composable, you can mix and match together
on a single icon.
"""
        , UiFramework.uiRow [ Element.spacing 20 ]
            [ Icon.fontAwesome FontAwesome.Solid.smileBeam
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withBackground "#FFE4E1"
                |> Icon.withRotation 30
                |> Icon.withShrink 8.0
                |> Icon.withPosRight 6.0
                |> Icon.withPosUp 6.0
                |> Icon.view
            ]
        , mixCode
        ]


mixCode =
    Common.highlightCode "elm"
        """
import FontAwesome.Solid
import UiFramework
import UiFramework.Icon as Icon

UiFramework.uiRow [ Element.spacing 20 ]
    [ Icon.fontAwesome FontAwesome.Solid.smileBeam
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withBackground "#FFE4E1"
        |> Icon.withRotation 30
        |> Icon.withShrink 8.0
        |> Icon.withPosRight 6.0
        |> Icon.withPosUp 6.0
        |> Icon.view
    ]
"""


layering =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 48
        ]
        [ title "Layering"
        , UiFramework.uiParagraph
            []
            [ UiFramework.uiText "Another way to compose icons is to place icons"
            , UiFramework.uiText " and text visually on top of each other, use "
            , code "Icon.layer"
            , UiFramework.uiText " function:"
            ]
        , UiFramework.uiWrappedRow
            [ Element.spacing 20 ]
            [ Icon.fontAwesome FontAwesome.Solid.circle
                |> Icon.lay
                    (Icon.fontAwesome FontAwesome.Solid.times
                        |> Icon.withInverse
                        |> Icon.withShrink 6
                    )
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withBackground "#FFE4E1"
                |> Icon.withColor "#FF6347"
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.bookmark
                |> Icon.lay
                    (Icon.fontAwesome FontAwesome.Solid.heart
                        |> Icon.withInverse
                        |> Icon.withShrink 10
                        |> Icon.withPosUp 2
                        |> Icon.withColor "#FF6347"
                    )
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withBackground "#FFE4E1"
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.play
                |> Icon.withRotation -90
                |> Icon.lay
                    (Icon.fontAwesome FontAwesome.Solid.sun
                        |> Icon.withInverse
                        |> Icon.withShrink 10
                        |> Icon.withPosUp 2
                    )
                |> Icon.lay
                    (Icon.fontAwesome FontAwesome.Solid.moon
                        |> Icon.withInverse
                        |> Icon.withShrink 11
                        |> Icon.withPosDown 4.2
                        |> Icon.withPosLeft 4
                    )
                |> Icon.lay
                    (Icon.fontAwesome FontAwesome.Solid.star
                        |> Icon.withInverse
                        |> Icon.withShrink 11
                        |> Icon.withPosDown 4.2
                        |> Icon.withPosRight 4
                    )
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withBackground "#FFE4E1"
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.calendar
                |> Icon.lay
                    (Icon.textIcon "27"
                        |> Icon.withInverse
                        |> Icon.withShrink 8
                        |> Icon.withPosDown 3
                    )
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withBackground "#FFE4E1"
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.certificate
                |> Icon.lay
                    (Icon.textIcon "NEW"
                        |> Icon.withInverse
                        |> Icon.withShrink 11.5
                        |> Icon.withRotation -30
                        |> Icon.withHtmlAttributes [ Html.Attributes.style "font-weight" "900" ]
                    )
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withBackground "#FFE4E1"
                |> Icon.view
            ]
        , layeringCode
        ]


layeringCode =
    Common.highlightCode "elm"
        """
UiFramework.uiRow [ Element.spacing 20 ]
    [ Icon.fontAwesome FontAwesome.Solid.circle
        |> Icon.lay
            (Icon.fontAwesome FontAwesome.Solid.times
                |> Icon.withInverse
                |> Icon.withShrink 6
            )
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withBackground "#FFE4E1"
        |> Icon.withColor "#FF6347"
        |> Icon.view
    , Icon.fontAwesome FontAwesome.Solid.bookmark
        |> Icon.lay
            (Icon.fontAwesome FontAwesome.Solid.heart
                |> Icon.withInverse
                |> Icon.withShrink 10
                |> Icon.withPosUp 2
                |> Icon.withColor "#FF6347"
            )
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withBackground "#FFE4E1"
        |> Icon.view
    , Icon.fontAwesome FontAwesome.Solid.play
        |> Icon.withRotation -90
        |> Icon.lay
            (Icon.fontAwesome FontAwesome.Solid.sun
                |> Icon.withInverse
                |> Icon.withShrink 10
                |> Icon.withPosUp 2
            )
        |> Icon.lay
            (Icon.fontAwesome FontAwesome.Solid.moon
                |> Icon.withInverse
                |> Icon.withShrink 11
                |> Icon.withPosDown 4.2
                |> Icon.withPosLeft 4
            )
        |> Icon.lay
            (Icon.fontAwesome FontAwesome.Solid.star
                |> Icon.withInverse
                |> Icon.withShrink 11
                |> Icon.withPosDown 4.2
                |> Icon.withPosRight 4
            )
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withBackground "#FFE4E1"
        |> Icon.view
    , Icon.fontAwesome FontAwesome.Solid.calendar
        |> Icon.lay
            (Icon.textIcon "27"
                |> Icon.withInverse
                |> Icon.withShrink 8
                |> Icon.withPosDown 3
            )
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withBackground "#FFE4E1"
        |> Icon.view
    , Icon.fontAwesome FontAwesome.Solid.certificate
        |> Icon.lay
            (Icon.textIcon "NEW"
                |> Icon.withInverse
                |> Icon.withShrink 11.5
                |> Icon.withRotation -30
                |> Icon.withHtmlAttributes [ Html.Attributes.style "font-weight" "900" ]
            )
        |> Icon.withSize (Icon.Num 4)
        |> Icon.withBackground "#FFE4E1"
        |> Icon.view
    ]
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
