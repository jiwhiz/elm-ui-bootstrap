module UiFramework.Dropdown exposing (Dropdown, MenuItem, default, menuLinkItem, menuHeader, view, withIcon, withMenuIcon, withMenuItems, withMenuTitle, withTitle)

import Element
    exposing
        ( Attribute
        , Device
        , DeviceClass(..)
        , Orientation(..)
        , alignLeft
        , alignRight
        , below
        , column
        , el
        , fill
        , none
        , paddingXY
        , pointer
        , row
        , spacing
        , text
        , width
        )
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import UiFramework.Configuration exposing (ThemeConfig)
import UiFramework.Icon as Icon
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


type alias Context context =
    { context
        | device : Device
        , themeConfig : ThemeConfig
        , parentRole : Maybe Role
    }


type alias UiElement context msg =
    Internal.WithContext (Context context) msg


type Dropdown context state msg
    = Dropdown (DropdownOptions context state msg)


type alias DropdownOptions context state msg =
    { toggleDropdownMsg : msg
    , openState : state
    , icon : Maybe (Icon.Icon msg)
    , title : String
    , items : List (MenuItem context msg)
    }


type MenuItem context msg
    = LinkItem (LinkItemOptions msg)
    | Header String
    | Divider


type alias LinkItemOptions msg =
    { triggerMsg : msg
    , icon : Maybe (Icon.Icon msg)
    , title : String
    }


withIcon : Icon.Icon msg -> Dropdown context state msg -> Dropdown context state msg
withIcon icon (Dropdown options) =
    Dropdown { options | icon = Just icon }


withTitle : String -> Dropdown context state msg -> Dropdown context state msg
withTitle title (Dropdown options) =
    Dropdown { options | title = title }


withMenuItems : List (MenuItem context msg) -> Dropdown context state msg -> Dropdown context state msg
withMenuItems items (Dropdown options) =
    Dropdown { options | items = items }


default : msg -> state -> Dropdown context state msg
default msg openState =
    Dropdown
        { toggleDropdownMsg = msg
        , openState = openState
        , icon = Nothing
        , title = ""
        , items = []
        }


menuLinkItem : msg -> MenuItem context msg
menuLinkItem msg =
    LinkItem
        { triggerMsg = msg
        , icon = Nothing
        , title = ""
        }


withMenuIcon : Icon.Icon msg -> MenuItem context msg -> MenuItem context msg
withMenuIcon icon item =
    case item of
        LinkItem options ->
            LinkItem { options | icon = Just icon }

        _ ->
            item


withMenuTitle : String -> MenuItem context msg -> MenuItem context msg
withMenuTitle title item =
    case item of
        LinkItem options ->
            LinkItem { options | title = title }

        _ ->
            item


menuHeader : String -> MenuItem context msg
menuHeader title =
    Header title


-- Render Dropdown


view : state -> Dropdown context state msg -> UiElement context msg
view dropdownState (Dropdown options) =
    Internal.fromElement
        (\context ->
            el
                [ Internal.onClick options.toggleDropdownMsg
                , paddingXY
                    context.themeConfig.navConfig.linkPaddingX
                    context.themeConfig.navConfig.linkPaddingY
                , pointer
                , below <|
                    if dropdownState == options.openState then
                        Internal.toElement context <| viewDropdownMenu options.items

                    else
                        none
                ]
                (case options.icon of
                    Nothing ->
                        text <| options.title ++ " ▾"

                    Just icon ->
                        row [ spacing 5 ] [ el [] <| Icon.viewAsElement icon, el [] (text <| options.title ++ " ▾") ]
                )
        )


viewDropdownMenu : List (MenuItem context msg) -> UiElement context msg
viewDropdownMenu items =
    Internal.fromElement
        (\context ->
            let
                dropdownConfig =
                    context.themeConfig.dropdownConfig

                menuAlignment =
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
                                LinkItem options ->
                                    Internal.toElement context <| viewLinkItem options

                                Header title ->
                                    Internal.toElement context <| Internal.uiText title

                                _ ->
                                    none
                        )
                        items
                    )
        )


viewLinkItem : LinkItemOptions msg -> UiElement context msg
viewLinkItem options =
    Internal.fromElement
        (\context ->
            el
                [ Internal.onClick options.triggerMsg
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
                        row [ spacing 5 ] [ el [] <| Icon.viewAsElement icon, el [] (text options.title) ]
                )
        )
