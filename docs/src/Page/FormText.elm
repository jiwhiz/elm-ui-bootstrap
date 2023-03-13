module Page.FormText exposing (Model, Msg(..), init, update, view)

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
    { text : String
    , username : String
    , email : String
    , search : String
    }


init : ( Model, Cmd Msg )
init =
    ( { example = ExampleValues "" "" "" "" |> WebForm.idle }, Cmd.none )


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
        { title = "Form Text Input"
        , description = "Textual input"
        , navigateToMsg = NavigateTo
        , currentRoute = Routes.FormText
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
We use elm-ui Element.Input.text to render the textual input.
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
        ]


exampleForm state =
    let
        text =
            ComposableForm.textField
                { parser = Ok
                , value = .text
                , update = \value values -> { values | text = value }
                , error = always Nothing
                , attributes =
                    TextField.defaultAttributes
                        |> TextField.withLabel "Please enter any text"
                        |> TextField.withPlaceholder "Any text"
                }

        username =
            ComposableForm.usernameField
                { parser = Ok
                , value = .username
                , update = \value values -> { values | username = value }
                , error = always Nothing
                , attributes =
                    TextField.defaultAttributes
                        |> TextField.withLabel "Please enter your username"
                        |> TextField.withPlaceholder "Your username"
                }

        email =
            ComposableForm.emailField
                { parser = Ok
                , value = .email
                , update = \value values -> { values | email = value }
                , error = always Nothing
                , attributes =
                    TextField.defaultAttributes
                        |> TextField.withLabel "Please enter your email"
                        |> TextField.withPlaceholder "Your email"
                }

        search =
            ComposableForm.searchField
                { parser = Ok
                , value = .search
                , update = \value values -> { values | search = value }
                , error = always Nothing
                , attributes =
                    TextField.defaultAttributes
                        |> TextField.withLabel "Please enter your search string"
                        |> TextField.withPlaceholder "Search string"
                }
    in
    WebForm.simpleForm
        ExampleFormChanged
        (ComposableForm.succeed SubmitClicked
            |> ComposableForm.append text
            |> ComposableForm.append username
            |> ComposableForm.append email
            |> ComposableForm.append search
        )
        |> WebForm.withHideButton True
        |> WebForm.view state


exampleCode =
    Common.highlightCode "elm"
        """
type alias Model =
    { example : WebForm.WebFormState ExampleValues }


type alias ExampleValues =
    { text : String
    , username : String
    , email : String
    , search : String
    }


init : ( Model, Cmd Msg )
init =
    ( { example = ExampleValues "" "" "" "" |> WebForm.idle }, Cmd.none )


exampleForm state =
    let
        text =
            ComposableForm.textField
                { parser = Ok
                , value = .text
                , update = \u{000B}alue values -> { values | text = value }
                , error = always Nothing
                , attributes =
                    TextField.defaultAttributes
                        |> TextField.withLabel "Please enter any text"
                        |> TextField.withPlaceholder "Any text"
                }

        username =
            ComposableForm.usernameField
                { parser = Ok
                , value = .username
                , update = \u{000B}alue values -> { values | username = value }
                , error = always Nothing
                , attributes =
                    TextField.defaultAttributes
                        |> TextField.withLabel "Please enter your username"
                        |> TextField.withPlaceholder "Your username"
                }

        email =
            ComposableForm.emailField
                { parser = Ok
                , value = .email
                , update = \u{000B}alue values -> { values | email = value }
                , error = always Nothing
                , attributes =
                    TextField.defaultAttributes
                        |> TextField.withLabel "Please enter your email"
                        |> TextField.withPlaceholder "Your email"
                }

        search =
            ComposableForm.searchField
                { parser = Ok
                , value = .search
                , update = \u{000B}alue values -> { values | search = value }
                , error = always Nothing
                , attributes =
                    TextField.defaultAttributes
                        |> TextField.withLabel "Please enter your search string"
                        |> TextField.withPlaceholder "Search string"
                }
    in
    WebForm.simpleForm
        ExampleFormChanged
        (ComposableForm.succeed SubmitClicked
            |> ComposableForm.append text
            |> ComposableForm.append username
            |> ComposableForm.append email
            |> ComposableForm.append search
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
    | SubmitClicked String String String String


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )

        NavigateTo route ->
            ( model, Navigation.pushUrl sharedState.navKey (Routes.toUrlString route), NoUpdate )

        ExampleFormChanged state ->
            ( { model | example = state }, Cmd.none, NoUpdate )

        SubmitClicked _ _ _ _ ->
            ( model, Cmd.none, NoUpdate )
