module Page.Pagination exposing (Context, Model, Msg(..), init, update, view)

{-| Alert component
-}

import Element exposing (Color, Element, fill, height, spacing, width)
import Element.Font as Font
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Container as Container
import UiFramework.Pagination as Pagination exposing (PaginationState)
import UiFramework.Types exposing (Role(..))
import UiFramework.Typography as Typography
import Util
import View.Component as Component exposing (componentNavbar, viewHeader)



-- UIFRAMEWORK TYPE


type alias UiElement msg =
    WithContext Context msg



-- MODEL


type alias Model =
    { paginationState : PaginationState }


init : ( Model, Cmd Msg )
init =
    ( { paginationState =
            { currentSliceNumber = 0 -- starts from 0
            , numberOfSlices = 10
            }
      }
    , Cmd.none
    )



-- Context


type alias Context =
    { purpleColor : Color
    , paginationState : PaginationState
    }


toContext : Model -> SharedState -> UiContextual Context
toContext model sharedState =
    { device = sharedState.device
    , parentRole = Nothing
    , themeConfig = SharedState.getThemeConfig sharedState.theme
    , purpleColor = sharedState.purpleColor
    , paginationState = model.paginationState
    }



-- VIEW


view : SharedState -> Model -> Element Msg
view sharedState model =
    UiFramework.uiColumn
        [ width fill, height fill ]
        [ viewHeader
            { title = "Pagination"
            , description = "False routing"
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
                    componentNavbar NavigateTo Routes.Pagination
                , Container.simple [ width <| Element.fillPortion 6 ] <| content
                ]
        ]
        |> UiFramework.toElement (toContext model sharedState)


content : UiElement Msg
content =
    UiFramework.uiColumn
        [ width fill
        , spacing 64
        ]
        [ basicExample
        , responsiveExample
        ]


basicExample : UiElement Msg
basicExample =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.title "Basic Example"
        , Component.wrappedText "Paginations need states and boilerplate code to handle its responsive behaviour, but for now, let's make a simple static pagination. A basic example of that would look like this."
        , Component.wrappedText "Note that you still need to import the FontAwesome stylesheet into your code, as the buttons rely on their icons."
        , Pagination.default (\_ -> NoOp)
            |> Pagination.withItems
                [ Pagination.NumberItem 0
                , Pagination.NumberItem 1
                , Pagination.EllipsisItem
                , Pagination.NumberItem 8
                , Pagination.NumberItem 9
                ]
            |> Pagination.withExtraAttrs [ Element.centerX ]
            |> Pagination.view
                { currentSliceNumber = 0 -- starts from 0
                , numberOfSlices = 10
                }
        , basicExampleCode
        ]


basicExampleCode : UiElement Msg
basicExampleCode =
    """
import Element
import UiFramework.Pagination as Pagination


type Msg 
    = NoOp


staticPagination = 
    Pagination.default (\\_ -> NoOp) -- needs an (Int -> msg) type
        |> Pagination.withItems 
            [ Pagination.NumberItem 0 -- hard coded the items
            , Pagination.NumberItem 1
            , Pagination.EllipsisItem
            , Pagination.NumberItem 8
            , Pagination.NumberItem 9 
            ]
        |> Pagination.withExtraAttrs [ Element.centerX ]
        |> Pagination.view 
            { currentSliceNumber = 0 -- starts from 0
            , numberOfSlices = 10
            }"""
        |> Util.uiHighlightCode "elm"


responsiveExample : UiElement Msg
responsiveExample =
    UiFramework.flatMap
        (\context ->
            UiFramework.uiColumn
                [ width fill
                , Element.spacing 32
                ]
                [ Component.title "Responsive Example"
                , Component.wrappedText "A responsive pagination only needs the pagination state to calculate everything. Below is an example of one."
                , let
                    state =
                        context.paginationState

                    ( startNumber, endNumber ) =
                        if state.numberOfSlices <= 5 then
                            ( 0, state.numberOfSlices - 1 )

                        else
                            ( max 0 (state.currentSliceNumber - 2)
                            , min (state.numberOfSlices - 1) (state.currentSliceNumber + 2)
                            )

                    itemList =
                        (if startNumber > 0 then
                            [ Pagination.EllipsisItem ]

                         else
                            []
                        )
                            ++ List.map (\index -> Pagination.NumberItem index) (List.range startNumber endNumber)
                            ++ (if endNumber < (state.numberOfSlices - 1) then
                                    [ Pagination.EllipsisItem ]

                                else
                                    []
                               )
                  in
                  Pagination.default PaginationMsg
                    |> Pagination.withItems itemList
                    |> Pagination.withExtraAttrs [ Element.centerX ]
                    |> Pagination.view state
                    |> (\paginationElement ->
                            UiFramework.uiColumn
                                [ Element.width Element.fill
                                , Element.spacing 20
                                ]
                                [ UiFramework.uiParagraph
                                    [ Font.center ]
                                    [ Util.text "Currently on slice #"
                                    , Util.text <| String.fromInt (state.currentSliceNumber + 1)
                                    ]
                                , paginationElement
                                ]
                       )
                , Component.wrappedText "Paginations need the full model-view-update architecture to function, so here's a complete code set to deal with a simple responsive pagination."
                , responsiveExampleCode
                , Component.wrappedText "Because of the flags, you'll also need to configure an index.html file. Below is the setup you can use yourself."
                , basicHtmlCode
                ]
        )


responsiveExampleCode : UiElement Msg
responsiveExampleCode =
    """
import Browser
import Browser.Events
import Element exposing (Device)
import Html exposing (Html)
import FontAwesome.Styles
import UiFramework
import UiFramework.Configuration exposing (ThemeConfig, defaultThemeConfig)
import UiFramework.ResponsiveUtils exposing (classifyDevice)
import UiFramework.Pagination as Pagination exposing (PaginationState)


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


-- keeps track of the state of the pagination in the model


type alias Model =
    { paginationState : PaginationState
    , device : Device
    , theme : ThemeConfig
    }

type alias Flags =
    WindowSize


type alias WindowSize =
    { width : Int
    , height : Int
    }


init : Flags -> (Model, Cmd Msg)
init flags =
    ( { paginationState = 
        { currentSliceNumber = 0 -- starts from 0
        , numberOfSlices = 10 -- the amount of slices we want
        }
      , device = classifyDevice flags
      , theme = defaultThemeConfig
      }
    , Cmd.none)


type Msg 
    = PaginationMsg Int
    | WindowSizeChange WindowSize
    | NoOp


-- handle messages


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of 
        PaginationMsg int ->
            ( { model | paginationState = updatePaginationSlice int model.paginationState }
            , Cmd.none
            )

        WindowSizeChange windowSize ->
            ( { model | device = classifyDevice windowSize}
            , Cmd.none 
            )
        
        NoOp ->
            ( model, Cmd.none )



updatePaginationSlice : Int -> PaginationState -> PaginationState
updatePaginationSlice newSlice state = 
    { state | currentSliceNumber = newSlice }



text : String -> WithContext Context Msg
text str = 
    UiFramework.uiText (\\_ -> str)


view : Model -> Html Msg 
view model =
    let
        context =
            { device = model.device
            , parentRole = Nothing
            , themeConfig = model.theme
            }
        
        state = model.paginationState

        -- this section handles the logic - how to split up the pagination blocks
        ( startNumber, endNumber ) =
            if state.numberOfSlices <= 5 then
                ( 0, state.numberOfSlices - 1 )

            else
                ( max 0 (state.currentSliceNumber - 2)
                , min (state.numberOfSlices - 1) (state.currentSliceNumber + 2)
                )

        itemList =
            (if startNumber > 0 then
                [ Pagination.EllipsisItem ]

            else
                []
            )
                ++ List.map (\\index -> Pagination.NumberItem index) (List.range startNumber endNumber)
                ++ (if endNumber < (state.numberOfSlices - 1) then
                        [ Pagination.EllipsisItem ]

                    else
                        []
                )
                    
    in
    Pagination.default PaginationMsg
        |> Pagination.withItems itemList
        |> Pagination.withExtraAttrs [ Element.centerX ]
        |> Pagination.view state
        |> (\\paginationElement ->
            UiFramework.uiColumn
                [ Element.width Element.fill
                , Element.spacing 20
                ]
                [ UiFramework.uiParagraph
                    [ Font.center ]
                    [ text "Currently on slice #"
                    , text <| String.fromInt (state.currentSliceNumber + 1)
                    ]
                , paginationElement
                ]
            )
        |> UiFramework.toElement context
        |> Element.layout []
        |> (\\elem ->
            Html.div []
                [ FontAwesome.Styles.css -- still need to import fontAwesome styles
                , elem 
                ]
            )



-- subscribe to window changes


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize
        (\\x y ->
            WindowSizeChange (WindowSize x y)
        )"""
        |> Util.uiHighlightCode "elm"


basicHtmlCode : UiElement Msg
basicHtmlCode =
    """
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Basic Ui Bootstrap Example</title>
    <meta name="description" content="A Small Demo Application using Elm-Ui-Bootstrap">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body>
    <div id="elm"></div>
    <script src="elm.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
    <script>
        var app = Elm.Main.init({
            node: document.getElementById('elm'),
            flags: {
                height: window.innerHeight,
                width: window.innerWidth
            }
        })
    </script>
</body>

</html>"""
        |> Util.uiHighlightCode "html"



-- UPDATE


type Msg
    = NoOp
    | NavigateTo Routes.Route
    | PaginationMsg Int


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )

        NavigateTo route ->
            ( model, Util.navigate sharedState.navKey route, NoUpdate )

        PaginationMsg int ->
            ( { model | paginationState = updatePaginationSlice int model.paginationState }
            , Cmd.none
            , NoUpdate
            )


updatePaginationSlice : Int -> PaginationState -> PaginationState
updatePaginationSlice newSlice state =
    { state | currentSliceNumber = newSlice }
