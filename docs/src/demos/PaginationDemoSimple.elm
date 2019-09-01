module PaginationTestSimple exposing (main)

import Browser
import Browser.Events
import Element exposing (Device)
import FontAwesome.Solid
import FontAwesome.Styles
import Html exposing (Html)
import UiFramework
import UiFramework.Configuration exposing (ThemeConfig, defaultThemeConfig)
import UiFramework.Pagination as Pagination exposing (PaginationState)
import UiFramework.ResponsiveUtils exposing (classifyDevice)


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- keeps track of the state of the navbar in the model


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


{-| toggleMenuState dictates whether the navbar is "collapsed" or not
dropdownState dictates the dropdowns, but for now we don't have any
-}
init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { paginationState =
            { currentSliceNumber = 0 -- starts from 0
            , numberOfSlices = 10
            }
      , device = classifyDevice flags
      , theme = defaultThemeConfig
      }
    , Cmd.none
    )



-- since there are no dropdowns we can just define our type like this


type DropdownState
    = NoDropdown



-- toggle is when the navbar collapses the menu


type Msg
    = PaginationMsg Int
    | WindowSizeChange WindowSize
    | NoOp



-- handle Navbar messages


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PaginationMsg int ->
            ( { model | paginationState = updatePaginationSlice int model.paginationState }
            , Cmd.none
            )

        WindowSizeChange windowSize ->
            ( { model | device = classifyDevice windowSize }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )


updatePaginationSlice : Int -> PaginationState -> PaginationState
updatePaginationSlice newSlice state =
    { state | currentSliceNumber = newSlice }


view : Model -> Html Msg
view model =
    let
        context =
            { device = model.device
            , parentRole = Nothing
            , themeConfig = model.theme
            }

        state =
            model.paginationState

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
        |> UiFramework.toElement context
        |> Element.layout []
        |> (\elem ->
                Html.div []
                    [ FontAwesome.Styles.css -- still need to import fontAwesome styles
                    , elem
                    ]
           )



-- subscribe to window changes


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize
        (\x y ->
            WindowSizeChange (WindowSize x y)
        )
