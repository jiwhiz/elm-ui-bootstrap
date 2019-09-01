module Page.Alert exposing (Context, Model, Msg(..), init, update, view)

{-| Alert component
-}

import Element exposing (Color, Element, fill, height, spacing, width)
import Element.Border as Border
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Alert as Alert
import UiFramework.Badge as Badge
import UiFramework.Container as Container
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
            { title = "Alert"
            , description = "Fancy info"
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
                    componentNavbar NavigateTo Routes.Alert
                , Container.simple [ width <| Element.fillPortion 6 ] <| content
                ]
        ]
        |> UiFramework.toElement (toContext sharedState)


content : UiElement Msg
content =
    UiFramework.uiColumn
        [ width fill
        , spacing 64
        ]
        [ basicExample
        , configuration
        ]


basicExample : UiElement Msg
basicExample =
    UiFramework.uiColumn
        [ spacing 16
        , width fill
        ]
        [ Component.title "Basic Example"
        , Component.wrappedText "Alerts are available in 8 different roles and are available for any length of text"
        , UiFramework.uiColumn
            [ Element.spacing 8
            , Element.width Element.fill
            ]
            [ Alert.simple Primary (Util.text "Primary role!")
            , Alert.simple Secondary (Util.text "Secondary role!")
            , Alert.simple Success (Util.text "Success role!")
            , Alert.simple Info (Util.text "Info role!")
            , Alert.simple Warning (Util.text "Warning role!")
            , Alert.simple Danger (Util.text "Danger role!")
            , Alert.simple Light (Util.text "Light role!")
            , Alert.simple Dark (Util.text "Dark role!")
            ]
        , basicExampleCode
        ]


basicExampleCode : UiElement Msg
basicExampleCode =
    """
import Element
import UiFramework
import UiFramework.Alert as Alert
import UiFramework.Types exposing (Role(..))

text : String -> WithContext context msg
text str =
    UiFramework.uiText (\\_ -> str)

UiFramework.uiColumn 
    [ Element.spacing 8
    , Element.width Element.fill
    ] 
    [ Alert.simple Primary (text "Primary role!")
    , Alert.simple Secondary (text "Secondary role!")
    , Alert.simple Success (text "Success role!")
    , Alert.simple Info (text "Info role!")
    , Alert.simple Warning (text "Warning role!")
    , Alert.simple Danger (text "Danger role!")
    , Alert.simple Light (text "Light role!")
    , Alert.simple Dark (text "Dark role!")
    ]"""
        |> Util.uiHighlightCode "elm"


configuration : UiElement Msg
configuration =
    UiFramework.uiColumn
        [ spacing 48
        , width fill
        ]
        [ UiFramework.uiColumn
            [ spacing 16 ]
            [ Component.title "Configurations"
            , UiFramework.uiParagraph []
                [Util.text "When configuring, we use pipelines to build up our badge, starting from the default function, "
                , Component.code "Alert.default"
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
    """
-- an example showing all the configurations available at the moment

text : String -> WithContext context msg
text str =
    UiFramework.uiText (\\_ -> str)


customBadge =
    Alert.default
        |> Alert.withSmall -- or withLarge
        |> Alert.withRole Secondary
        |> Alert.withExtraAttrs []
        |> Alert.withChild (text "Hello!")
        |> Alert.view"""
        |> Util.uiHighlightCode "elm"


sizeConfigs : UiElement Msg
sizeConfigs =
    UiFramework.uiColumn
        [ spacing 16
        , width fill
        ]
        [ Component.section "Sizing"
        , Component.wrappedText "There are three sizes available to alerts."
        , UiFramework.uiColumn
            [ Element.spacing 8
            , width fill
            ]
            [ Alert.default
                |> Alert.withLarge
                |> Alert.withChild (Util.text "Large alert!")
                |> Alert.view
            , Alert.simple Primary (Util.text "Default alert!")
            , Alert.default
                |> Alert.withSmall
                |> Alert.withChild (Util.text "Small alert!")
                |> Alert.view
            ]
        , sizingCode
        ]


sizingCode : UiElement Msg
sizingCode =
    """
text : String -> WithContext context msg
text str =
    UiFramework.uiText (\\_ -> str)


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
            |> Alert.withChild (text "Large alert!")
            |> Alert.view
        , Alert.simple Primary (text "Default alert!")
        , Alert.default 
            |> Alert.withSmall
            |> Alert.withChild (text "Small alert!")
            |> Alert.view
        ]"""
        |> Util.uiHighlightCode "elm"


roleConfigs : UiElement Msg
roleConfigs =
    UiFramework.uiColumn
        [ spacing 16
        , width fill
        ]
        [ Component.section "Roles"
        , UiFramework.uiColumn
            [ Element.spacing 8
            , width fill
            ]
          <|
            List.map
                (\( role, name ) ->
                    Alert.default
                        |> Alert.withSmall
                        |> Alert.withRole role
                        |> Alert.withChild (Util.text (name ++ " alert, also a small one!"))
                        |> Alert.view
                )
                rolesAndNames
        , roleCode
        ]


roleCode : UiElement Msg
roleCode =
    """
text : String -> WithContext context msg
text str =
    UiFramework.uiText (\\_ -> str)


content : UiElement Msg 
content = 
    UiFramework.uiColumn 
        [ Element.spacing 8
        , Element.width Element.fill ] 
        [ Alert.default
            |> Alert.withSmall
            |> Alert.withRole Primary
            |> Alert.withChild (Util.text "Primary alert, also a small one")
            |> Alert.view
        , Alert.default
            |> Alert.withSmall
            |> Alert.withRole Secondary
            |> Alert.withChild (Util.text "Secondary alert, also a small one"
            |> Alert.view 
        ...
        ]"""
        |> Util.uiHighlightCode "elm"


childConfigs : UiElement Msg
childConfigs =
    UiFramework.uiColumn
        [ spacing 16
        , width fill
        ]
        [ Component.section "Child elements"
        , UiFramework.uiParagraph []
            [ Util.text "Alerts allow any "
            , Component.code "UiElement"
            , Util.text " node to be a child"
            ]
        , Alert.simple Success <|
            UiFramework.uiColumn
                [ Element.spacing 8 ]
                [ UiFramework.uiRow
                    [ Element.spacing 8 ]
                    [ Typography.textLead [] (Util.text "Yay!")
                    , Badge.simple Success "Certified Bruh Moment"
                    ]
                , Util.text "Congratulations! You've made a fancy alert!"
                ]
        , childCode
        ]


childCode : UiElement Msg
childCode =
    """
import UiFramework.Alert as Alert
import UiFramework
import Element
import UiFramework.Types exposing (Role(..))
import UiFramework.Badge as Badge

text : String -> WithContext context msg
text str =
    UiFramework.uiText (\\_ -> str)


Alert.simple Success <|
    UiFramework.uiColumn
        [ Element.spacing 8 ]
        [ UiFramework.uiRow
            [ Element.spacing 8 ]
            [ Typography.textLead [] (text "Yay!")
            , Badge.simple Success "Certified Bruh Moment"
            ]
        , text "Congratulations!"
        ]"""
        |> Util.uiHighlightCode "elm"


attributeConfigs : UiElement Msg
attributeConfigs =
    UiFramework.uiColumn
        [ spacing 16
        , width fill
        ]
        [ Component.section "Adding extra attributes"
        , Component.wrappedText "Using Elm-Ui's styling, we can modify our alerts how we choose."
        , Alert.default
            |> Alert.withChild (Util.text "This alert has a thicc border")
            |> Alert.withExtraAttrs
                [ Border.width 5 ]
            |> Alert.view
        , attributeCode
        ]


attributeCode : UiElement Msg
attributeCode =
    """
import Element.Border as Border


text : String -> WithContext context msg
text str =
    UiFramework.uiText (\\_ -> str)


Alert.default
    |> Alert.withChild (text "This alert has a thicc border")
    |> Alert.withExtraAttrs
        [ Border.width 5 ]
    |> Alert.view"""
        |> Util.uiHighlightCode "elm"


rolesAndNames : List ( Role, String )
rolesAndNames =
    [ ( Primary, "Primary" )
    , ( Secondary, "Secondary" )
    , ( Success, "Success" )
    , ( Info, "Info" )
    , ( Warning, "Warning" )
    , ( Danger, "Danger" )
    , ( Light, "Light" )
    , ( Dark, "Dark" )
    ]



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
