module Page.GettingStarted exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Common exposing (code, componentNavbar, highlightCode, section, title, viewHeader, wrappedText)
import Element
import Element.Background as Background
import Element.Font as Font
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, fromElement, toElement)
import UiFramework.Container as Container
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
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.height Element.fill
        , Element.spacing 64
        ]
        [ header
        , content
        ]
        |> UiFramework.toElement (toContext sharedState)


{-| full-width jumbotron serves as a background, while the container within it holds the content.
-}
header : UiElement Msg
header =
    let
        jumbotronContent =
            UiFramework.uiColumn
                [ Element.width Element.fill
                , Element.height Element.fill
                , Element.spacing 16
                , Font.color (Element.rgb 1 1 1)
                ]
                [ Typography.display3 [] <|
                    UiFramework.uiParagraph [] [ UiFramework.uiText "Getting Started" ]
                , UiFramework.uiParagraph []
                    [ Typography.textLead [] <|
                        UiFramework.uiText "An overview of the Elm Ui Bootstrap Framework, how to use it, and some examples."
                    ]
                ]
    in
    UiFramework.withContext
        (\context ->
            Container.jumbotron
                |> Container.withFullWidth
                |> Container.withChild (Container.simple [] jumbotronContent)
                |> Container.withExtraAttrs [ Background.color context.themeConfig.globalConfig.colors.purple ]
                |> Container.view
        )


content : UiElement Msg
content =
    Container.simple [] <|
        UiFramework.uiColumn
            [ Element.width Element.fill
            , Element.spacing 16
            ]
            [ Typography.h1 [] (UiFramework.uiText "Quick Start")
            , Typography.textLead [] (UiFramework.uiText "Not Released Yet!")
            , wrappedText
                """
If you want to try it in your own project, you can checkout the code along side
with your project repo, and include the code in elm.json, as well as other dependencies.
See example from demo app here:
"""
            , setupCode
            , Typography.h1 [] (UiFramework.uiText "Sample Code")
            , UiFramework.uiParagraph []
                [ UiFramework.uiText "See "
                , UiFramework.uiLink
                    { url = "https://joshuaji.com/projects/ui-bootstrap-demo/"
                    , label = "demo app website"
                    }
                , UiFramework.uiText " made by Joshua, source code at Github: "
                , UiFramework.uiLink
                    { url = "https://github.com/joshuanianji/ui-bootstrap-demo"
                    , label = "https://github.com/joshuanianji/ui-bootstrap-demo"
                    }
                ]
            ]


setupCode : UiElement Msg
setupCode =
    Common.highlightCode "json"
        """
{
    "type": "application",
    "source-directories": [
        "src",
        "../elm-ui-bootstrap/src"
    ],
    "elm-version": "0.19.0",
    "dependencies": {
        "direct": {
            "avh4/elm-color": "1.0.0",
            "elm/browser": "1.0.1",
            "elm/core": "1.0.2",
            "elm/html": "1.0.0",
            "elm/json": "1.1.3",
            "elm/parser": "1.1.0",
            "elm/url": "1.0.0",
            "hecrj/composable-form": "8.0.1",
            "lattyware/elm-fontawesome": "3.0.2",
            "mdgriffith/elm-ui": "1.1.3",
            "noahzgordon/elm-color-extra": "1.0.2"
        },
        "indirect": {
            "elm/regex": "1.0.0",
            "elm/svg": "1.0.1",
            "elm/time": "1.0.0",
            "elm/virtual-dom": "1.0.2",
            "elm-community/list-extra": "8.2.2"
        }
    },
    "test-dependencies": {
        "direct": {},
        "indirect": {}
    }
}
"""



-- UPDATE


type Msg
    = NoOp


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )
