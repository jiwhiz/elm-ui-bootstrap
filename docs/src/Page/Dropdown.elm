module Page.Dropdown exposing (Context, Model, Msg(..), init, update, view)

{-| Dropdown component
-}

import Element exposing (Color, Element, fill, height, spacing, width)
import FontAwesome.Solid
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Container as Container
import UiFramework.Dropdown as Dropdown
import UiFramework.Types exposing (Role(..))
import UiFramework.Typography as Typography
import Util
import View.Component as Component exposing (componentNavbar, viewHeader)



-- UIFRAMEWORK TYPE


type alias UiElement msg =
    WithContext Context msg



-- MODEL


type alias Model =
    { simpleDropdownState : Bool }


init : ( Model, Cmd Msg )
init =
    ( { simpleDropdownState = False }
    , Cmd.none
    )



-- Context


type alias Context =
    { purpleColor : Color
    , simpleDropdownState : Bool
    }


toContext : Model -> SharedState -> UiContextual Context
toContext model sharedState =
    { device = sharedState.device
    , parentRole = Nothing
    , themeConfig = SharedState.getThemeConfig sharedState.theme
    , purpleColor = sharedState.purpleColor
    , simpleDropdownState = model.simpleDropdownState
    }



-- VIEW


view : SharedState -> Model -> Element Msg
view sharedState model =
    UiFramework.uiColumn
        [ width fill, height fill ]
        [ viewHeader
            { title = "Dropdown"
            , description = "Flexible components for almost any navigational sections."
            }
        , Container.simple
            [ Element.paddingXY 0 64 ]
          <|
            UiFramework.uiRow [ width fill ]
                [ Container.simple
                    [ width <| Element.fillPortion 1
                    , height fill
                    ]
                  <|
                    componentNavbar NavigateTo Routes.Dropdown
                , Container.simple [ width <| Element.fillPortion 6 ] <| content
                ]
        ]
        |> UiFramework.toElement (toContext model sharedState)


content : UiElement Msg
content =
    UiFramework.uiColumn
        [ width fill
        , spacing 64
        ]
        [ basicExample
        ]


basicExample : UiElement Msg
basicExample =
    UiFramework.flatMap
        (\context ->
            UiFramework.uiColumn
                [ width fill
                , Element.spacing 32
                ]
                [ Component.title "Basic Example"
                , Component.wrappedText "The implementation of Dropdowns closely align with Navbars and Paginations. Dropdowns need a state to dictate their actions, though here, that state is fully up the the developer to choose. For this simple demo I've made that state a boolean."
                , Dropdown.default ToggleSimpleDropdown True
                    |> Dropdown.withTitle "Static Dropdown"
                    |> Dropdown.withIcon FontAwesome.Solid.appleAlt
                    |> Dropdown.withMenuItems
                        [ Dropdown.menuLinkItem NoOp
                            |> Dropdown.withMenuTitle "Item 1"
                        , Dropdown.menuLinkItem NoOp
                            |> Dropdown.withMenuIcon FontAwesome.Solid.bowlingBall
                            |> Dropdown.withMenuTitle "With Icon"
                        ]
                    |> Dropdown.view context.simpleDropdownState
                , Component.wrappedText "The code below is greatly simplified from the actual implementation of the UiFramework, but serves as a way to showcase how to get the types working."
                , basicExampleCode
                ]
        )


basicExampleCode : UiElement Msg
basicExampleCode =
    """
import Element
import UiFramework
import UiFramework.Button as Button


type alias Model = Bool



init : Model
init = False


type Msg 
    = ToggleSimpleDropdown
    | NoOp


update : Msg -> Model -> Model
update msg model = 
    case msg of 
        ToggleSimpleDropdown ->
            not model
        
        NoOp ->
            model


simpleDropdown model =
    -- Dropdown.default accepts a Msg to trigger when clicked and the "open state" it can compare against
    Dropdown.default ToggleSimpleDropdown True
        |> Dropdown.withTitle "Static Dropdown"
        |> Dropdown.withIcon FontAwesome.Solid.appleAlt
        |> Dropdown.withMenuItems 
            [ Dropdown.menuLinkItem NoOp
                |> Dropdown.withMenuTitle "Item 1"
            , Dropdown.menuLinkItem NoOp
                |> Dropdown.withMenuIcon FontAwesome.Solid.bowlingBall
                |> Dropdown.withMenuTitle "With Icon"
            ]
        -- when model == True, the dropdown will show.
        |> Dropdown.view model"""
        |> Util.uiHighlightCode "elm"



-- UPDATE


type Msg
    = NoOp
    | NavigateTo Routes.Route
    | ToggleSimpleDropdown


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )

        NavigateTo route ->
            ( model, Util.navigate sharedState.navKey route, NoUpdate )

        ToggleSimpleDropdown ->
            ( { model | simpleDropdownState = not model.simpleDropdownState }, Cmd.none, NoUpdate )
