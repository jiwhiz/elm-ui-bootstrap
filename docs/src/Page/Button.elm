module Page.Button exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Common exposing (code, componentNavbar, highlightCode, moduleLayout, roleAndNameList, section, title, viewHeader, wrappedText)
import Element
import FontAwesome.Brands
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Button as Button
import UiFramework.Container as Container
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
        , wrappedText "Though used primarily with navbars, buttons with icons can serve other uses as well."
        , UiFramework.uiParagraph []
            [ UiFramework.uiText "Note that you'll have to "
            , UiFramework.uiText "include the required CSS in your website "
            , UiFramework.uiText "(check out the Elm FontAwesome page for more details - "
            , UiFramework.uiText "https://github.com/lattyware/elm-fontawesome/tree/3.1.0#required-css)"
            ]
        , UiFramework.uiParagraph []
            [ UiFramework.uiText "As of now, you cannot add a custom"
            , code "UiElement"
            , UiFramework.uiText " to a button. This means you cannot add an animated icon, for example."
            ]
        , UiFramework.uiWrappedRow
            [ Element.spacing 4 ]
            [ Button.default
                |> Button.withLabel "Github"
                |> Button.withIcon FontAwesome.Brands.github
                |> Button.view
            ]
        , iconConfigCode
        ]


iconConfigCode : UiElement Msg
iconConfigCode =
    Common.highlightCode "elm"
        """
import FontAwesome.Brands

buttonSizes =
    UiFramework.uiWrappedRow
        [ Element.spacing 4 ]
        [ Button.default
            |> Button.withLabel "Github"
            |> Button.withIcon FontAwesome.Brands.github
            |> Button.view
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
