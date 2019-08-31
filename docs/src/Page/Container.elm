module Page.Container exposing (Context, Model, Msg(..), init, update, view)

{-| Alert component
-}

import Element exposing (Color, Element, fill, height, spacing, width)
import Element.Background as Background
import Element.Border as Border
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
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
            { title = "Container"
            , description = "Basic layout elements that contain 1 child"
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
                    componentNavbar NavigateTo Routes.Container
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
        [ width fill
        , Element.spacing 32
        ]
        [ Component.title "Basic Example"
        , Component.wrappedText "Default containers are responsive, with fixed max-widths that change at each breakpoint. Imo, containers are dwarved by the uiColumn and uiRow elements, and are not really used anywhere other than being a top-level parent element that dictates the width of the content."
        , UiFramework.flatMap
            (\context ->
                Container.simple
                    [ Background.color context.purpleColor
                    , Element.height (Element.px 20)
                    ]
                    UiFramework.uiNone
            )
        , basicExampleCode
        ]


basicExampleCode : UiElement Msg
basicExampleCode =
    """
import Element
import UiFramework
import UiFramework.Container as Container


content =
    Container.simple [] 
        // child element here"""
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
            , Component.wrappedText "Custom containers are often built using pipelines starting from the default container function."
            ]
        , configExampleCode
        , fullWidthConfig
        , childConfig
        , jumbotronConfig
        , attributeConfigs
        ]


configExampleCode : UiElement Msg
configExampleCode =
    """

-- an example showing all the configurations available at the moment



customButton =
    Container.default
        |> Container.withFullWidth
        |> Container.jumbotron
        |> Container.withExtraAttrs []
        |> Container.withChild UiFramework.uiNone
        |> Container.view"""
        |> Util.uiHighlightCode "elm"


childConfig : UiElement Msg
childConfig =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.section "Children"
        , Component.wrappedText "Containers can only hold 1 child element, since uiRow and uiColumn are used to hold multiple children."
        , Container.default
            |> Container.withChild (Util.text "Hello")
            |> Container.view
        , childConfigCode
        ]


childConfigCode : UiElement Msg
childConfigCode =
    """
simpleContainer =
    Container.default 
            |> Container.withChild (Util.text "Hello! World")
            |> Container.view"""
        |> Util.uiHighlightCode "elm"


fullWidthConfig : UiElement Msg
fullWidthConfig =
    UiFramework.uiColumn
        [ spacing 16
        , width fill
        ]
        [ Component.section "Using fullWidth"
        , Component.wrappedText "This function is similar to Bootstrap's .container-fluid class, where instead of  a max-width property that changes based on the screen width, it always fills the width of the parent element."
        , Container.default
            |> Container.withFullWidth
            |> Container.withExtraAttrs
                [ Border.width 5
                , Border.color <| Element.rgb 0 0 0
                , Element.height (Element.px 40)
                ]
            |> Container.view
        , fullWidthConfigCode
        ]


fullWidthConfigCode : UiElement Msg
fullWidthConfigCode =
    """
import Element.Border as Border


bigBorderContainer =
    Container.default
        |> Container.withFullWidth
        |> Container.view"""
        |> Util.uiHighlightCode "elm"


jumbotronConfig : UiElement Msg
jumbotronConfig =
    UiFramework.uiColumn
        [ spacing 16
        , width fill
        ]
        [ Component.section "Jumbotron"
        , Component.wrappedText "Jumbotrons highlight content by changing a background. That's really all it does."
        , Container.jumbotron
            |> Container.withFullWidth
            |> Container.withChild
                (UiFramework.uiColumn []
                    [ Typography.display4 [] (Util.text "Jumbotron")
                    , Typography.textLead [] (Util.text "grab attention with these backgrounds.")
                    ]
                )
            |> Container.view
        , jumbotronConfigCode
        ]


jumbotronConfigCode : UiElement Msg
jumbotronConfigCode =
    """
import UiFramework.Typography as Typography


text : String -> WithContext context msg
text str =
    UiFramework.uiText (\\_ -> str)



getViewerAttention =
    Container.jumbotron
        |> Container.withFullWidth
        |> Container.withChild 
            (UiFramework.uiColumn []
                [ Typography.display4 [] (text "Jumbotron")
                , Typography.textLead [] (text "Grab attention with these backgrounds.")
                ]
            )
        |> Container.view"""
        |> Util.uiHighlightCode "elm"


attributeConfigs : UiElement Msg
attributeConfigs =
    UiFramework.uiColumn
        [ spacing 16
        , width fill
        ]
        [ Component.section "Adding extra attributes"
        , Component.wrappedText "Using Elm-Ui, we can modify our containers."
        , Container.default
            |> Container.withExtraAttrs
                [ Border.width 5
                , Border.color <| Element.rgb 0 0 0
                , Element.height (Element.px 40)
                ]
            |> Container.view
        , attributeConfigCode
        ]


attributeConfigCode : UiElement Msg
attributeConfigCode =
    """
import Element.Border as Border


bigBorderContainer =
    Container.default
        |> Container.withExtraAttrs
            [ Border.width 5
            , Border.color <| Element.rgb 0 0 0
            , Element.height (Element.px 40)
            ]
        |> Container.view"""
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
