module Page.FormTextarea exposing (Model, Msg(..), init, update, view)

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
import UiFramework.Form.ComposableForm as ComposableForm
import UiFramework.Form.TextareaField as TextareaField
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
    { text : String
    }


init : ( Model, Cmd Msg )
init =
    ( { example = ExampleValues "" |> WebForm.idle }, Cmd.none )


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
        { title = "Form Textarea Input"
        , description = "Multiline input"
        , navigateToMsg = NavigateTo
        , currentRoute = Routes.FormTextarea
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
We use elm-ui Element.Input.multiline to render the textarea input.
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
        [ Element.spacing 12
        , Element.width Element.fill
        , Element.paddingXY 30 20
        ]
        [ exampleForm model.example
        , exampleState model.example
        ]


exampleForm state =
    let
        text =
            ComposableForm.textareaField
                { parser = Ok
                , value = .text
                , update = \value values -> { values | text = value }
                , error = always Nothing
                , attributes =
                    TextareaField.defaultAttributes
                        |> TextareaField.withLabel "Please enter your intro"
                        |> TextareaField.withPlaceholder "Your intro"
                }
    in
    WebForm.simpleForm
        ExampleFormChanged
        (ComposableForm.succeed SubmitClicked
            |> ComposableForm.append text
        )
        |> WebForm.withHideButton True
        |> WebForm.view state


exampleState state =
    UiFramework.uiParagraph
        [ Element.width Element.fill
        , Element.alignLeft
        ]
        [ UiFramework.uiText "text: "
        , bold state.values.text
        ]


exampleCode =
    Common.highlightCode "elm"
        """
type alias Model =
    { example : WebForm.WebFormState ExampleValues }


type alias ExampleValues =
    { text : String
    }


init : ( Model, Cmd Msg )
init =
    ( { example = ExampleValues "" |> WebForm.idle }, Cmd.none )


exampleForm state =
    let
        text =
            ComposableForm.textareaField
                { parser = Ok
                , value = .text
                , update = \\value values -> { values | text = value }
                , error = always Nothing
                , attributes =
                    TextareaField.defaultAttributes
                        |> TextareaField.withLabel "Please enter your intro"
                        |> TextareaField.withPlaceholder "Your intro"
                }
    in
    WebForm.simpleForm
        ExampleFormChanged
        (ComposableForm.succeed SubmitClicked
            |> ComposableForm.append text
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
    | SubmitClicked String


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )

        NavigateTo route ->
            ( model, Navigation.pushUrl sharedState.navKey (Routes.toUrlString route), NoUpdate )

        ExampleFormChanged state ->
            ( { model | example = state }, Cmd.none, NoUpdate )

        SubmitClicked _ ->
            ( model, Cmd.none, NoUpdate )
