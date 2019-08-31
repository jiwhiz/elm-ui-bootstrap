module Page.NotFound exposing (Model, Msg(..), init, update, view)

import Element exposing (Element)
import Element.Font as Font
import FontAwesome.Solid
import Routes exposing (Route)
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, fromElement, toElement)
import UiFramework.Container as Container
import UiFramework.Icon as Icon
import UiFramework.Types exposing (Role(..))
import UiFramework.Typography as Typography



-- UIFRAMEWORK TYPE


type alias UiElement msg =
    WithContext Context msg



-- MODEL


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- Context


type alias Context =
    {}


toContext : SharedState -> UiContextual Context
toContext sharedState =
    { device = sharedState.device
    , parentRole = Nothing
    , themeConfig = SharedState.getThemeConfig sharedState.theme
    }



-- VIEW


text : String -> UiElement Msg
text str =
    UiFramework.uiText (\_ -> str)


view : SharedState -> Model -> Element Msg
view sharedState model =
    let
        context =
            { device = sharedState.device
            , parentRole = Nothing
            , themeConfig = SharedState.getThemeConfig sharedState.theme
            }
    in
    Container.simple [] sadness
        |> toElement context


sadness : UiElement Msg
sadness =
    UiFramework.uiColumn
        [ Element.centerX
        , Element.spacing 40
        , Element.padding 40
        ]
        [ Typography.display1 [ Element.centerX ] icon
        , Typography.textLead [] (text "We cannot find the page :(")
        ]


icon : UiElement Msg
icon =
    (\context ->
        Element.el
            [ Font.color <| context.themeConfig.themeColor Secondary ]
            (Icon.view FontAwesome.Solid.frown)
    )
        |> fromElement



-- UPDATE


type Msg
    = NoOp


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )
