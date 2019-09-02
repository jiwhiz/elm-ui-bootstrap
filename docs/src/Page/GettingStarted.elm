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
    UiFramework.flatMap
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
            , setupCode
            , Typography.h1 [] (UiFramework.uiText "Sample Code")
            , UiFramework.uiParagraph []
                [ UiFramework.uiText "See "
                , fromElement
                    (\_ ->
                        Element.link []
                            { url = "https://joshuaji.com/projects/ui-bootstrap-demo/"
                            , label = Element.text "demo website"
                            }
                    )
                , UiFramework.uiText " made by Joshua, source code at Github: "
                , fromElement
                    (\_ ->
                        Element.link []
                            { url = "https://github.com/joshuanianji/ui-bootstrap-demo"
                            , label = Element.text "https://github.com/joshuanianji/ui-bootstrap-demo!"
                            }
                    )
                ]
            ]


setupCode : UiElement Msg
setupCode =
    Common.highlightCode "bash"
        """
TBD
"""



-- UPDATE


type Msg
    = NoOp


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )
