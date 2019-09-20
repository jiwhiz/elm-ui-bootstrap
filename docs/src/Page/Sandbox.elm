module Page.Sandbox exposing (Model, Msg(..), init, update, view)

import Element
import Element.Font as Font
import FontAwesome.Brands
import FontAwesome.Regular
import FontAwesome.Solid
import Html.Attributes
import Routes exposing (Route)
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, fromElement, toElement)
import UiFramework.ColorUtils as ColorUtils
import UiFramework.Container as Container
import UiFramework.Icon as Icon
import UiFramework.Types exposing (Role(..))
import UiFramework.Typography as Typography



-- UIFRAMEWORK TYPE


type alias UiElement msg =
    WithContext {} msg



-- MODEL


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )


toContext : SharedState -> UiContextual {}
toContext sharedState =
    { device = sharedState.device
    , parentRole = Nothing
    , themeConfig = sharedState.themeConfig
    }



-- VIEW


view : SharedState -> Model -> Element.Element Msg
view sharedState model =
    Container.simple [] content
        |> toElement (toContext sharedState)


content : UiElement Msg
content =
    UiFramework.uiColumn
        [ Element.centerX
        , Element.spacing 40
        , Element.padding 40
        , Element.width Element.fill
        ]
        [ Typography.h1 [ Element.centerX ] <| UiFramework.uiText "Sandbox"
        , Typography.textLead [ Element.centerX ] <| UiFramework.uiText "Testing out stuff"
        , simpleAttrs
        , textIcon
        , transformations
        , layeringTest
        ]


simpleAttrs : UiElement Msg
simpleAttrs =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 16
        ]
        [ UiFramework.uiParagraph [ Font.center ] [ UiFramework.uiText "Simple Attributes" ]
        , UiFramework.uiRow
            [ Element.centerX
            , Element.spacing 16
            ]
            [ Icon.fontAwesome FontAwesome.Solid.stroopwafel
                |> Icon.withSpin
                |> Icon.withSize (Icon.Num 5)
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.spinner
                |> Icon.withPulse
                |> Icon.withSize (Icon.Num 5)
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.cameraRetro
                |> Icon.withColor "#000099"
                |> Icon.withSize (Icon.Num 5)
                |> Icon.view
            ]
        ]


textIcon : UiElement Msg
textIcon =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 16
        ]
        [ UiFramework.uiParagraph [ Font.center ] [ UiFramework.uiText "Text" ]
        , UiFramework.uiRow
            [ Element.centerX
            , Element.spacing 16
            ]
            [ Icon.textIcon "Text"
                |> Icon.withSpin
                |> Icon.withColor "#000099"
                -- |> Icon.withFlipH
                -- |> Icon.withSize Icon.Lg
                |> Icon.view
            ]
        ]


transformations : UiElement Msg
transformations =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 16
        ]
        [ UiFramework.uiParagraph [ Element.centerX ] [ UiFramework.uiText "Transformations" ]
        , UiFramework.uiRow
            [ Element.centerX
            , Element.spacing 16
            ]
            [ Icon.fontAwesome FontAwesome.Regular.arrowAltCircleUp
                |> Icon.withRotation 135
                |> Icon.withPosDown 15
                |> Icon.withFlipH
                |> Icon.withSize Icon.Lg
                |> Icon.view
            , Icon.fontAwesome FontAwesome.Solid.smile
                |> Icon.withFlipH
                |> Icon.withSize (Icon.Num 3)
                |> Icon.view
            ]
        ]


layeringTest : UiElement Msg
layeringTest =
    let
        calendar =
            Icon.fontAwesome FontAwesome.Solid.calendar
                |> Icon.withSize (Icon.Num 4)

        date =
            Icon.textIcon "27"
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withShrink 8
                |> Icon.withPosDown 3
                |> Icon.withPosRight 4.5
                |> Icon.withHtmlAttributes [ Html.Attributes.style "font-weight" "900" ]
                |> Icon.withColor "#FFF"

        circle =
            Icon.fontAwesome FontAwesome.Solid.circle
                |> Icon.withSize (Icon.Num 4)

        time =
            Icon.fontAwesome FontAwesome.Solid.times
                |> Icon.withSize (Icon.Num 4)
                |> Icon.withInverse
                |> Icon.withShrink 6
    in
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 16
        ]
        [ UiFramework.uiParagraph [ Font.center ] [ UiFramework.uiText "Layering Test" ]
        , UiFramework.uiRow
            [ Element.centerX
            , Element.spacing 16
            ]
            [ calendar
                |> Icon.lay date
                |> Icon.view
            , circle
                |> Icon.lay time
                |> Icon.view
            ]
        ]



-- UPDATE


type Msg
    = NoOp


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )
