module Page.Home exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Common exposing (code, componentNavbar, highlightCode, section, title, viewHeader, wrappedText)
import Element
import Element.Background as Background
import Element.Font as Font
import Routes exposing (Route(..))
import SharedState exposing (SharedState, SharedStateUpdate)
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Button as Button
import UiFramework.Container as Container
import UiFramework.Typography as Typography



-- UIFRAMEWORK TYPE


type alias UiElement msg =
    WithContext {} msg



-- MODEL


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}
    , Cmd.none
    )


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
                |> Container.withExtraAttrs [ Background.color context.themeConfig.globalConfig.colors.purple ]
                |> Container.view
        )


title : UiElement Msg
title =
    Typography.display2 [ Element.paddingXY 0 30, Element.centerX ] <|
        UiFramework.uiParagraph [] [ UiFramework.uiText "Elm-Ui Bootstrap" ]


lead : UiElement Msg
lead =
    UiFramework.uiParagraph [ Font.center ]
        [ Typography.textLead [] <|
            UiFramework.uiText "Rewriting the Bootstrap framework using Elm-ui."
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
                (wrappedText "Responsive, Scalable, and Composable Projects on the Web")
            , Typography.textLead
                [ Element.width Element.fill, Font.center ]
                (wrappedText "Elm Ui Bootstrap is better than Elm Bootstrap lol")
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
                        (UiFramework.uiText "Getting Started")
                    , wrappedText "Get to know the basics of the Context architecture, and how to use it to greatly simplify your code. Download the starter application (which is not yet finished) and start fiddling around with the code with elm-live."
                    , getStartedButton
                    ]
                , UiFramework.uiColumn
                    [ Element.width Element.fill
                    , Element.spacing 16
                    , Element.alignTop
                    ]
                    [ Typography.h4
                        []
                        (UiFramework.uiText "Documentation")
                    , wrappedText "Learn the components of the UiFramework, and understand the modularity and type safe API through clear explanations and code examples. "
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
    = NavigateTo Route


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NavigateTo route ->
            ( model, Navigation.pushUrl sharedState.navKey (Routes.toUrlString route), SharedState.NoUpdate )
