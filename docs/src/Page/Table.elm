module Page.Table exposing (Context, Model, Msg(..), init, update, view)

{-| Alert component
-}

import Element exposing (Color, Element, fill, height, spacing, width)
import Element.Font as Font
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Container as Container
import UiFramework.Table as Table
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
            { title = "Table"
            , description = "Displaying stuff"
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
                    componentNavbar NavigateTo Routes.Table
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
        [ basicExample
        , styles
        ]


basicExample : UiElement Msg
basicExample =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.title "Basic Example"
        , Component.wrappedText "The table module does not have a \"Table.default\" function - you must build up from the Table.simpleTable. Nevertheless, here is a basic example with hardcoded data."
        , Table.simpleTable
            |> Table.withColumns tableColumn
            |> Table.view information
        , basicExampleCode
        ]


basicExampleCode : UiElement Msg
basicExampleCode =
    """
import UiFramework.Table as Table


simpleTable =
    Table.simpleTable
        |> Table.withColumns tableColumn
        |> Table.view information


information =
    [ { role = "Row 1"
        , column1 = "column 1"
        , column2 = "column 2"
        , column3 = "column 3"
        }
    , { role = "Row 2"
        , column1 = "column 1"
        , column2 = "column 2"
        , column3 = "column 3"
        }
    , { role = "Row 3"
        , column1 = "column 1"
        , column2 = "column 2"
        , column3 = "column 3"
        }
    , { role = "Row 4"
        , column1 = "column 1"
        , column2 = "column 2"
        , column3 = "column 3"
        }
    ]


tableColumn =
    [ { head = Util.text "Role"
        , viewData = \\data -> UiFramework.uiParagraph [ Font.bold ] [ Util.text data.role ]
        }
    , { head = Util.text "Column 1"
        , viewData = \\data -> UiFramework.uiParagraph [] [ Util.text data.column1 ]
        }
    , { head = Util.text "Column 2"
        , viewData = \\data -> UiFramework.uiParagraph [] [ Util.text data.column2 ]
        }
    , { head = Util.text "Column 3"
        , viewData = \\data -> UiFramework.uiParagraph [] [ Util.text data.column3 ]
        }
    ]"""
        |> Util.uiHighlightCode "elm"


styles : UiElement Msg
styles =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.title "Styles"
        , Component.wrappedText "There are a variety of styling configurations one can choose from when making a table."
        , stripedConfig
        , borderConfig
        , compactConfig
        ]


stripedConfig : UiElement Msg
stripedConfig =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.section "Striped tables"
        , Component.wrappedText "Tables can be striped with little extra code. So far, all tables are striped though lol."
        , Table.simpleTable
            |> Table.withColumns tableColumn
            |> Table.withStriped
            |> Table.view information
        , stripedConfigCode
        ]


stripedConfigCode : UiElement Msg
stripedConfigCode =
    """
simpleTable =
    Table.simpleTable
        |> Table.withStriped
        |> Table.withColumns tableColumn
        |> Table.view information"""
        |> Util.uiHighlightCode "elm"


borderConfig : UiElement Msg
borderConfig =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.section "Bordered and Borderless"
        , Component.wrappedText "Table borders can be configured. Below is a borderless one."
        , Table.simpleTable
            |> Table.withBorderless
            |> Table.withColumns tableColumn
            |> Table.view information
        , borderLessCode
        , Component.wrappedText "And below is one with all borders."
        , Table.simpleTable
            |> Table.withBordered
            |> Table.withColumns tableColumn
            |> Table.view information
        , borderedCode
        ]


borderLessCode : UiElement Msg
borderLessCode =
    """
simpleTable =
    Table.simpleTable
        |> Table.withBorderless
        |> Table.withColumns tableColumn
        |> Table.view information"""
        |> Util.uiHighlightCode "elm"


borderedCode : UiElement Msg
borderedCode =
    """
simpleTable =
    Table.simpleTable
        |> Table.withBordered
        |> Table.withColumns tableColumn
        |> Table.view information"""
        |> Util.uiHighlightCode "elm"


compactConfig : UiElement Msg
compactConfig =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.section "Compact tables"
        , Table.simpleTable
            |> Table.withCompact
            |> Table.withColumns tableColumn
            |> Table.view information
        , compactConfigCode
        ]


compactConfigCode : UiElement Msg
compactConfigCode =
    """
simpleTable =
    Table.simpleTable
        |> Table.withCompact
        |> Table.withColumns tableColumn
        |> Table.view information"""
        |> Util.uiHighlightCode "elm"



-- table information


tableColumn =
    [ { head = Util.text "Role"
      , viewData = \data -> UiFramework.uiParagraph [ Font.bold ] [ Util.text data.role ]
      }
    , { head = Util.text "Column 1"
      , viewData = \data -> UiFramework.uiParagraph [] [ Util.text data.column1 ]
      }
    , { head = Util.text "Column 2"
      , viewData = \data -> UiFramework.uiParagraph [] [ Util.text data.column2 ]
      }
    , { head = Util.text "Column 3"
      , viewData = \data -> UiFramework.uiParagraph [] [ Util.text data.column3 ]
      }
    ]


information =
    [ { role = "Row 1"
      , column1 = "column 1"
      , column2 = "column 2"
      , column3 = "column 3"
      }
    , { role = "Row 2"
      , column1 = "column 1"
      , column2 = "column 2"
      , column3 = "column 3"
      }
    , { role = "Row 3"
      , column1 = "column 1"
      , column2 = "column 2"
      , column3 = "column 3"
      }
    , { role = "Row 4"
      , column1 = "column 1"
      , column2 = "column 2"
      , column3 = "column 3"
      }
    ]



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
