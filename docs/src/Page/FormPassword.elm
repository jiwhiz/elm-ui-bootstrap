module Page.FormPassword exposing (Model, Msg(..), init, update, view)

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
import UiFramework.Form.PasswordField as PasswordField
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
    { currentPassword : String
    , newPassword : String
    }


init : ( Model, Cmd Msg )
init =
    ( { example = ExampleValues "" "" |> WebForm.idle }, Cmd.none )


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
        { title = "Form Password Input"
        , description = "Current or New Password input"
        , navigateToMsg = NavigateTo
        , currentRoute = Routes.FormPassword
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
We use elm-ui Element.Input.newPassword and Element.Input.currentPassword 
to render the password input.
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
        currentPassword =
            ComposableForm.passwordField
                { parser = Ok
                , value = .currentPassword
                , update = \value values -> { values | currentPassword = value }
                , error = always Nothing
                , attributes =
                    PasswordField.defaultAttributes
                        |> PasswordField.withLabel "Please enter your current password"
                        |> PasswordField.withPlaceholder "Your current password"
                        |> PasswordField.withAutoFillCurrent
                }

        newPassword =
            ComposableForm.passwordField
                { parser = Ok
                , value = .newPassword
                , update = \value values -> { values | newPassword = value }
                , error = always Nothing
                , attributes =
                    PasswordField.defaultAttributes
                        |> PasswordField.withLabel "Please enter your new password"
                        |> PasswordField.withPlaceholder "Your new password"
                }
    in
    WebForm.simpleForm
        ExampleFormChanged
        (ComposableForm.succeed SubmitClicked
            |> ComposableForm.append currentPassword
            |> ComposableForm.append newPassword
        )
        |> WebForm.withHideButton True
        |> WebForm.view state


exampleState state =
    UiFramework.uiParagraph
        [ Element.width Element.fill
        , Element.alignLeft
        ]
        [ UiFramework.uiText "new Password: "
        , bold state.values.newPassword
        ]


exampleCode =
    Common.highlightCode "elm"
        """
type alias Model =
    { example : WebForm.WebFormState ExampleValues }


type alias ExampleValues =
    { name : String
    }


init : ( Model, Cmd Msg )
init =
    ( { example = ExampleValues "" |> WebForm.idle }, Cmd.none )


exampleForm state =
    let
        currentPassword =
            ComposableForm.passwordField
                { parser = Ok
                , value = .currentPassword
                , update = \\value values -> { values | currentPassword = value }
                , error = always Nothing
                , attributes =
                    PasswordField.defaultAttributes
                        |> PasswordField.withLabel "Please enter your current password"
                        |> PasswordField.withPlaceholder "Your current password"
                        |> PasswordField.withAutoFillCurrent
                }

        newPassword =
            ComposableForm.passwordField
                { parser = Ok
                , value = .newPassword
                , update = \\value values -> { values | newPassword = value }
                , error = always Nothing
                , attributes =
                    PasswordField.defaultAttributes
                        |> PasswordField.withLabel "Please enter your new password"
                        |> PasswordField.withPlaceholder "Your new password"
                }
    in
    WebForm.simpleForm
        ExampleFormChanged
        (ComposableForm.succeed SubmitClicked
            |> ComposableForm.append currentPassword
            |> ComposableForm.append newPassword
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
