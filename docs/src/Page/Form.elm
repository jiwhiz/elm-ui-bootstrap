module Page.Form exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Navigation
import Common exposing (code, componentNavbar, highlightCode, moduleLayout, section, title, viewHeader, wrappedText)
import Element
import Element.Border as Border
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.ColorUtils exposing (hexToColor)
import UiFramework.Container as Container
import UiFramework.Form.CheckboxField as CheckboxField
import UiFramework.Form.ComposableForm as ComposableForm
import UiFramework.Form.TextField as TextField
import UiFramework.Form.WebForm as WebForm
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


content : Model -> UiElement Msg
content model =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 64
        ]
        [ overview
        , basicExample model
        , configuration
        ]


overview : UiElement Msg
overview =
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
            , UiFramework.uiText " The API might be changed during development before 1.0 release."
            ]
        ]


basicExample : Model -> UiElement Msg
basicExample model =
    UiFramework.uiColumn
        [ Element.spacing 16
        , Element.width Element.fill
        ]
        [ title "Basic Example"
        , wrappedText "Simple SignIn Form with username, password and remember me checkbox."
        , UiFramework.uiColumn
            [ Element.spacing 0
            , Element.width Element.fill
            , Border.color <| hexToColor "#dee2e6"
            , Border.width 1
            ]
            [ loginForm model
            , basicExampleCode
            ]
        ]


loginForm : Model -> UiElement Msg
loginForm model =
    let
        usernameField =
            ComposableForm.textField
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
            ComposableForm.textField
                { parser = Ok
                , value = .password
                , update = \value values -> { values | password = value }
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
                , update = \value values -> { values | rememberMe = value }
                , error = always Nothing
                , attributes =
                    CheckboxField.defaultAttributes
                        |> CheckboxField.withLabel "Remember me"
                }
    in
    WebForm.simpleForm
        FormChanged
        (ComposableForm.succeed Login
            |> ComposableForm.append usernameField
            |> ComposableForm.append passwordField
            |> ComposableForm.append rememberMeCheckbox
        )
        |> WebForm.withSubmitLabel "Sign in"
        |> WebForm.withLoadingLabel "Loading..."
        |> WebForm.withExtraAttrs [ Element.paddingXY 30 20 ]
        |> WebForm.view model.signin


basicExampleCode : UiElement Msg
basicExampleCode =
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


loginForm : Model -> UiElement Msg
loginForm model =
    let
        usernameField =
            ComposableForm.textField
                { parser = Ok
                , value = .username
                , update = \u{000B}alue values -> { values | username = value }
                , error = always Nothing
                , attributes =
                    TextField.defaultAttributes
                        |> TextField.withLabel "Username"
                        |> TextField.withPlaceholder "Your username"
                }

        passwordField =
            ComposableForm.textField
                { parser = Ok
                , value = .password
                , update = \u{000B}alue values -> { values | password = value }
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
                , update = \u{000B}alue values -> { values | rememberMe = value }
                , error = always Nothing
                , attributes =
                    CheckboxField.defaultAttributes
                        |> CheckboxField.withLabel "Remember me"
                }
    in
    WebForm.simpleForm
        FormChanged
        (ComposableForm.succeed Login
            |> ComposableForm.append usernameField
            |> ComposableForm.append passwordField
            |> ComposableForm.append rememberMeCheckbox
        )
        |> WebForm.withSubmitLabel "Sign in"
        |> WebForm.withLoadingLabel "Loading..."
        |> WebForm.withExtraAttrs [ Element.paddingXY 30 20 ]
        |> WebForm.view model.signin

"""


configuration : UiElement Msg
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
    | FormChanged (WebForm.WebFormState SignInValues)
    | Login String String Bool


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )

        NavigateTo route ->
            ( model, Navigation.pushUrl sharedState.navKey (Routes.toUrlString route), NoUpdate )

        FormChanged values ->
            ( model, Cmd.none, NoUpdate )

        Login username password rememberMe ->
            ( model, Cmd.none, NoUpdate )
