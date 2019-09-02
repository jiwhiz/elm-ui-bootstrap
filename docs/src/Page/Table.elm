module Page.Table exposing (Model, Msg(..), init, update, view)

import Common exposing (code, componentNavbar, section, title, viewHeader, wrappedText)
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
        [ title "Basic Example"
        , wrappedText "The table module does not have a \"Table.default\" function - you must build up from the Table.simpleTable. Nevertheless, here is a basic example with hardcoded data."
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
        [ title "Styles"
        , wrappedText "There are a variety of styling configurations one can choose from when making a table."
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
        [ section "Striped tables"
        , wrappedText "Tables can be striped with little extra code. So far, all tables are striped though lol."
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
        [ section "Bordered and Borderless"
        , wrappedText "Table borders can be configured. Below is a borderless one."
        , Table.simpleTable
            |> Table.withBorderless
            |> Table.withColumns tableColumn
            |> Table.view information
        , borderLessCode
        , wrappedText "And below is one with all borders."
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
        [ section "Compact tables"
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
