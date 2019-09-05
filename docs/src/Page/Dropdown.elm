module Page.Dropdown exposing (Context, Model, Msg(..), init, update, view)

import Browser.Events as Events
import Browser.Navigation as Navigation
import Common exposing (code, componentNavbar, highlightCode, moduleLayout, section, title, viewHeader, wrappedText)
import Element
import FontAwesome.Solid
import Json.Decode as Json
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Container as Container
import UiFramework.Dropdown as Dropdown
import UiFramework.Types exposing (Role(..))
import UiFramework.Typography as Typography


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


type alias Context =
    { simpleDropdownState : Bool
    }


toContext : Model -> SharedState -> UiContextual Context
toContext model sharedState =
    { device = sharedState.device
    , parentRole = Nothing
    , themeConfig = sharedState.themeConfig
    , simpleDropdownState = model.simpleDropdownState
    }



-- VIEW


view : SharedState -> Model -> Element.Element Msg
view sharedState model =
    moduleLayout
        { title = "Dropdown"
        , description = "Flexible components for almost any navigational sections."
        , navigateToMsg = NavigateTo
        , currentRoute = Routes.Dropdown
        , content = content
        }
        |> UiFramework.toElement (toContext model sharedState)


content : UiElement Msg
content =
    UiFramework.uiColumn
        [ Element.width Element.fill
        , Element.spacing 64
        ]
        [ basicExample
        ]


basicExample : UiElement Msg
basicExample =
    UiFramework.withContext
        (\context ->
            UiFramework.uiColumn
                [ Element.width Element.fill
                , Element.spacing 32
                ]
                [ title "Basic Example"
                , wrappedText
                    """
The implementation of Dropdowns closely align with Navbars and Paginations. 
Dropdowns need a state to dictate their actions, though here, that state is 
fully up the the developer to choose. For this simple demo I've made that 
state a boolean.
"""
                , Dropdown.default ToggleSimpleDropdown True
                    |> Dropdown.withTitle "Static Dropdown"
                    |> Dropdown.withIcon FontAwesome.Solid.appleAlt
                    |> Dropdown.withMenuItems
                        [ Dropdown.menuLinkItem CloseDropdown
                            |> Dropdown.withMenuTitle "Item 1"
                        , Dropdown.menuLinkItem CloseDropdown
                            |> Dropdown.withMenuIcon FontAwesome.Solid.bowlingBall
                            |> Dropdown.withMenuTitle "With Icon"
                        ]
                    |> Dropdown.view context.simpleDropdownState
                , wrappedText
                    """
The code below is greatly simplified from the actual implementation of
the UiFramework, but serves as a way to showcase how to get the types working.
"""
                , basicExampleCode
                ]
        )


basicExampleCode : UiElement Msg
basicExampleCode =
    Common.highlightCode "elm"
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
        |> Dropdown.view model
"""



-- UPDATE


type Msg
    = NavigateTo Routes.Route
    | ToggleSimpleDropdown
    | CloseDropdown


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NavigateTo route ->
            ( model, Navigation.pushUrl sharedState.navKey (Routes.toUrlString route), NoUpdate )

        ToggleSimpleDropdown ->
            ( { model | simpleDropdownState = not model.simpleDropdownState }, Cmd.none, NoUpdate )

        CloseDropdown ->
            ( { model | simpleDropdownState = False }, Cmd.none, NoUpdate )


{-| TODO : add subscriptions in Router.elm
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    if model.simpleDropdownState == True then
        Events.onClick (Json.succeed CloseDropdown)

    else
        Sub.none
