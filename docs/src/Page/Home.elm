module Page.Home exposing (Model, Msg(..), init, update, view)

import Element exposing (Color, Element)
import Element.Background as Background
import Element.Font as Font
import Routes exposing (Route(..))
import SharedState exposing (SharedState, SharedStateUpdate)
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Button as Button
import UiFramework.Container as Container
import UiFramework.Typography as Typography
import Util
import View.Component as Component



-- UIFRAMEWORK TYPE


type alias UiElement msg =
    WithContext Context msg



-- MODEL


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}
    , Cmd.none
    )



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


text : String -> UiElement Msg
text str =
    UiFramework.uiText (\_ -> str)


view : SharedState -> Model -> Element Msg
view sharedState model =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.height Element.fill
        ]
        [ header
        , description
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
                [ title
                , lead
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


title : UiElement Msg
title =
    Typography.display2 [ Element.paddingXY 0 30, Element.centerX ] <|
        UiFramework.uiParagraph [] [ text "Elm-Ui Bootstrap" ]


lead : UiElement Msg
lead =
    UiFramework.uiParagraph [ Font.center ]
        [ Typography.textLead [] <|
            text "Rewriting the Bootstrap framework using Elm-ui."
        ]


description : UiElement Msg
description =
    Container.simple [] <|
        UiFramework.uiColumn
            [ Element.width Element.fill
            , Element.height Element.fill
            , Element.paddingXY 0 96
            , Element.spacing 16
            ]
            [ Typography.h1
                [ Element.width Element.fill, Font.center ]
                (Component.wrappedText "Responsive, Scalable, and Composable Projects on the Web")
            , Typography.textLead
                [ Element.width Element.fill, Font.center ]
                (Component.wrappedText "Elm Ui Bootstrap is better than Elm Bootstrap lol")
            , UiFramework.uiRow
                [ Element.width Element.fill
                , Element.paddingXY 0 64
                , Element.spacing 64
                ]
                [ UiFramework.uiColumn
                    [ Element.width Element.fill
                    , Element.spacing 16
                    , Element.alignTop
                    ]
                    [ Typography.h4
                        []
                        (text "Getting Started")
                    , Component.wrappedText "Get to know the basics of the Context architecture, and how to use it to greatly simplify your code. Download the starter application (which is not yet finished) and start fiddling around with the code with elm-live."
                    , getStartedButton
                    ]
                , UiFramework.uiColumn
                    [ Element.width Element.fill
                    , Element.spacing 16
                    , Element.alignTop
                    ]
                    [ Typography.h4
                        []
                        (text "Documentation")
                    , Component.wrappedText "Learn the components of the UiFramework, and understand the modularity and type safe API through clear explanations and code examples. "
                    , learnMoreButton
                    ]
                ]
            ]


getStartedButton : UiElement Msg
getStartedButton =
    Button.default
        |> Button.withMessage (Just <| NavigateTo GettingStarted)
        |> Button.withLabel "Get Started"
        |> Button.withOutlined
        |> Button.withLarge
        |> Button.view


learnMoreButton : UiElement Msg
learnMoreButton =
    Button.default
        |> Button.withMessage (Just <| NavigateTo Button)
        |> Button.withLabel "Learn more"
        |> Button.withOutlined
        |> Button.withLarge
        |> Button.view



-- UPDATE


type Msg
    = NoOp
    | NavigateTo Route


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NavigateTo route ->
            ( model, Util.navigate sharedState.navKey route, SharedState.NoUpdate )

        NoOp ->
            ( model, Cmd.none, SharedState.NoUpdate )
