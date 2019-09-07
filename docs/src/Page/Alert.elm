module Page.Alert exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Common exposing (code, componentNavbar, highlightCode, moduleLayout, roleAndNameList, section, title, viewHeader, wrappedText)
import Element
import Element.Border as Border
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework
import UiFramework.Alert as Alert
import UiFramework.Badge as Badge
import UiFramework.Container as Container
import UiFramework.Types exposing (Role(..))
import UiFramework.Typography as Typography


type alias UiElement msg =
    UiFramework.WithContext {} msg



-- MODEL


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )


toContext : SharedState -> UiFramework.UiContextual {}
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
        , linkExample
        , configuration
        ]


basicExample : UiElement Msg
basicExample =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ title "Basic Example"
        , wrappedText
            """
Alerts are available in 8 different roles, you can use Alert.simple or one of 
eight simple* functions to wrap any UiElement.
"""
        , UiFramework.uiColumn
            [ Element.spacing 8
            , Element.width Element.fill
            ]
            [ Alert.simplePrimary (UiFramework.uiText "Primary role!")
            , Alert.simpleSecondary (UiFramework.uiText "Secondary role!")
            , Alert.simpleSuccess (UiFramework.uiText "Success role!")
            , Alert.simpleInfo (UiFramework.uiText "Info role!")
            , Alert.simpleWarning (UiFramework.uiText "Warning role!")
            , Alert.simpleDanger (UiFramework.uiText "Danger role!")
            , Alert.simpleLight (UiFramework.uiText "Light role!")
            , Alert.simpleDark (UiFramework.uiText "Dark role!")
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


type alias UiElement msg =
    UiFramework.WithContext {} msg


content : UiElement Msg 
content = 
    UiFramework.uiColumn 
        [ Element.spacing 8
        , Element.width Element.fill
        ] 
        [ Alert.simplePrimary (UiFramework.uiText "Primary role!")
        , Alert.simpleSecondary (UiFramework.uiText "Secondary role!")
        , Alert.simpleSuccess (UiFramework.uiText "Success role!")
        , Alert.simpleInfo (UiFramework.uiText "Info role!")
        , Alert.simpleWarning (UiFramework.uiText "Warning role!")
        , Alert.simpleDanger (UiFramework.uiText "Danger role!")
        , Alert.simpleLight (UiFramework.uiText "Light role!")
        , Alert.simpleDark (UiFramework.uiText "Dark role!")
        ]
"""


linkExample : UiElement Msg
linkExample =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ title "Link Example"
        , wrappedText
            """
Inside any alert, you can put link button as Alert.link, or exteranl new tab link
as Alert.externalLink. It will match the color of link to the parent alert.
"""
        , UiFramework.uiColumn
            [ Element.spacing 8
            , Element.width Element.fill
            ]
            [ Alert.simplePrimary <|
                UiFramework.uiParagraph []
                    [ UiFramework.uiText "A simple primary alert with "
                    , Alert.link
                        { onPress = Nothing
                        , label = UiFramework.uiText "an example link"
                        }
                    , UiFramework.uiText ". Give it a click if you like."
                    ]
            , Alert.simpleWarning <|
                UiFramework.uiParagraph []
                    [ UiFramework.uiText "A simple warning alert with "
                    , Alert.externalLink
                        { url = "https://github.com/jiwhiz/elm-ui-bootstrap"
                        , label = UiFramework.uiText "an external link"
                        }
                    , UiFramework.uiText ", which will open our Github repo."
                    ]
            ]
        , linkExampleCode
        ]


linkExampleCode : UiElement Msg
linkExampleCode =
    Common.highlightCode "elm"
        """
UiFramework.uiColumn
    [ Element.spacing 8
    , Element.width Element.fill
    ]
    [ Alert.simplePrimary <|
        UiFramework.uiParagraph []
            [ UiFramework.uiText "A simple primary alert with "
            , ALert.link 
                { onPress = Nothing
                , label = UiFramework.uiText "an example link"}
            , UiFramework.uiText ". Give it a click if you like."
            ]
        
    , Alert.simpleWarning <|
        UiFramework.uiParagraph []
            [ UiFramework.uiText "A simple warning alert with "
            , ALert.externalLink 
                { url = "https://github.com/jiwhiz/elm-ui-bootstrap"
                , label = UiFramework.uiText "an external link"}
            , UiFramework.uiText ", which will open our Github repo."
            ]
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

customAlert =
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
        , Alert.simpleSuccess <|
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
Alert.simpleSuccess <|
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
