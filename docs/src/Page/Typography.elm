module Page.Typography exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Common exposing (code, componentNavbar, highlightCode, section, title, viewHeader, wrappedText)
import Element
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
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
        ]
        [ viewHeader
            { title = "Typography"
            , description = "Our competitor is r/PenmanshipPorn"
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
                    componentNavbar NavigateTo Routes.Typography
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
        [ headers
        , text
        ]


headers : UiElement Msg
headers =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ title "Headers"
        , section "Displays - or Very Large Headers"
        , UiFramework.uiColumn
            [ Element.spacing 16 ]
            [ Typography.display1 [] (UiFramework.uiText "Display1")
            , Typography.display2 [] (UiFramework.uiText "Display2")
            , Typography.display3 [] (UiFramework.uiText "Display3")
            , Typography.display4 [] (UiFramework.uiText "Display4")
            ]
        , displayCode
        , section "Headers - the Regular H1's"
        , UiFramework.uiColumn
            [ Element.spacing 16 ]
            [ Typography.h1 [] (UiFramework.uiText "H1")
            , Typography.h2 [] (UiFramework.uiText "H2")
            , Typography.h3 [] (UiFramework.uiText "H3")
            , Typography.h4 [] (UiFramework.uiText "H4")
            , Typography.h5 [] (UiFramework.uiText "H4")
            , Typography.h6 [] (UiFramework.uiText "H4")
            ]
        , headerCode
        ]


displayCode : UiElement Msg
displayCode =
    Common.highlightCode "elm"
        """
import UiFramework
import UiFramework.Typography as Typography


displayExamples = 
    UiFramework.uiColumn 
        [ spacing 16 ]
        [ Typography.display1 [] ( UiFramework.uiText "Display1")
        , Typography.display2 [] (UiFramework.uiText "Display2")
        , Typography.display3 [] (UiFramework.uiText "Display3")
        , Typography.display4 [] (UiFramework.uiText "Display4")
        ]
"""


headerCode : UiElement Msg
headerCode =
    Common.highlightCode "elm"
        """
headerExamples = 
    UiFramework.uiColumn 
        [ spacing 16 ]
        [ Typography.h1 [] (UiFramework.uiText "H1")
        , Typography.h2 [] (UiFramework.uiText "H2")
        , Typography.h3 [] (UiFramework.uiText "H3")
        , Typography.h4 [] (UiFramework.uiText "H4")
        , Typography.h5 [] (UiFramework.uiText "H4")
        , Typography.h6 [] (UiFramework.uiText "H4")
        ]
"""


text : UiElement Msg
text =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ title "Text blocks"
        , UiFramework.uiColumn
            [ Element.spacing 16 ]
            [ Typography.textLead [] (UiFramework.uiText "Text Lead - Use me below titles!")
            , UiFramework.uiParagraph [] [ UiFramework.uiText "Regular text!" ]
            , Typography.textSmall [] (UiFramework.uiText "Small text!")
            , Typography.textExtraSmall [] (UiFramework.uiText "Super small text!")
            ]
        , textCode
        ]


textCode : UiElement Msg
textCode =
    Common.highlightCode "elm"
        """
textExamples =
    UiFramework.uiColumn 
        [ spacing 16 ]
        [ Typography.textLead [] (UiFramework.uiText "Text Lead - Use me below titles!")
        , UiFramework.uiParagraph [] [UiFramework.uiText "Regular text!"]
        , Typography.textSmall [] (UiFramework.uiText "Small text!")
        , Typography.textExtraSmall [] (UiFramework.uiText "Super small text!")
        ]
"""



-- UPDATE


type Msg
    = NavigateTo Routes.Route


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NavigateTo route ->
            ( model, Navigation.pushUrl sharedState.navKey (Routes.toUrlString route), NoUpdate )
