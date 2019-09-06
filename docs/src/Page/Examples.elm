module Page.Examples exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Common exposing (code, componentNavbar, highlightCode, section, title, viewHeader, wrappedText)
import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html
import Html.Attributes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, fromElement, toElement)
import UiFramework.ColorUtils exposing (hexToColor)
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
                    UiFramework.uiParagraph [] [ UiFramework.uiText "Examples" ]
                , UiFramework.uiParagraph []
                    [ Typography.textLead [] <|
                        UiFramework.uiText "Some Web sites built with elm-ui-bootstrap."
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
            , Element.spacing 48
            ]
            [ website
                { url = "https://joshuaji.com/projects/ui-bootstrap-demo/"
                , imageSrc = "/images/ui-bootstrap-demo.png"
                , description = "elm-ui-bootstrap demo app"
                }
            , website
                { url = "https://shanjiang.dev/"
                , imageSrc = "/images/shan-jiang.png"
                , description = "Shan Jiang's personal website"
                }
            ]


website : { url : String, imageSrc : String, description : String } -> UiElement Msg
website { url, imageSrc, description } =
    UiFramework.uiColumn
        [ Element.spacing 20
        , Border.widthEach { bottom = 1, left = 0, right = 0, top = 0 }
        , Border.color <| hexToColor "#adb5bd"
        , Element.paddingEach { bottom = 30, left = 0, right = 0, top = 0 }
        ]
        [ Typography.textLead []
            (UiFramework.uiText description)
        , UiFramework.fromElement
            (\context ->
                let
                    linkConfig =
                        context.themeConfig.linkConfig
                in
                Element.newTabLink
                    []
                    { url = url
                    , label =
                        Element.image
                            [ Element.width Element.fill
                            , Element.height Element.fill
                            ]
                            { src = imageSrc
                            , description = description
                            }
                    }
            )
        ]



-- UPDATE


type Msg
    = NoOp


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )
