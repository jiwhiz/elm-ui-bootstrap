module Page.GettingStarted exposing (Model, Msg(..), init, update, view)

import Element exposing (Color, Element, fill, height, spacing, width)
import Element.Background as Background
import Element.Font as Font
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, fromElement, toElement)
import UiFramework.Container as Container
import UiFramework.Types exposing (Role(..))
import UiFramework.Typography as Typography
import Util



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
        [ width fill
        , height fill
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
                [ width fill
                , height fill
                , spacing 16
                , Font.color (Element.rgb 1 1 1)
                ]
                [ Typography.display3 [] <|
                    UiFramework.uiParagraph [] [ Util.text "Getting Started" ]
                , UiFramework.uiParagraph []
                    [ Typography.textLead [] <|
                        Util.text "An overview of the Elm Ui Bootstrap Framework, how to use it, and some examples."
                    ]
                ]
    in
    UiFramework.flatMap
        (\context ->
            Container.jumbotron
                |> Container.withFullWidth
                |> Container.withChild (Container.simple [] jumbotronContent)
                |> Container.withExtraAttrs [ Background.color context.purpleColor ]
                |> Container.view
        )


content : UiElement Msg
content =
    Container.simple [] <|
        UiFramework.uiColumn
            [ width fill
            , spacing 16
            ]
            [ Typography.h1 [] (Util.text "Quick Start")
            , setupCode
            , Typography.h1 [] (Util.text "Module Code")
            , UiFramework.uiParagraph []
                [ Util.text "Elm Ui Bootstrap requires a the full model-view-update architecture to work, because of the context architecture. Below is the not updated boilerplate code to start off a simple project."
                ]
            , moduleCode
            ]


setupCode : UiElement Msg
setupCode =
    """
mkdir elm-ui-bootstrap
cd elm-ui-bootstrap
elm install something/ui-bootstrap-quickstart"""
        |> Util.uiHighlightCode "bash"


moduleCode : UiElement Msg
moduleCode =
    """
module Main exposing (main)

import Html exposing (..)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid


main =
    Grid.container []
        [ CDN.stylesheet -- creates an inline style node with the Bootstrap CSS
        , Grid.row []
            [ Grid.col []
                [ text "Some content for my view here..."]
            ]

        ]"""
        |> Util.uiHighlightCode "elm"



-- UPDATE


type Msg
    = NoOp


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )
