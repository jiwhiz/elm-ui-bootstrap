module Page.Table exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Common exposing (code, componentNavbar, highlightCode, section, title, viewHeader, wrappedText)
import Element
import Element.Font as Font
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Container as Container
import UiFramework.Table as Table
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
            { title = "Table"
            , description = "Displaying stuff"
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
                    componentNavbar NavigateTo Routes.Table
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
        [ basicExample
        , styles
        ]


basicExample : UiElement Msg
basicExample =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ title "Basic Example"
        , wrappedText
            """
The table module does not have a "Table.default" function - you must build 
up from the Table.simpleTable. Nevertheless, here is a basic example with 
hardcoded data.
"""
        , Table.simpleTable
            |> Table.withColumns tableColumn
            |> Table.view information
        , basicExampleCode
        ]


basicExampleCode : UiElement Msg
basicExampleCode =
    Common.highlightCode "elm"
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
    [ { head =  UiFramework.uiText "Role"
        , viewData = \\data -> UiFramework.uiParagraph [ Font.bold ] [  UiFramework.uiText data.role ]
        }
    , { head =  UiFramework.uiText "Column 1"
        , viewData = \\data -> UiFramework.uiParagraph [] [  UiFramework.uiText data.column1 ]
        }
    , { head =  UiFramework.uiText "Column 2"
        , viewData = \\data -> UiFramework.uiParagraph [] [  UiFramework.uiText data.column2 ]
        }
    , { head =  UiFramework.uiText "Column 3"
        , viewData = \\data -> UiFramework.uiParagraph [] [  UiFramework.uiText data.column3 ]
        }
    ]
"""


styles : UiElement Msg
styles =
    UiFramework.uiColumn
        [ Element.width Element.fill
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
        [ Element.width Element.fill
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
    Common.highlightCode "elm"
        """
simpleTable =
    Table.simpleTable
        |> Table.withStriped
        |> Table.withColumns tableColumn
        |> Table.view information
"""


borderConfig : UiElement Msg
borderConfig =
    UiFramework.uiColumn
        [ Element.width Element.fill
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
    Common.highlightCode "elm"
        """
simpleTable =
    Table.simpleTable
        |> Table.withBorderless
        |> Table.withColumns tableColumn
        |> Table.view information
"""


borderedCode : UiElement Msg
borderedCode =
    Common.highlightCode "elm"
        """
simpleTable =
    Table.simpleTable
        |> Table.withBordered
        |> Table.withColumns tableColumn
        |> Table.view information
"""


compactConfig : UiElement Msg
compactConfig =
    UiFramework.uiColumn
        [ Element.width Element.fill
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
    Common.highlightCode "elm"
        """
simpleTable =
    Table.simpleTable
        |> Table.withCompact
        |> Table.withColumns tableColumn
        |> Table.view information
"""



-- table information


tableColumn =
    [ { head = UiFramework.uiText "Role"
      , viewData = \data -> UiFramework.uiParagraph [ Font.bold ] [ UiFramework.uiText data.role ]
      }
    , { head = UiFramework.uiText "Column 1"
      , viewData = \data -> UiFramework.uiParagraph [] [ UiFramework.uiText data.column1 ]
      }
    , { head = UiFramework.uiText "Column 2"
      , viewData = \data -> UiFramework.uiParagraph [] [ UiFramework.uiText data.column2 ]
      }
    , { head = UiFramework.uiText "Column 3"
      , viewData = \data -> UiFramework.uiParagraph [] [ UiFramework.uiText data.column3 ]
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
    = NavigateTo Routes.Route


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NavigateTo route ->
            ( model, Navigation.pushUrl sharedState.navKey (Routes.toUrlString route), NoUpdate )
