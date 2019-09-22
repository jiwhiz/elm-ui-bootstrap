module Page.Button exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Common exposing (code, componentNavbar, highlightCode, moduleLayout, roleAndNameList, section, title, viewHeader, wrappedText)
import Element
import FontAwesome.Brands
import FontAwesome.Solid
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Badge as Badge
import UiFramework.Button as Button
import UiFramework.Container as Container
import UiFramework.Icon as Icon
import UiFramework.Types exposing (Role(..))


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
        { title = "Button"
        , description = "Click Click Click Click Click Click Click Click Click Click"
        , navigateToMsg = NavigateTo
        , currentRoute = Routes.Button
        , content = content
        }
        |> UiFramework.toElement (toContext sharedState)


content : UiElement Msg
content =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 64
        ]
        [ basicExample
        , configuration
        , linkExample
        ]


basicExample : UiElement Msg
basicExample =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ title "Basic Example"
        , wrappedText
            """
Default buttons take in a message to trigger when clicked, and a string for the label. 
Icons are optional, and can be added through configuration.
"""
        , UiFramework.uiWrappedRow
            [ Element.spacing 4 ]
            [ Button.simple NoOp "Do Something" ]
        , basicExampleCode
        ]


basicExampleCode : UiElement Msg
basicExampleCode =
    Common.highlightCode "elm"
        """
import Element
import UiFramework
import UiFramework.Button as Button

type Msg 
    = DoSomething

importantButton =
    Button.simple DoSomething "Do something"
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
When configuring, we use pipelines to build up our button, starting from the default function, 
"""
                , code "Button.default"
                ]
            ]
        , configExampleCode
        , roleConfig
        , basicFunctionalityConfig
        , outlineConfig
        , sizeConfig
        , blockConfig
        , disableConfig
        , iconConfig
        , badgeConfig
        ]


configExampleCode : UiElement Msg
configExampleCode =
    Common.highlightCode "elm"
        """
import FontAwesome.Solid
import UiFramework.Types exposing (Role(..))


-- using Lattyware's FontAwesome module 
-- (https://package.elm-lang.org/packages/lattyware/elm-fontawesome/3.1.0/)



type Msg 
    = DoSomething


-- an example showing all the configurations available at the moment



customButton =
    Button.default
        |> Button.withRole Info
        |> Button.withOutlined
        |> Button.withBlock
        |> Button.withDisabled
        |> Button.withLarge -- or withSmall
        |> Button.withMessage (Just DoSomething)
        |> Button.withIcon FontAwesome.Solid.angleDoubleRight
        |> Button.withLabel "Button with Icon"
        |> Button.view
"""


roleConfig : UiElement Msg
roleConfig =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ section "Roles"
        , wrappedText
            """
There are 6 roles for a button, as well as a Light and Dark role. By default it is the Primary role
"""
        , UiFramework.uiWrappedRow
            [ Element.spacing 4 ]
            (List.map
                (\( role, name ) ->
                    Button.default
                        |> Button.withLabel name
                        |> Button.withRole role
                        |> Button.view
                )
                roleAndNameList
            )
        , roleConfigCode
        ]


roleConfigCode : UiElement Msg
roleConfigCode =
    Common.highlightCode "elm"
        """
{-| All the roles are:
  - Primary
  - Secondary
  - Success
  - Info
  - Warning
  - Danger
  - Light
  - Dark
-}

buttons =
    UiFramework.uiRow 
        [ Element.spacing 4 ] 
        [ -- no need for a Button.withRole for the Primary one
        Button.default
            |> Button.withLabel "Primary"
            |> Button.view
        , Button.default
            |> Button.withLabel "Secondary"
            |> Button.withRole Secondary
            |> Button.view
        ...
        ]
"""


basicFunctionalityConfig : UiElement Msg
basicFunctionalityConfig =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ section "withMessage and withLabel"
        , wrappedText
            """
These provide the same functionality as Button.simple. By default, 
every button has a label of an empty string and Nothing for a message.
"""
        , Button.simple NoOp "Button"
        , basicFunctionalityConfigCode
        ]


basicFunctionalityConfigCode : UiElement Msg
basicFunctionalityConfigCode =
    Common.highlightCode "elm"
        """
type Msg 
    = DoSomething 


basicButton =
    Button.simple DoSomething "Button"


-- is the same as 

basicButton =
    Button.default 
        |> Button.withMessage (Just DoSomething)
        |> Button.withLabel "Button"
"""


outlineConfig : UiElement Msg
outlineConfig =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ section "Outline"
        , UiFramework.uiParagraph []
            [ UiFramework.uiText "Bootstrap gives you "
            , code "Button.withOutlined"
            , UiFramework.uiText ", where the background colors are removed."
            ]
        , UiFramework.uiWrappedRow
            [ Element.spacing 4 ]
            (List.map
                (\( role, name ) ->
                    Button.default
                        |> Button.withLabel name
                        |> Button.withRole role
                        |> Button.withOutlined
                        |> Button.view
                )
                roleAndNameList
            )
        , outlineConfigCode
        ]


outlineConfigCode : UiElement Msg
outlineConfigCode =
    Common.highlightCode "elm"
        """
outlinedButtons =
    UiFramework.uiRow 
        [ Element.spacing 4 ] 
        [ Button.default
            |> Button.withLabel "Primary"
            |> Button.withOutlined
            |> Button.view
        , Button.default
            |> Button.withLabel "Secondary"
            |> Button.withRole Secondary
            |> Button.withOutlined
            |> Button.view
        ...
        ]
"""


sizeConfig : UiElement Msg
sizeConfig =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ section "Sizes"
        , wrappedText "Large and small buttons differ in font and padding size."
        , UiFramework.uiWrappedRow
            [ Element.spacing 4 ]
            [ Button.default
                |> Button.withLabel "Large Button"
                |> Button.withLarge
                |> Button.view
            , Button.default
                |> Button.withLabel "Regular Button"
                |> Button.view
            , Button.default
                |> Button.withLabel "Small Button"
                |> Button.withSmall
                |> Button.view
            ]
        , sizeConfigCode
        ]


sizeConfigCode : UiElement Msg
sizeConfigCode =
    Common.highlightCode "elm"
        """
buttonSizes =
    UiFramework.uiWrappedRow
        [ Element.spacing 4 ]
        [ Button.default
            |> Button.withLabel "Large Button"
            |> Button.withLarge
            |> Button.view
        , Button.default
            |> Button.withLabel "Regular Button"
            |> Button.view
        , Button.default
            |> Button.withLabel "Small Button"
            |> Button.withSmall
            |> Button.view
        ]
"""


blockConfig : UiElement Msg
blockConfig =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ section "Block buttons"
        , UiFramework.uiParagraph []
            [ UiFramework.uiText "Take up the entirety of the parent container width via the "
            , code "withBlock"
            , UiFramework.uiText " function. This option is not functional yet."
            ]
        , Button.default
            |> Button.withLabel "Block Button"
            |> Button.withBlock
            |> Button.view
        , blockConfigCode
        ]


blockConfigCode : UiElement Msg
blockConfigCode =
    Common.highlightCode "elm"
        """
blockButton =
    Button.default
        |> Button.withLabel "Block Button"
        |> Button.withBlock
        |> Button.view
"""


disableConfig : UiElement Msg
disableConfig =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ section "Disabled buttons"
        , UiFramework.uiParagraph []
            [ UiFramework.uiText "Make a button look inactive by the "
            , code "withDisabled"
            , UiFramework.uiText " function."
            ]
        , UiFramework.uiWrappedRow
            [ Element.spacing 4 ]
            (List.map
                (\( role, name ) ->
                    Button.default
                        |> Button.withLabel name
                        |> Button.withRole role
                        |> Button.withDisabled
                        |> Button.view
                )
                roleAndNameList
            )
        , disableConfigCode
        ]


disableConfigCode : UiElement Msg
disableConfigCode =
    Common.highlightCode "elm"
        """
buttonSizes =
    UiFramework.uiWrappedRow
        [ Element.spacing 4 ]
        [ Button.default
            |> Button.withLabel "Primary"
            |> Button.withDisabled
            |> Button.view
        , Button.default
            |> Button.withLabel "Secondary"
            |> Button.withRole Secondary
            |> Button.withDisabled
            |> Button.view
        ...
        ]
"""


iconConfig : UiElement Msg
iconConfig =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ section "Buttons with Icons"
        , wrappedText "You can add any icon to a button."
        , UiFramework.uiWrappedRow
            [ Element.spacing 4 ]
            [ Button.default
                |> Button.withLabel "Github"
                |> Button.withIcon (Icon.fontAwesome FontAwesome.Brands.github)
                |> Button.view
            ]
        , iconConfigCode
        , wrappedText "You can make the icon spinning."
        , UiFramework.uiWrappedRow
            [ Element.spacing 4 ]
            [ Button.default
                |> Button.withLabel "Loading..."
                |> Button.withIcon
                    (Icon.fontAwesome FontAwesome.Solid.spinner |> Icon.withSpin)
                |> Button.withDisabled
                |> Button.view
            ]
        , iconSpinningConfigCode
        , UiFramework.uiParagraph []
            [ UiFramework.uiText "See "
            , Button.link { onPress = Just <| NavigateTo Routes.Icon, label = UiFramework.uiText "Icon module" }
            , UiFramework.uiText " to learn more about Icons."
            ]
        ]


iconConfigCode : UiElement Msg
iconConfigCode =
    Common.highlightCode "elm"
        """
import FontAwesome.Brands

githubButton =
    Button.default
        |> Button.withLabel "Github"
        |> Button.withIcon (Icon.fontAwesome FontAwesome.Brands.github)
        |> Button.view

"""


iconSpinningConfigCode : UiElement Msg
iconSpinningConfigCode =
    Common.highlightCode "elm"
        """
import FontAwesome.Solid

loadingButton =
    Button.default
        |> Button.withLabel "Loading..."
        |> Button.withIcon
            (Icon.fontAwesome FontAwesome.Solid.spinner |> Icon.withSpin)
        |> Button.withDisabled
        |> Button.view

"""


badgeConfig : UiElement Msg
badgeConfig =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ section "Buttons with Badges"
        , wrappedText
            """
You can add badge to buttons. For example, to provide a counter for notification:
"""
        , UiFramework.uiWrappedRow
            [ Element.spacing 4 ]
            [ Button.default
                |> Button.withLabel "Notifications"
                |> Button.withBadge (Badge.default |> Badge.withLabel "4" |> Badge.withRole Light)
                |> Button.view
            ]
        , badgeConfigCode
        ]


badgeConfigCode : UiElement Msg
badgeConfigCode =
    Common.highlightCode "elm"
        """
import FontAwesome.Brands

notificationButton =
    Button.default
        |> Button.withLabel "Notifications"
        |> Button.withBadge (Badge.default |> Badge.withLabel "4" |> Badge.withRole Light)
        |> Button.view

"""


linkExample : UiElement Msg
linkExample =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ title "Link Example"
        , wrappedText
            """
Link buttons are special, they are rendered as links, but might trigger Elm messages, 
usually NagivateTo message.
"""
        , UiFramework.uiWrappedRow
            [ Element.spacing 4 ]
            [ Button.link
                { onPress = Just <| NavigateTo Routes.Home
                , label = UiFramework.uiText "Go to home page"
                }
            ]
        , linkExampleCode
        ]


linkExampleCode : UiElement Msg
linkExampleCode =
    Common.highlightCode "elm"
        """
linkButton =
    Button.link
        { onPress = Just <| NavigateTo Routes.Home
        , label = UiFramework.uiText "Go to home page"
        }
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
