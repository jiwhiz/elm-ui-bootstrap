module Page.Badge exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Common exposing (code, componentNavbar, highlightCode, roleAndNameList, section, title, viewHeader, wrappedText)
import Element
import Element.Border as Border
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Badge as Badge
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
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.height Element.fill
        ]
        [ viewHeader
            { title = "Badge"
            , description = "Nerfed alerts"
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
                    componentNavbar NavigateTo Routes.Badge
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
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ title "Basic Example"
        , wrappedText "A basic badge consists of a role and a string"
        , UiFramework.uiWrappedRow
            [ Element.spacing 8
            , Element.width Element.fill
            ]
          <|
            List.map
                (\( role, name ) ->
                    Badge.simple role name
                )
                roleAndNameList
        , basicExampleCode
        ]


basicExampleCode : UiElement Msg
basicExampleCode =
    Common.highlightCode "elm"
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
                [ UiFramework.uiText "When configuring, we use pipelines to build up our badge, starting from the default function, "
                , code "Badge.default"
                ]
            ]
        , configExampleCode
        , attributeConfigs
        , rolesAndLabelConfig
        , pillConfig
        ]


configExampleCode : UiElement Msg
configExampleCode =
    Common.highlightCode "elm"
        """
-- an example showing all the configurations availablt at the moment


customBadge =
    Badge.default
        |> Badge.withRole Primary
        |> Badge.label "Custom Badge"
        |> Badge.withPill
        |> Badge.withExtraAttrs []
        |> Badge.view
"""


attributeConfigs : UiElement Msg
attributeConfigs =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "Adding extra attributes"
        , wrappedText "Using Elm-Ui, we can modify our badges."
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
    Common.highlightCode "elm"
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
        |> Badge.view
"""


rolesAndLabelConfig : UiElement Msg
rolesAndLabelConfig =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "Roles and Labels"
        , UiFramework.uiParagraph []
            [ UiFramework.uiText "These pipeline functions bring the basic functionality to badge customization. By default, the role of a badge is the "
            , code "Primary"
            , UiFramework.uiText " role, and the label is an empty string."
            ]
        , Badge.simple Secondary "Secondary badge!"
        , rolesAndLabelsConfigCode
        ]


rolesAndLabelsConfigCode : UiElement Msg
rolesAndLabelsConfigCode =
    Common.highlightCode "elm"
        """
simpleButton =
    Badge.simple Secondary "Secondary badge!"


-- is equivalent to --


simpleButton =
    Badge.default 
        |> Badge.withRole Secondary 
        |> Badge.withLabel "Secondary Badge!"
        |> Badge.view
"""


pillConfig : UiElement Msg
pillConfig =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ section "Pills or no pill"
        , UiFramework.uiParagraph []
            [ UiFramework.uiText "A badge can have a "
            , code "pill"
            , UiFramework.uiText " config set to "
            , code "True"
            , UiFramework.uiText ", where the corners are more rounded. By default this is set to "
            , code "False"
            , UiFramework.uiText "."
            ]
        , Badge.default
            |> Badge.withLabel "Pill Badge"
            |> Badge.withPill
            |> Badge.view
        , pillConfigCode
        ]


pillConfigCode : UiElement Msg
pillConfigCode =
    Common.highlightCode "elm"
        """
pillBadge =
    Badge.default
        |> Badge.withLabel "Pill Badge"
        |> Badge.withPill
        |> Badge.view
"""



-- UPDATE


type Msg
    = NavigateTo Routes.Route


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NavigateTo route ->
            ( model, Navigation.pushUrl sharedState.navKey (Routes.toUrlString route), NoUpdate )
