module Page.Typography exposing (Context, Model, Msg(..), init, update, view)

{-| Alert component
-}

import Element exposing (Color, Element, fill, height, spacing, width)
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
            { title = "Typography"
            , description = "Our competitor is r/PenmanshipPorn"
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
                    componentNavbar NavigateTo Routes.Typography
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
        [ headers
        , text
        ]


headers : UiElement Msg
headers =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.title "Headers"
        , Component.section "Displays - or Very Large Headers"
        , UiFramework.uiColumn
            [ spacing 16 ]
            [ Typography.display1 [] (Util.text "Display1")
            , Typography.display2 [] (Util.text "Display2")
            , Typography.display3 [] (Util.text "Display3")
            , Typography.display4 [] (Util.text "Display4")
            ]
        , displayCode
        , Component.section "Headers - the Regular H1's"
        , UiFramework.uiColumn
            [ spacing 16 ]
            [ Typography.h1 [] (Util.text "H1")
            , Typography.h2 [] (Util.text "H2")
            , Typography.h3 [] (Util.text "H3")
            , Typography.h4 [] (Util.text "H4")
            , Typography.h5 [] (Util.text "H4")
            , Typography.h6 [] (Util.text "H4")
            ]
        , headerCode
        ]


displayCode : UiElement Msg
displayCode =
    """
import UiFramework
import UiFramework.Typography as Typography


text : String -> WithContext context msg
text str =
    UiFramework.uiText (\\_ -> str)

displayExamples = 
    UiFramework.uiColumn 
        [ spacing 16 ]
        [ Typography.display1 [] (text "Display1")
        , Typography.display2 [] (text "Display2")
        , Typography.display3 [] (text "Display3")
        , Typography.display4 [] (text "Display4")
        ]"""
        |> Util.uiHighlightCode "elm"


headerCode : UiElement Msg
headerCode =
    """
headerExamples = 
    UiFramework.uiColumn 
        [ spacing 16 ]
        [ Typography.h1 [] (text "H1")
        , Typography.h2 [] (text "H2")
        , Typography.h3 [] (text "H3")
        , Typography.h4 [] (text "H4")
        , Typography.h5 [] (text "H4")
        , Typography.h6 [] (text "H4")
        ]"""
        |> Util.uiHighlightCode "elm"


text : UiElement Msg
text =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.title "Text blocks"
        , UiFramework.uiColumn
            [ spacing 16 ]
            [ Typography.textLead [] (Util.text "Text Lead - Use me below titles!")
            , UiFramework.uiParagraph [] [ Util.text "Regular text!" ]
            , Typography.textSmall [] (Util.text "Small text!")
            , Typography.textExtraSmall [] (Util.text "Super small text!")
            ]
        , textCode
        ]


textCode : UiElement Msg
textCode =
    """
text : String -> WithContext context msg
text str =
    UiFramework.uiText (\\_ -> str)


textExamples =
    UiFramework.uiColumn 
        [ spacing 16 ]
        [ Typography.textLead [] (text "Text Lead - Use me below titles!")
        , UiFramework.uiParagraph [] [text "Regular text!"]
        , Typography.textSmall [] (text "Small text!")
        , Typography.textExtraSmall [] (text "Super small text!")
        ]"""
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
