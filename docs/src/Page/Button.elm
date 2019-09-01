module Page.Button exposing (Context, Model, Msg(..), init, update, view)

{-| Button component
-}

import Element exposing (Color, Element, fill, height, spacing, width)
import FontAwesome.Brands
import Routes
import SharedState exposing (SharedState, SharedStateUpdate(..))
import UiFramework exposing (UiContextual, WithContext, toElement)
import UiFramework.Button as Button
import UiFramework.Container as Container
import UiFramework.Types exposing (Role(..))
import Util
import View.Component as Component exposing (componentNavbar, viewHeader)



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
    { purpleColor : Color }


toContext : SharedState -> UiContextual Context
toContext sharedState =
    { device = sharedState.device
    , parentRole = Nothing
    , themeConfig = SharedState.getThemeConfig sharedState.theme
    , purpleColor = sharedState.purpleColor
    }



-- VIEW


view : SharedState -> Model -> Element Msg
view sharedState model =
    UiFramework.uiColumn
        [ width fill, height fill ]
        [ viewHeader
            { title = "Buttons"
            , description = "Click Click Click Click Click Click Click Click Click Click"
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
                    componentNavbar NavigateTo Routes.Button
                , Container.simple [ width <| Element.fillPortion 6 ] content
                ]
        ]
        |> UiFramework.toElement (toContext sharedState)


content : UiElement Msg
content =
    UiFramework.uiColumn
        [ width fill
        , spacing 64
        ]
        [ basicExample
        , configuration
        ]



{--
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 64
        ]
        [ basicButtons
        , buttonRoles
        , buttonRolesCode
        , Typography.h1 [] (Util.text "Module Code")
        , moduleCode
        ]
--}


basicExample : UiElement Msg
basicExample =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.title "Basic Example"
        , Component.wrappedText "Default buttons take in a message to trigger when clicked, and a string for the label. Icons are optional, and can be added through configuration."
        , UiFramework.uiWrappedRow
            [ Element.spacing 4 ]
            [ Button.simple NoOp "Do Something" ]
        , basicExampleCode
        ]


basicExampleCode : UiElement Msg
basicExampleCode =
    """
import Element
import UiFramework
import UiFramework.Button as Button

type Msg 
    = DoSomething

importantButton =
    Button.simple DoSomething "Do something\""""
        |> Util.uiHighlightCode "elm"


configuration : UiElement Msg
configuration =
    UiFramework.uiColumn
        [ spacing 48
        , width fill
        ]
        [ UiFramework.uiColumn
            [ spacing 16 ]
            [ Component.title "Configurations"
            , UiFramework.uiParagraph [] 
                [Util.text "When configuring, we use pipelines to build up our button, starting from the default function, "
                , Component.code "Button.default"
                ]
            ]
        , configExampleCode
        , roleConfig
        , basicFunctionalityConfig
        , outlineConfig
        , sizeConfig
        , blockConfig
        , disableConfig
        , iconConfig
        ]


configExampleCode : UiElement Msg
configExampleCode =
    """
import FontAwesome.Solid
import UiFramework.Types exposing (Role(..))


-- using Lattyware's FontAwesome module 
-- (https://package.elm-lang.org/packages/lattyware/elm-fontawesome/3.1.0/)



type Msg 
    = DoSomething


-- an example showing all the configurations available at the moment



customButton =
    Button.default
        |> Button.withRole Info
        |> Button.withOutlined
        |> Button.withBlock
        |> Button.withDisabled
        |> Button.withLarge -- or withSmall
        |> Button.withMessage (Just DoSomething)
        |> Button.withIcon FontAwesome.Solid.angleDoubleRight
        |> Button.withLabel "Button with Icon"
        |> Button.view"""
        |> Util.uiHighlightCode "elm"


roleConfig : UiElement Msg
roleConfig =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.section "Roles"
        , Component.wrappedText "There are 6 roles for a button, as well as a Light and Dark role. By default it is the Primary role"
        , UiFramework.uiWrappedRow
            [ Element.spacing 4 ]
            (List.map
                (\( role, name ) ->
                    Button.default
                        |> Button.withLabel name
                        |> Button.withRole role
                        |> Button.view
                )
                rolesAndNames
            )
        , roleConfigCode
        ]


roleConfigCode : UiElement Msg
roleConfigCode =
    """
{-| All the roles are:
  - Primary
  - Secondary
  - Success
  - Info
  - Warning
  - Danger
  - Light
  - Dark
-}

buttons =
    UiFramework.uiRow 
        [ Element.spacing 4 ] 
        [ -- no need for a Button.withRole for the Primary one
        Button.default
            |> Button.withLabel "Primary"
            |> Button.view
        , Button.default
            |> Button.withLabel "Secondary"
            |> Button.withRole Secondary
            |> Button.view
        ...
        ]"""
        |> Util.uiHighlightCode "elm"


basicFunctionalityConfig : UiElement Msg
basicFunctionalityConfig =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.section "withMessage and withLabel"
        , Component.wrappedText "These provide the same functionality as Button.simple. By default, every button has a label of an empty string and Nothing for a message."
        , Button.simple NoOp "Button"
        , basicFunctionalityConfigCode
        ]


basicFunctionalityConfigCode : UiElement Msg
basicFunctionalityConfigCode =
    """
type Msg 
    = DoSomething 


basicButton =
    Button.simple DoSomething "Button"


-- is the same as 

basicButton =
    Button.default 
        |> Button.withMessage (Just DoSomething)
        |> Button.withLabel "Button\""""
        |> Util.uiHighlightCode "elm"


outlineConfig : UiElement Msg
outlineConfig =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.section "Outline"
        , UiFramework.uiParagraph [] 
            [Util.text "Bootstrap gives you "
            , Component.code "Button.withOutlined" 
            , Util.text ", where the background colors are removed."
            ]
        , UiFramework.uiWrappedRow
            [ Element.spacing 4 ]
            (List.map
                (\( role, name ) ->
                    Button.default
                        |> Button.withLabel name
                        |> Button.withRole role
                        |> Button.withOutlined
                        |> Button.view
                )
                rolesAndNames
            )
        , outlineConfigCode
        ]


outlineConfigCode : UiElement Msg
outlineConfigCode =
    """
outlinedButtons =
    UiFramework.uiRow 
        [ Element.spacing 4 ] 
        [ Button.default
            |> Button.withLabel "Primary"
            |> Button.withOutlined
            |> Button.view
        , Button.default
            |> Button.withLabel "Secondary"
            |> Button.withRole Secondary
            |> Button.withOutlined
            |> Button.view
        ...
        ]"""
        |> Util.uiHighlightCode "elm"


sizeConfig : UiElement Msg
sizeConfig =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.section "Sizes"
        , Component.wrappedText "Large and small buttons differ in font and padding size."
        , UiFramework.uiWrappedRow
            [ Element.spacing 4 ]
            [ Button.default
                |> Button.withLabel "Large Button"
                |> Button.withLarge
                |> Button.view
            , Button.default
                |> Button.withLabel "Regular Button"
                |> Button.view
            , Button.default
                |> Button.withLabel "Small Button"
                |> Button.withSmall
                |> Button.view
            ]
        , sizeConfigCode
        ]


sizeConfigCode : UiElement Msg
sizeConfigCode =
    """
buttonSizes =
    UiFramework.uiWrappedRow
        [ Element.spacing 4 ]
        [ Button.default
            |> Button.withLabel "Large Button"
            |> Button.withLarge
            |> Button.view
        , Button.default
            |> Button.withLabel "Regular Button"
            |> Button.view
        , Button.default
            |> Button.withLabel "Small Button"
            |> Button.withSmall
            |> Button.view
        ]"""
        |> Util.uiHighlightCode "elm"


blockConfig : UiElement Msg
blockConfig =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.section "Block buttons"
        , UiFramework.uiParagraph []  [Util.text "Take up the entirety of the parent container width via the "
        , Component.code "withBlock" 
        , Util.text " function. This option is not functional yet."]
        , Button.default
            |> Button.withLabel "Block Button"
            |> Button.withBlock
            |> Button.view
        , blockConfigCode
        ]


blockConfigCode : UiElement Msg
blockConfigCode =
    """
blockButton =
    Button.default
        |> Button.withLabel "Block Button"
        |> Button.withBlock
        |> Button.view"""
        |> Util.uiHighlightCode "elm"


disableConfig : UiElement Msg
disableConfig =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.section "Disabled buttons"
        , UiFramework.uiParagraph []  [Util.text "Make a button look inactive by the "
            , Component.code "withDisabled" 
            , Util.text " function."]
        , UiFramework.uiWrappedRow
            [ Element.spacing 4 ]
            (List.map
                (\( role, name ) ->
                    Button.default
                        |> Button.withLabel name
                        |> Button.withRole role
                        |> Button.withDisabled
                        |> Button.view
                )
                rolesAndNames
            )
        , disableConfigCode
        ]


disableConfigCode : UiElement Msg
disableConfigCode =
    """
buttonSizes =
    UiFramework.uiWrappedRow
        [ Element.spacing 4 ]
        [ Button.default
            |> Button.withLabel "Primary"
            |> Button.withDisabled
            |> Button.view
        , Button.default
            |> Button.withLabel "Secondary"
            |> Button.withRole Secondary
            |> Button.withDisabled
            |> Button.view
        ...
        ]"""
        |> Util.uiHighlightCode "elm"


iconConfig : UiElement Msg
iconConfig =
    UiFramework.uiColumn
        [ width fill
        , Element.spacing 32
        ]
        [ Component.section "Buttons with Icons"
        , Component.wrappedText "Though used primarily with navbars, buttons with icons can serve other uses as well."
        , UiFramework.uiParagraph []
            [ Util.text "Note that you'll have to "
            , Util.text "include the required CSS in your website "
            , Util.text "(check out the Elm FontAwesome page for more details - "
            , Util.text "https://github.com/lattyware/elm-fontawesome/tree/3.1.0#required-css)"
            ]
        , UiFramework.uiParagraph [] 
            [Util.text "As of now, you cannot add a custom" 
            , Component.code "UiElement"
            , Util.text " to a button. This means you cannot add an animated icon, for example."]
        , UiFramework.uiWrappedRow
            [ Element.spacing 4 ]
            [ Button.default
                |> Button.withLabel "Github"
                |> Button.withIcon FontAwesome.Brands.github
                |> Button.view
            ]
        , iconConfigCode
        ]


iconConfigCode : UiElement Msg
iconConfigCode =
    """
import FontAwesome.Brands

buttonSizes =
    UiFramework.uiWrappedRow
        [ Element.spacing 4 ]
        [ Button.default
            |> Button.withLabel "Github"
            |> Button.withIcon FontAwesome.Brands.github
            |> Button.view
        ]"""
        |> Util.uiHighlightCode "elm"


rolesAndNames : List ( Role, String )
rolesAndNames =
    [ ( Primary, "Primary" )
    , ( Secondary, "Secondary" )
    , ( Success, "Success" )
    , ( Info, "Info" )
    , ( Warning, "Warning" )
    , ( Danger, "Danger" )
    , ( Light, "Light" )
    , ( Dark, "Dark" )
    ]



-- UPDATE


type Msg
    = NoOp
    | NavigateTo Routes.Route


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, NoUpdate )

        NavigateTo route ->
            ( model, Util.navigate sharedState.navKey route, NoUpdate )
