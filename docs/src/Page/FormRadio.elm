module Page.FormRadio exposing (Model, Msg(..), init, update, view)

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
import UiFramework.Form.RadioField as RadioField
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
    { selected : String
    }


init : ( Model, Cmd Msg )
init =
    ( { example = ExampleValues "A" |> WebForm.idle }, Cmd.none )


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
        { title = "Form Radio Input"
        , description = "Customized radio"
        , navigateToMsg = NavigateTo
        , currentRoute = Routes.FormRadio
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
We use elm-ui Element.Input.radio to render the radio buttons.
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
        radioGroup1 =
            ComposableForm.radioField
                { parser = Ok
                , value = .selected
                , update = \value values -> { values | selected = value }
                , error = always Nothing
                , attributes =
                    RadioField.defaultAttributes
                        |> RadioField.withLabel "You have three options as stack:"
                        |> RadioField.withOptions
                            [ ( "A", "Option A" )
                            , ( "B", "Option B" )
                            , ( "C", "Option C" )
                            ]
                }

        radioGroup2 =
            ComposableForm.radioField
                { parser = Ok
                , value = .selected
                , update = \value values -> { values | selected = value }
                , error = always Nothing
                , attributes =
                    RadioField.defaultAttributes
                        |> RadioField.withLabel "You have three options as inline:"
                        |> RadioField.withOptions
                            [ ( "A", "Option A" )
                            , ( "B", "Option B" )
                            , ( "C", "Option C" )
                            ]
                        |> RadioField.withInline
                }
    in
    WebForm.simpleForm
        ExampleFormChanged
        (ComposableForm.succeed SubmitClicked
            |> ComposableForm.append radioGroup1
            |> ComposableForm.append radioGroup2
        )
        |> WebForm.withHideButton True
        |> WebForm.view state


exampleState state =
    UiFramework.uiParagraph
        [ Element.width Element.fill
        , Element.alignLeft
        ]
        [ UiFramework.uiText "Selected: "
        , bold state.values.selected
        ]


exampleCode =
    Common.highlightCode "elm"
        """
type alias Model =
    { example : WebForm.WebFormState ExampleValues }


type alias ExampleValues =
    { selected : String
    }


init : ( Model, Cmd Msg )
init =
    ( { example = ExampleValues "A" |> WebForm.idle }, Cmd.none )


exampleForm state =
    let
        radioGroup1 =
            ComposableForm.radioField
                { parser = Ok
                , value = .selected
                , update = \\value values -> { values | selected = value }
                , error = always Nothing
                , attributes =
                    RadioField.defaultAttributes
                        |> RadioField.withLabel "You have three options as stack:"
                        |> RadioField.withOptions
                            [ ( "A", "Option A" )
                            , ( "B", "Option B" )
                            , ( "C", "Option C" )
                            ]
                }

        radioGroup2 =
            ComposableForm.radioField
                { parser = Ok
                , value = .selected
                , update = \\value values -> { values | selected = value }
                , error = always Nothing
                , attributes =
                    RadioField.defaultAttributes
                        |> RadioField.withLabel "You have three options as inline:"
                        |> RadioField.withOptions
                            [ ( "A", "Option A" )
                            , ( "B", "Option B" )
                            , ( "C", "Option C" )
                            ]
                        |> RadioField.withInline
                }
    in
    WebForm.simpleForm
        ExampleFormChanged
        (ComposableForm.succeed SubmitClicked
            |> ComposableForm.append radioGroup1
            |> ComposableForm.append radioGroup2
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
    | SubmitClicked String String


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
