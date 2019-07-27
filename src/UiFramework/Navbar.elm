module UiFramework.Navbar exposing (BackgroundColor(..), Context, Dropdown(..), DropdownMenuItem(..), DropdownOptions, LinkItemOptions, MenuItem(..), Navbar(..), NavbarOptions, NavbarState, UiElement, default, dropdown, dropdownMenuLinkItem, linkItem, onClick, view, viewCollapsedMenuList, viewDropdownItem, viewDropdownMenu, viewLinkItem, viewMenuItem, viewMenubarList, withBackground, withBackgroundColor, withBrand, withDropdownMenuIcon, withDropdownMenuItems, withDropdownMenuTitle, withExtraAttrs, withMenuIcon, withMenuItems, withMenuTitle)

import Element
    exposing
        ( Attribute
        , Color
        , Device
        , DeviceClass(..)
        , Element
        , Orientation(..)
        , alignLeft
        , alignRight
        , below
        , column
        , el
        , fill
        , height
        , htmlAttribute
        , none
        , padding
        , paddingXY
        , pointer
        , px
        , row
        , spacing
        , text
        , width
        )
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
import Html.Events
import Json.Decode as Json
import UiFramework.Colors as Colors
import UiFramework.Configuration exposing (ThemeConfig)
import UiFramework.Icon as Icon
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


type alias NavbarState state =
    { toggleMenuState : Bool
    , dropdownState : state
    }


type alias Context context state =
    { context
        | device : Device
        , themeConfig : ThemeConfig
        , parentRole : Maybe Role
        , state : NavbarState state
    }


type alias UiElement context state msg =
    Internal.WithContext (Context context state) msg


type Navbar context state msg
    = Navbar (NavbarOptions context state msg)


type alias NavbarOptions context state msg =
    { toggleMenuMsg : msg
    , brand : Maybe (Element msg)
    , backgroundColor : BackgroundColor
    , items : List (MenuItem context state msg)
    , attributes : List (Attribute msg)
    }


type BackgroundColor
    = Roled Role
    | Custom Color
    | Class String


type MenuItem context state msg
    = LinkItem (LinkItemOptions msg)
    | DropdownItem (Dropdown context state msg)
    | CustomItem


type alias LinkItemOptions msg =
    { triggerMsg : msg
    , icon : Maybe Icon.Icon
    , title : String
    }


type Dropdown context state msg
    = Dropdown (DropdownOptions context state msg)


type DropdownMenuItem context msg
    = DropdownMenuLinkItem (LinkItemOptions msg)
    | DropdownMenuCustomItem


type alias DropdownOptions context state msg =
    { toggleDropdownMsg : msg
    , openState : state
    , icon : Maybe Icon.Icon
    , title : String
    , items : List (DropdownMenuItem context msg)
    }


withBrand : Element msg -> Navbar context state msg -> Navbar context state msg
withBrand brand (Navbar options) =
    Navbar { options | brand = Just brand }


withBackground : Role -> Navbar context state msg -> Navbar context state msg
withBackground role (Navbar options) =
    Navbar { options | backgroundColor = Roled role }


withBackgroundColor : Color -> Navbar context state msg -> Navbar context state msg
withBackgroundColor color (Navbar options) =
    Navbar { options | backgroundColor = Custom color }


withMenuItems : List (MenuItem context state msg) -> Navbar context state msg -> Navbar context state msg
withMenuItems items (Navbar options) =
    Navbar { options | items = items }


withExtraAttrs : List (Attribute msg) -> Navbar context state msg -> Navbar context state msg
withExtraAttrs attributes (Navbar options) =
    Navbar { options | attributes = attributes }


default : msg -> Navbar context state msg
default msg =
    Navbar
        { toggleMenuMsg = msg
        , brand = Nothing
        , backgroundColor = Roled Light
        , items = []
        , attributes = []
        }


linkItem : msg -> MenuItem context state msg
linkItem msg =
    LinkItem
        { triggerMsg = msg
        , icon = Nothing
        , title = ""
        }


withMenuIcon : Icon.Icon -> MenuItem context state msg -> MenuItem context state msg
withMenuIcon icon item =
    case item of
        LinkItem options ->
            LinkItem { options | icon = Just icon }

        DropdownItem (Dropdown options) ->
            DropdownItem <| Dropdown { options | icon = Just icon }

        CustomItem ->
            item


withMenuTitle : String -> MenuItem context state msg -> MenuItem context state msg
withMenuTitle title item =
    case item of
        LinkItem options ->
            LinkItem { options | title = title }

        DropdownItem (Dropdown options) ->
            DropdownItem <| Dropdown { options | title = title }

        CustomItem ->
            item


dropdown : msg -> state -> Dropdown context state msg
dropdown msg openState =
    Dropdown
        { toggleDropdownMsg = msg
        , openState = openState
        , icon = Nothing
        , title = ""
        , items = []
        }


withDropdownMenuItems : List (DropdownMenuItem context msg) -> Dropdown context state msg -> Dropdown context state msg
withDropdownMenuItems items (Dropdown options) =
    Dropdown { options | items = items }


dropdownMenuLinkItem : msg -> DropdownMenuItem context msg
dropdownMenuLinkItem msg =
    DropdownMenuLinkItem
        { triggerMsg = msg
        , icon = Nothing
        , title = ""
        }


withDropdownMenuIcon : Icon.Icon -> DropdownMenuItem context msg -> DropdownMenuItem context msg
withDropdownMenuIcon icon item =
    case item of
        DropdownMenuLinkItem options ->
            DropdownMenuLinkItem { options | icon = Just icon }

        DropdownMenuCustomItem ->
            item


withDropdownMenuTitle : String -> DropdownMenuItem context msg -> DropdownMenuItem context msg
withDropdownMenuTitle title item =
    case item of
        DropdownMenuLinkItem options ->
            DropdownMenuLinkItem { options | title = title }

        DropdownMenuCustomItem ->
            item



-- Render Navbar


view : Navbar context state msg -> UiElement context state msg
view (Navbar options) =
    Internal.flatMap
        (\context ->
            let
                navbarConfig =
                    context.themeConfig.navbarConfig

                backgroundColor =
                    case options.backgroundColor of
                        Roled role ->
                            context.themeConfig.themeColor role

                        Custom color ->
                            color

                        Class cssStr ->
                            Colors.getColor cssStr

                fontColor =
                    context.themeConfig.fontColor backgroundColor

                headerAttrs =
                    [ width fill
                    , paddingXY navbarConfig.paddingX navbarConfig.paddingY
                    , Background.color backgroundColor
                    , Font.color fontColor
                    ]

                brand attrs =
                    Internal.fromElement
                        (\_ ->
                            el attrs
                                (options.brand |> Maybe.withDefault none)
                        )

                navButton toggleMenuMsg =
                    Internal.fromElement
                        (\_ ->
                            el
                                [ onClick toggleMenuMsg
                                , alignLeft
                                , paddingXY navbarConfig.togglerPaddingX navbarConfig.togglerPaddingY
                                , Border.color fontColor
                                , Border.solid
                                , Border.width 1
                                , Border.rounded navbarConfig.togglerBorderRadius
                                , pointer
                                ]
                            <|
                                column
                                    [ spacing 6, padding 6 ]
                                    [ iconBar, iconBar, iconBar ]
                        )

                iconBar =
                    el
                        [ width <| px 24
                        , height <| px 2
                        , Background.color fontColor
                        , Border.rounded 1
                        ]
                        none
            in
            if collapseNavbar context.device then
                Internal.uiColumn headerAttrs <|
                    [ Internal.uiRow [ width fill ]
                        [ navButton options.toggleMenuMsg
                        , brand [ alignRight ]
                        ]
                    ]
                        ++ (if context.state.toggleMenuState then
                                [ viewCollapsedMenuList options.items ]

                            else
                                []
                           )

            else
                Internal.uiRow headerAttrs [ brand [ alignLeft ], viewMenubarList options.items ]
        )


collapseNavbar : Device -> Bool
collapseNavbar device =
    case device.class of
        Phone ->
            True

        Tablet ->
            if device.orientation == Portrait then
                True

            else
                False

        _ ->
            False


viewCollapsedMenuList : List (MenuItem context state msg) -> UiElement context state msg
viewCollapsedMenuList items =
    Internal.fromElement
        (\context ->
            column
                [ Region.navigation
                , width fill
                , alignLeft
                , Font.alignLeft
                ]
            <|
                List.map (viewMenuItem >> Internal.toElement context) items
        )


viewMenubarList : List (MenuItem context state msg) -> UiElement context state msg
viewMenubarList items =
    Internal.fromElement
        (\context ->
            row
                [ Region.navigation
                , alignRight
                , Font.center
                ]
            <|
                List.map (viewMenuItem >> Internal.toElement context) items
        )


viewMenuItem : MenuItem context state msg -> UiElement context state msg
viewMenuItem item =
    case item of
        LinkItem options ->
            viewLinkItem options

        DropdownItem (Dropdown options) ->
            viewDropdownItem options

        CustomItem ->
            Internal.uiNone


viewLinkItem : LinkItemOptions msg -> UiElement context state msg
viewLinkItem options =
    Internal.fromElement
        (\context ->
            el
                [ onClick options.triggerMsg
                , paddingXY
                    context.themeConfig.navConfig.linkPaddingX
                    context.themeConfig.navConfig.linkPaddingY
                , width fill
                , pointer
                ]
                (case options.icon of
                    Nothing ->
                        text options.title

                    Just icon ->
                        row [ spacing 5 ] [ el [] <| Icon.view icon, el [] (text options.title) ]
                )
        )


viewDropdownItem : DropdownOptions context state msg -> UiElement context state msg
viewDropdownItem options =
    Internal.fromElement
        (\context ->
            el
                [ onClick options.toggleDropdownMsg
                , paddingXY
                    context.themeConfig.navConfig.linkPaddingX
                    context.themeConfig.navConfig.linkPaddingY
                , pointer
                , below <|
                    if context.state.dropdownState == options.openState then
                        Internal.toElement context <| viewDropdownMenu options.items

                    else
                        none
                ]
                (case options.icon of
                    Nothing ->
                        text <| options.title ++ " ▾"

                    Just icon ->
                        row [ spacing 5 ] [ el [] <| Icon.view icon, el [] (text <| options.title ++ " ▾") ]
                )
        )


viewDropdownMenu : List (DropdownMenuItem context msg) -> UiElement context state msg
viewDropdownMenu items =
    Internal.fromElement
        (\context ->
            let
                dropdownConfig =
                    context.themeConfig.dropdownConfig

                menuAlignment =
                    if collapseNavbar context.device then
                        alignLeft

                    else
                        alignRight
            in
            el [ menuAlignment ] <|
                column
                    [ paddingXY dropdownConfig.paddingX dropdownConfig.paddingY
                    , spacing dropdownConfig.spacer
                    , Background.color dropdownConfig.backgroundColor
                    , Font.color dropdownConfig.fontColor
                    , Font.alignLeft
                    , Border.rounded dropdownConfig.borderRadius
                    , Border.color dropdownConfig.borderColor
                    , Border.solid
                    , Border.width dropdownConfig.borderWidth
                    ]
                    (List.map
                        (\item ->
                            case item of
                                DropdownMenuLinkItem options ->
                                    Internal.toElement context <| viewLinkItem options

                                DropdownMenuCustomItem ->
                                    none
                        )
                        items
                    )
        )


onClick : msg -> Attribute msg
onClick message =
    Html.Events.custom
        "click"
        (Json.succeed
            { message = message
            , stopPropagation = True
            , preventDefault = False
            }
        )
        |> htmlAttribute
