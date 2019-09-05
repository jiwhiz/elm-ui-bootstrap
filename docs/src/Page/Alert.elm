module Page.Alert exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Common exposing (code, componentNavbar, highlightCode, moduleLayout, roleAndNameList, section, title, viewHeader, wrappedText)
import Element
import Element.Border as Border
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Alert as Alert
import UiFramework.Badge as Badge
import UiFramework.Container as Container
import UiFramework.Types exposing (Role(..))
import UiFramework.Typography as Typography


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
        { title = "Alert"
        , description = "Fancy info"
        , navigateToMsg = NavigateTo
        , currentRoute = Routes.Alert
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
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ title "Basic Example"
        , wrappedText "Alerts are available in 8 different roles and are available for any length of text"
        , UiFramework.uiColumn
            [ Element.spacing 8
            , Element.width Element.fill
            ]
            [ Alert.simple Primary (UiFramework.uiText "Primary role!")
            , Alert.simple Secondary (UiFramework.uiText "Secondary role!")
            , Alert.simple Success (UiFramework.uiText "Success role!")
            , Alert.simple Info (UiFramework.uiText "Info role!")
            , Alert.simple Warning (UiFramework.uiText "Warning role!")
            , Alert.simple Danger (UiFramework.uiText "Danger role!")
            , Alert.simple Light (UiFramework.uiText "Light role!")
            , Alert.simple Dark (UiFramework.uiText "Dark role!")
            ]
        , basicExampleCode
        ]


basicExampleCode : UiElement Msg
basicExampleCode =
    Common.highlightCode "elm"
        """
import Element
import UiFramework
import UiFramework.Alert as Alert
import UiFramework.Types exposing (Role(..))

UiFramework.uiColumn 
    [ Element.spacing 8
    , Element.width Element.fill
    ] 
    [ Alert.simple Primary (UiFramework.uiText "Primary role!")
    , Alert.simple Secondary (UiFramework.uiText "Secondary role!")
    , Alert.simple Success (UiFramework.uiText "Success role!")
    , Alert.simple Info (UiFramework.uiText "Info role!")
    , Alert.simple Warning (UiFramework.uiText "Warning role!")
    , Alert.simple Danger (UiFramework.uiText "Danger role!")
    , Alert.simple Light (UiFramework.uiText "Light role!")
    , Alert.simple Dark (UiFramework.uiText "Dark role!")
    ]
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
When configuring, we use pipelines to build up our badge, starting from the default function, 
"""
                , code "Alert.default"
                ]
            ]
        , configExampleCode
        , sizeConfigs
        , roleConfigs
        , childConfigs
        , attributeConfigs
        ]


configExampleCode : UiElement Msg
configExampleCode =
    Common.highlightCode "elm"
        """
-- an example showing all the configurations available at the moment

customBadge =
    Alert.default
        |> Alert.withSmall -- or withLarge
        |> Alert.withRole Secondary
        |> Alert.withExtraAttrs []
        |> Alert.withChild (UiFramework.uiText "Hello!")
        |> Alert.view
"""


sizeConfigs : UiElement Msg
sizeConfigs =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "Sizing"
        , wrappedText "There are three sizes available to alerts."
        , UiFramework.uiColumn
            [ Element.spacing 8
            , Element.width Element.fill
            ]
            [ Alert.default
                |> Alert.withLarge
                |> Alert.withChild (UiFramework.uiText "Large alert!")
                |> Alert.view
            , Alert.simple Primary (UiFramework.uiText "Default alert!")
            , Alert.default
                |> Alert.withSmall
                |> Alert.withChild (UiFramework.uiText "Small alert!")
                |> Alert.view
            ]
        , sizingCode
        ]


sizingCode : UiElement Msg
sizingCode =
    Common.highlightCode "elm"
        """
-- when configuring, we'll build upon `Alert.default`
-- which creates an `Alert` type with default options.
-- To convert the `Alert` type to a `UiElement msg` type, we need to use `Alert.view`.

content : UiElement Msg 
content = 
    UiFramework.uiColumn 
        [ Element.spacing 8
        , Element.width Element.fill ] 
        [ Alert.default 
            |> Alert.withLarge
            |> Alert.withChild (UiFramework.uiText "Large alert!")
            |> Alert.view
        , Alert.simple Primary (UiFramework.uiText "Default alert!")
        , Alert.default 
            |> Alert.withSmall
            |> Alert.withChild (UiFramework.uiText "Small alert!")
            |> Alert.view
        ]
"""


roleConfigs : UiElement Msg
roleConfigs =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "Roles"
        , UiFramework.uiColumn
            [ Element.spacing 8
            , Element.width Element.fill
            ]
          <|
            List.map
                (\( role, name ) ->
                    Alert.default
                        |> Alert.withSmall
                        |> Alert.withRole role
                        |> Alert.withChild (UiFramework.uiText (name ++ " alert, also a small one!"))
                        |> Alert.view
                )
                roleAndNameList
        , roleCode
        ]


roleCode : UiElement Msg
roleCode =
    Common.highlightCode "elm"
        """
content : UiElement Msg 
content = 
    UiFramework.uiColumn 
        [ Element.spacing 8
        , Element.width Element.fill ] 
        [ Alert.default
            |> Alert.withSmall
            |> Alert.withRole Primary
            |> Alert.withChild ( UiFramework.uiText "Primary alert, also a small one")
            |> Alert.view
        , Alert.default
            |> Alert.withSmall
            |> Alert.withRole Secondary
            |> Alert.withChild ( UiFramework.uiText "Secondary alert, also a small one"
            |> Alert.view 
        ...
        ]
"""


childConfigs : UiElement Msg
childConfigs =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "Child elements"
        , UiFramework.uiParagraph []
            [ UiFramework.uiText "Alerts allow any "
            , code "UiElement"
            , UiFramework.uiText " node to be a child"
            ]
        , Alert.simple Success <|
            UiFramework.uiColumn
                [ Element.spacing 8 ]
                [ UiFramework.uiRow
                    [ Element.spacing 8 ]
                    [ Typography.textLead [] (UiFramework.uiText "Yay!")
                    , Badge.simple Success "Certified Bruh Moment"
                    ]
                , UiFramework.uiText "Congratulations! You've made a fancy alert!"
                ]
        , childCode
        ]


childCode : UiElement Msg
childCode =
    Common.highlightCode "elm"
        """
import UiFramework.Alert as Alert
import UiFramework
import Element
import UiFramework.Types exposing (Role(..))
import UiFramework.Badge as Badge


Alert.simple Success <|
    UiFramework.uiColumn
        [ Element.spacing 8 ]
        [ UiFramework.uiRow
            [ Element.spacing 8 ]
            [ Typography.textLead [] (UiFramework.uiText "Yay!")
            , Badge.simple Success "Certified Bruh Moment"
            ]
        , UiFramework.uiText "Congratulations! You have made a fancy alert!"
        ]
"""


attributeConfigs : UiElement Msg
attributeConfigs =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "Adding extra attributes"
        , wrappedText "Using Elm-Ui's styling, we can modify our alerts how we choose."
        , Alert.default
            |> Alert.withChild (UiFramework.uiText "This alert has a thick border")
            |> Alert.withExtraAttrs
                [ Border.width 5 ]
            |> Alert.view
        , attributeCode
        ]


attributeCode : UiElement Msg
attributeCode =
    Common.highlightCode "elm"
        """
import Element.Border as Border


Alert.default
    |> Alert.withChild (UiFramework.uiText "This alert has a thick border")
    |> Alert.withExtraAttrs
        [ Border.width 5 ]
    |> Alert.view
"""



-- UPDATE


type Msg
    = NavigateTo Routes.Route


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NavigateTo route ->
            ( model, Navigation.pushUrl sharedState.navKey (Routes.toUrlString route), NoUpdate )
