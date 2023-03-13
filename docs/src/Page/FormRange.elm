module Page.FormRange exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Common exposing (bold, code, componentNavbar, highlightCode, moduleLayout, section, title, viewHeader, wrappedText)
import Element
import Element.Border as Border
import Element.Font as Font
import FontAwesome.Solid
import Process
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import Task exposing (Task)
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Button as Button
import UiFramework.ColorUtils exposing (hexToColor)
import UiFramework.Container as Container
import UiFramework.Form.CheckboxField as CheckboxField
import UiFramework.Form.ComposableForm as ComposableForm
import UiFramework.Form.RangeField as RangeField
import UiFramework.Form.TextField as TextField
import UiFramework.Form.WebForm as WebForm
import UiFramework.Icon as Icon
import UiFramework.Types exposing (Role(..))
import UiFramework.Typography as Typography


type alias UiElement msg =
    WithContext {} msg



-- MODEL


type alias Model =
    { example : WebForm.WebFormState ExampleValues }


type alias ExampleValues =
    { rangeValue : Float
    }


init : ( Model, Cmd Msg )
init =
    ( { example = ExampleValues 5 |> WebForm.idle }, Cmd.none )


toContext : SharedState -> UiContextual {}
toContext sharedState =
    { device = sharedState.device
    , parentRole = Nothing
    , themeConfig = sharedState.themeConfig
    }



-- VIEW


view : SharedState -> Model -> Element.Element Msg
view sharedState model =
    moduleLayout
        { title = "Form Range Input"
        , description = "Customized range input"
        , navigateToMsg = NavigateTo
        , currentRoute = Routes.FormRange
        , content = content model
        }
        |> UiFramework.toElement (toContext sharedState)


content model =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 64
        ]
        [ basicExample model
        ]


basicExample model =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 32
        ]
        [ title "Basic Example"
        , wrappedText
            """
We use elm-ui Element.Input.slider to render the range input.
"""
        , UiFramework.uiColumn
            [ Element.spacing 0
            , Element.width Element.fill
            , Border.color <| hexToColor "#dee2e6"
            , Border.width 1
            ]
            [ exampleDemo model
            , exampleCode
            ]
        ]


exampleDemo model =
    UiFramework.uiColumn
        [ Element.spacing 4
        , Element.width Element.fill
        , Element.paddingXY 30 20
        ]
        [ exampleForm model.example
        , exampleState model.example
        ]


exampleForm state =
    let
        rangeHorizontal =
            ComposableForm.rangeField
                { parser = Ok
                , value = .rangeValue
                , update = \value values -> { values | rangeValue = value }
                , error = always Nothing
                , attributes =
                    RangeField.defaultAttributes
                        |> RangeField.withLabel "Horizontal range"
                        |> RangeField.withMin 0
                        |> RangeField.withMax 10
                        |> RangeField.withStep 1
                }

        rangeVertical =
            ComposableForm.rangeField
                { parser = Ok
                , value = .rangeValue
                , update = \value values -> { values | rangeValue = value }
                , error = always Nothing
                , attributes =
                    RangeField.defaultAttributes
                        |> RangeField.withLabel "Vertical range"
                        |> RangeField.withMin 0
                        |> RangeField.withMax 10
                        |> RangeField.withStep 1
                        |> RangeField.withVertical 200
                }
    in
    WebForm.simpleForm
        ExampleFormChanged
        (ComposableForm.succeed SubmitClicked
            |> ComposableForm.append rangeHorizontal
            |> ComposableForm.append rangeVertical
        )
        |> WebForm.withHideButton True
        |> WebForm.view state


exampleState state =
    UiFramework.uiParagraph
        [ Element.width Element.fill
        , Element.alignLeft
        ]
        [ UiFramework.uiText "Your value: "
        , bold <| String.fromFloat state.values.rangeValue
        ]


exampleCode =
    Common.highlightCode "elm"
        """
type alias Model =
    { example : WebForm.WebFormState ExampleValues }


type alias ExampleValues =
    { rangeValue : Float
    }


init : ( Model, Cmd Msg )
init =
    ( { example = ExampleValues 5 |> WebForm.idle }, Cmd.none )


exampleForm state =
    let
        rangeHorizontal =
            ComposableForm.rangeField
                { parser = Ok
                , value = .rangeValue
                , update = \\value values -> { values | rangeValue = value }
                , error = always Nothing
                , attributes =
                    RangeField.defaultAttributes
                        |> RangeField.withLabel "Horizontal range"
                        |> RangeField.withMin 0
                        |> RangeField.withMax 10
                        |> RangeField.withStep 1
                }

        rangeVertical =
            ComposableForm.rangeField
                { parser = Ok
                , value = .rangeValue
                , update = \\value values -> { values | rangeValue = value }
                , error = always Nothing
                , attributes =
                    RangeField.defaultAttributes
                        |> RangeField.withLabel "Vertical range"
                        |> RangeField.withMin 0
                        |> RangeField.withMax 10
                        |> RangeField.withStep 1
                        |> RangeField.withVertical 200
                }
    in
    WebForm.simpleForm
        ExampleFormChanged
        (ComposableForm.succeed SubmitClicked
            |> ComposableForm.append rangeHorizontal
            |> ComposableForm.append rangeVertical
        )
        |> WebForm.withHideButton True
        |> WebForm.view state

"""


configuration =
    UiFramework.uiColumn
        [ Element.spacing 48
        , Element.width Element.fill
        ]
        [ UiFramework.uiColumn
            [ Element.spacing 16 ]
            [ title "Configurations"
            , UiFramework.uiParagraph []
                [ UiFramework.uiText "Coming soon!" ]
            ]
        ]



-- UPDATE


type Msg
    = NoOp
    | NavigateTo Routes.Route
    | ExampleFormChanged (WebForm.WebFormState ExampleValues)
    | SubmitClicked Float Float


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )

        NavigateTo route ->
            ( model, Navigation.pushUrl sharedState.navKey (Routes.toUrlString route), NoUpdate )

        ExampleFormChanged state ->
            ( { model | example = state }, Cmd.none, NoUpdate )

        SubmitClicked _ _ ->
            ( model, Cmd.none, NoUpdate )
