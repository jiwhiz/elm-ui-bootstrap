module Page.Form exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Common exposing (code, componentNavbar, highlightCode, moduleLayout, section, title, viewHeader, wrappedText)
import Element
import Element.Border as Border
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
    { signin : WebForm.WebFormState SignInValues }


type alias SignInValues =
    { username : String
    , password : String
    , rememberMe : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { signin = SignInValues "" "" False |> WebForm.idle }, Cmd.none )


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
        { title = "Forms"
        , description = "They're Difficult. Still under development!"
        , navigateToMsg = NavigateTo
        , currentRoute = Routes.Form
        , content = content model
        }
        |> UiFramework.toElement (toContext sharedState)


content model =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 64
        ]
        [ overview model
        , configuration
        ]


overview model =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ title "Overview"
        , UiFramework.uiParagraph []
            [ UiFramework.uiText "Our form controls are based on fantastic "
            , UiFramework.uiLink
                { url = "https://github.com/hecrj/composable-form"
                , label = "composable-form"
                }
            , UiFramework.uiText ", and we are trying to support most of features of Bootstrap form."
            , UiFramework.uiText " The API might be changed dramatically during development before 1.0 release."
            ]
        , wrappedText "Here is a simple SignIn Form with username, password and remember me checkbox."
        , UiFramework.uiColumn
            [ Element.spacing 0
            , Element.width Element.fill
            , Border.color <| hexToColor "#dee2e6"
            , Border.width 1
            ]
            [ loginForm model
            , loginFormCode
            ]
        ]


loginForm model =
    let
        usernameField =
            ComposableForm.usernameField
                { parser = Ok
                , value = .username
                , update = \value values -> { values | username = value }
                , error = always Nothing
                , attributes =
                    TextField.defaultAttributes
                        |> TextField.withLabel "Username"
                        |> TextField.withPlaceholder "Your username"
                }

        passwordField =
            ComposableForm.passwordField
                { parser = Ok
                , value = .password
                , update = \value values -> { values | password = value }
                , error = always Nothing
                , attributes =
                    PasswordField.defaultAttributes
                        |> PasswordField.withLabel "Password"
                        |> PasswordField.withPlaceholder "Your password"
                }

        rememberMeCheckbox =
            ComposableForm.checkboxField
                { parser = Ok
                , value = .rememberMe
                , update = \value values -> { values | rememberMe = value }
                , error = always Nothing
                , attributes =
                    CheckboxField.defaultAttributes
                        |> CheckboxField.withLabel "Remember me"
                }
    in
    WebForm.simpleForm
        SigninFormChanged
        (ComposableForm.succeed SigninClicked
            |> ComposableForm.append usernameField
            |> ComposableForm.append passwordField
            |> ComposableForm.append rememberMeCheckbox
        )
        |> WebForm.withSubmitButton
            (Button.default
                |> Button.withLabel "Sign in"
                |> Button.withIcon (Icon.fontAwesome FontAwesome.Solid.signInAlt)
            )
        |> WebForm.withLoadingLabel "Loading..."
        |> WebForm.withExtraAttrs [ Element.paddingXY 30 20 ]
        |> WebForm.view model.signin


loginFormCode =
    Common.highlightCode "elm"
        """
import Element
import UiFramework.Form.CheckboxField as CheckboxField
import UiFramework.Form.ComposableForm as ComposableForm
import UiFramework.Form.TextField as TextField
import UiFramework.Form.WebForm as WebForm


type alias Model =
    { signin : WebForm.WebFormState SignInValues }


type alias SignInValues =
    { username : String
    , password : String
    , rememberMe : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { signin = SignInValues "" "" False |> WebForm.idle }, Cmd.none )


type Msg
    = FormChanged (WebForm.WebFormState SignInValues)
    | Login String String Bool


loginForm model =
    let
        usernameField =
            ComposableForm.textField
                { parser = Ok
                , value = .username
                , update = \\value values -> { values | username = value }
                , error = always Nothing
                , attributes =
                    TextField.defaultAttributes
                        |> TextField.withLabel "Username"
                        |> TextField.withPlaceholder "Your username"
                }

        passwordField =
            ComposableForm.passwordField
                { parser = Ok
                , value = .password
                , update = \\value values -> { values | password = value }
                , error = always Nothing
                , attributes =
                    TextField.defaultAttributes
                        |> TextField.withLabel "Password"
                        |> TextField.withPlaceholder "Your password"
                }

        rememberMeCheckbox =
            ComposableForm.checkboxField
                { parser = Ok
                , value = .rememberMe
                , update = \\value values -> { values | rememberMe = value }
                , error = always Nothing
                , attributes =
                    CheckboxField.defaultAttributes
                        |> CheckboxField.withLabel "Remember me"
                }
    in
    WebForm.simpleForm
        SigninFormChanged
        (ComposableForm.succeed SigninClicked
            |> ComposableForm.append usernameField
            |> ComposableForm.append passwordField
            |> ComposableForm.append rememberMeCheckbox
        )
        |> WebForm.withSubmitButton
            (Button.default
                |> Button.withLabel "Sign in"
                |> Button.withIcon (Icon.fontAwesome FontAwesome.Solid.signInAlt)
            )
        |> WebForm.withLoadingLabel "Loading..."
        |> WebForm.withExtraAttrs [ Element.paddingXY 30 20 ]
        |> WebForm.view model.signin

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
    | SigninFormChanged (WebForm.WebFormState SignInValues)
    | SigninClicked String String Bool
    | ResponseSimulated


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )

        NavigateTo route ->
            ( model, Navigation.pushUrl sharedState.navKey (Routes.toUrlString route), NoUpdate )

        SigninFormChanged state ->
            ( { model | signin = state }, Cmd.none, NoUpdate )

        SigninClicked username password rememberMe ->
            let
                signin =
                    model.signin
            in
            ( { model | signin = { signin | status = WebForm.Loading } }
            , Process.sleep 3000 |> Task.perform (always ResponseSimulated)
            , NoUpdate
            )

        ResponseSimulated ->
            let
                signin =
                    model.signin
            in
            ( { model | signin = { signin | status = WebForm.Error "Login failed!" } }, Cmd.none, NoUpdate )
