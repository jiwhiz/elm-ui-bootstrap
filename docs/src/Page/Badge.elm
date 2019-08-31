module Page.Badge exposing (Context, Model, Msg(..), init, update, view)

{-| Alert component
-}

import Element exposing (Color, Element, fill, height, spacing, width)
import Element.Border as Border
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Badge as Badge
import UiFramework.Container as Container
import UiFramework.Types exposing (Role(..))
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
            { title = "Badge"
            , description = "Nerfed alerts"
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
                    componentNavbar NavigateTo Routes.Badge
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
        , configuration
        ]


basicExample : UiElement Msg
basicExample =
    UiFramework.uiColumn
        [ spacing 16
        , width fill
        ]
        [ Component.title "Basic Example"
        , Component.wrappedText "A basic badge consists of a role and a string"
        , UiFramework.uiWrappedRow
            [ Element.spacing 8
            , Element.width Element.fill
            ]
          <|
            List.map
                (\( role, name ) ->
                    Badge.simple role name
                )
                rolesAndNames
        , basicExampleCode
        ]


basicExampleCode : UiElement Msg
basicExampleCode =
    """
import UiFramework
import UiFramework.Badge as Badge
import UiFramework.Types exposing (Role(..))


UiFramework.uiColumn
    [ Element.spacing 8
    , Element.width Element.fill
    ]
    [ Badge.simple Primary "Primary badge!"
    , Badge.simple Secondary "Secondary badge!"
    , Badge.simple Success "Success badge!"
    , Badge.simple Info "Info badge!"
    , Badge.simple Warning "Warning badge!"
    , Badge.simple Danger "Danger badge!"
    , Badge.simple Light "Light badge!"
    , Badge.simple Dark "Dark badge!"
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
                [ Util.text "When configuring, we use pipelines to build up our badge, starting from the default function, "
                , Component.code "Badge.default"
                ]

            ]
        , configExampleCode
        , attributeConfigs
        , rolesAndLabelConfig
        , pillConfig
        ]


configExampleCode : UiElement Msg
configExampleCode =
    """
-- an example showing all the configurations availablt at the moment


customBadge =
    Badge.default
        |> Badge.withRole Primary
        |> Badge.label "Custom Badge"
        |> Badge.withPill
        |> Badge.withExtraAttrs []
        |> Badge.view"""
        |> Util.uiHighlightCode "elm"


attributeConfigs : UiElement Msg
attributeConfigs =
    UiFramework.uiColumn
        [ spacing 16
        , width fill
        ]
        [ Component.section "Adding extra attributes"
        , Component.wrappedText "Using Elm-Ui, we can modify our badges."
        , Badge.default
            |> Badge.withLabel "border"
            |> Badge.withExtraAttrs
                [ Border.width 5
                , Border.color <| Element.rgb 0 0 0
                ]
            |> Badge.view
        , attributeConfigCode
        ]


attributeConfigCode : UiElement Msg
attributeConfigCode =
    """
import Element.Border as Border

text : String -> WithContext context msg
text str =
    UiFramework.uiText (\\_ -> str)

bigBorderBadge =
    Badge.default
        |> Badge.withLabel "border"
        |> Badge.withExtraAttrs
            [ Border.width 5
            , Border.color <| Element.rgb 0 0 0
            ]
        |> Badge.view"""
        |> Util.uiHighlightCode "elm"


rolesAndLabelConfig : UiElement Msg
rolesAndLabelConfig =
    UiFramework.uiColumn
        [ spacing 16
        , width fill
        ]
        [ Component.section "Roles and Labels"
        , UiFramework.uiParagraph []
            [ Util.text "These pipeline functions bring the basic functionality to badge customization. By default, the role of a badge is the "
            , Component.code "Primary" 
            , Util.text " role, and the label is an empty string."
            ]
        , Badge.simple Secondary "Secondary badge!"
        , rolesAndLabelsConfigCode
        ]


rolesAndLabelsConfigCode : UiElement Msg
rolesAndLabelsConfigCode =
    """
simpleButton =
    Badge.simple Secondary "Secondary badge!"


-- is equivalent to --


simpleButton =
    Badge.default 
        |> Badge.withRole Secondary 
        |> Badge.withLabel "Secondary Badge!"
        |> Badge.view"""
        |> Util.uiHighlightCode "elm"


pillConfig : UiElement Msg
pillConfig =
    UiFramework.uiColumn
        [ spacing 16
        , width fill
        ]
        [ Component.section "Pills or no pill"
        , UiFramework.uiParagraph [] 
            [ Util.text "A badge can have a "
           , Component.code "pill"
            , Util.text " config set to "
            , Component.code "True"
            , Util.text ", where the corners are more rounded. By default this is set to "
            , Component.code "False"
            , Util.text "."]
        , Badge.default
            |> Badge.withLabel "Pill Badge"
            |> Badge.withPill
            |> Badge.view
        , pillConfigCode
        ]


pillConfigCode : UiElement Msg
pillConfigCode =
    """
pillBadge =
    Badge.default
        |> Badge.withLabel "Pill Badge"
        |> Badge.withPill
        |> Badge.view"""
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
