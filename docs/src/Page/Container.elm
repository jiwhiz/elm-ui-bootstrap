module Page.Container exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Common exposing (code, componentNavbar, highlightCode, section, title, viewHeader, wrappedText)
import Element
import Element.Background as Background
import Element.Border as Border
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
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
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.height Element.fill
        ]
        [ viewHeader
            { title = "Container"
            , description = "Basic layout elements that contain 1 child"
            }
        , Container.simple
            [ Element.paddingXY 0 64 ]
          <|
            UiFramework.uiRow [ Element.width Element.fill ]
                [ Container.simple
                    [ Element.width <| Element.fillPortion 1
                    , Element.height Element.fill
                    ]
                  <|
                    componentNavbar NavigateTo Routes.Container
                , Container.simple [ Element.width <| Element.fillPortion 6 ] <| content
                ]
        ]
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
        , wrappedText "Default containers are responsive, with fixed max-widths that change at each breakpoint. Imo, containers are dwarved by the uiColumn and uiRow elements, and are not really used anywhere other than being a top-level parent element that dictates the width of the content."
        , UiFramework.flatMap
            (\context ->
                Container.simple
                    [ Background.color context.themeConfig.globalConfig.colors.purple
                    , Element.height (Element.px 20)
                    ]
                    UiFramework.uiNone
            )
        , basicExampleCode
        ]


basicExampleCode : UiElement Msg
basicExampleCode =
    Common.highlightCode "elm"
        """
import Element
import UiFramework
import UiFramework.Container as Container


content =
    Container.simple [] 
        // child element here
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
            , wrappedText
                """
Custom containers are often built using pipelines starting from the default container function.
"""
            ]
        , configExampleCode
        , fullWidthConfig
        , childConfig
        , jumbotronConfig
        , attributeConfigs
        ]


configExampleCode : UiElement Msg
configExampleCode =
    Common.highlightCode "elm"
        """

-- an example showing all the configurations available at the moment


customContainer =
    Container.default
        |> Container.withFullWidth
        |> Container.jumbotron
        |> Container.withExtraAttrs []
        |> Container.withChild UiFramework.uiNone
        |> Container.view
"""


childConfig : UiElement Msg
childConfig =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ section "Children"
        , wrappedText
            """
Containers can only hold 1 child element, since uiRow and uiColumn are used to hold multiple children.
"""
        , Container.default
            |> Container.withChild (UiFramework.uiText "Hello")
            |> Container.view
        , childConfigCode
        ]


childConfigCode : UiElement Msg
childConfigCode =
    Common.highlightCode "elm"
        """
simpleContainer =
    Container.default 
            |> Container.withChild ( UiFramework.uiText "Hello! World")
            |> Container.view
"""


fullWidthConfig : UiElement Msg
fullWidthConfig =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "Using fullWidth"
        , wrappedText
            """
This function is similar to Bootstrap's .container-fluid class, where instead of
a max-width property that changes based on the screen width, it always fills
the width of the parent element.
"""
        , Container.default
            |> Container.withFullWidth
            |> Container.withExtraAttrs
                [ Border.width 1
                , Border.color <| Element.rgb 0 0 0
                , Element.height (Element.px 40)
                ]
            |> Container.view
        , fullWidthConfigCode
        ]


fullWidthConfigCode : UiElement Msg
fullWidthConfigCode =
    Common.highlightCode "elm"
        """
bigBorderContainer =
    Container.default
        |> Container.withFullWidth
        |> Container.view
"""


jumbotronConfig : UiElement Msg
jumbotronConfig =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "Jumbotron"
        , wrappedText "Jumbotrons highlight content by changing a background. That's really all it does."
        , Container.jumbotron
            |> Container.withFullWidth
            |> Container.withChild
                (UiFramework.uiColumn []
                    [ Typography.display4 [] (UiFramework.uiText "Jumbotron")
                    , Typography.textLead [] (UiFramework.uiText "grab attention with these backgrounds.")
                    ]
                )
            |> Container.view
        , jumbotronConfigCode
        ]


jumbotronConfigCode : UiElement Msg
jumbotronConfigCode =
    Common.highlightCode "elm"
        """
import UiFramework.Typography as Typography


getViewerAttention =
    Container.jumbotron
        |> Container.withFullWidth
        |> Container.withChild 
            (UiFramework.uiColumn []
                [ Typography.display4 [] (UiFramework.uiText "Jumbotron")
                , Typography.textLead [] (UiFramework.uiText "Grab attention with these backgrounds.")
                ]
            )
        |> Container.view
"""


attributeConfigs : UiElement Msg
attributeConfigs =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "Adding extra attributes"
        , wrappedText "Using Elm-Ui, we can modify our containers."
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
    Common.highlightCode "elm"
        """
import Element.Border as Border


bigBorderContainer =
    Container.default
        |> Container.withExtraAttrs
            [ Border.width 5
            , Border.color <| Element.rgb 0 0 0
            , Element.height (Element.px 40)
            ]
        |> Container.view
"""



-- UPDATE


type Msg
    = NavigateTo Routes.Route


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NavigateTo route ->
            ( model, Navigation.pushUrl sharedState.navKey (Routes.toUrlString route), NoUpdate )
