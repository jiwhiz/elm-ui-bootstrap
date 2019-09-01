module Main exposing (main)

import Browser
import Browser.Events
import Browser.Navigation as Nav
import Router exposing (viewApplication)
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework.ResponsiveUtils exposing (classifyDevice)
import Url



-- PROGRAM --


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }



-- MODEL --


type alias Model =
    { sharedState : SharedState
    , routerModel : Router.Model
    }


type alias Flags =
    WindowSize


type alias WindowSize =
    { width : Int
    , height : Int
    }


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( initRouterModel, routerCmd ) =
            Router.init url key
    in
    ( { sharedState = SharedState.init (classifyDevice flags) key
      , routerModel = initRouterModel
      }
    , Cmd.map RouterMsg routerCmd
    )



-- VIEW --


view : Model -> Browser.Document Msg
view model =
    viewApplication RouterMsg model.routerModel model.sharedState



-- UPDATE --


type Msg
    = WindowSizeChange WindowSize
    | RouterMsg Router.Msg
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- Browser.application needs these two update functions
        UrlChanged url ->
            -- handling url changes
            updateRouter model (Router.UrlChanged url)

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.sharedState.navKey (Url.toString url) )

                Browser.External url ->
                    ( model, Nav.load url )

        WindowSizeChange windowSize ->
            updateSharedState model <|
                SharedState.UpdateDevice (classifyDevice windowSize)

        RouterMsg routerMsg ->
            updateRouter model routerMsg


updateRouter : Model -> Router.Msg -> ( Model, Cmd Msg )
updateRouter model routerMsg =
    let
        ( nextRouterModel, routerCmd, sharedStateUpdate ) =
            Router.update model.sharedState routerMsg model.routerModel

        nextSharedState =
            SharedState.update model.sharedState sharedStateUpdate
    in
    ( { model | sharedState = nextSharedState, routerModel = nextRouterModel }
    , Cmd.map RouterMsg routerCmd
    )


updateSharedState : Model -> SharedStateUpdate -> ( Model, Cmd Msg )
updateSharedState model ssupdate =
    ( { model | sharedState = SharedState.update model.sharedState ssupdate }
    , Cmd.none
    )



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize
        (\x y ->
            WindowSizeChange (WindowSize x y)
        )
