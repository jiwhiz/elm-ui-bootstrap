module UiFramework.Button exposing
    ( Button
    , default
    , link
    , simple
    , view
    , withBadge
    , withBlock
    , withDisabled
    , withExtraAttrs
    , withIcon
    , withLabel
    , withLarge
    , withMessage
    , withOutlined
    , withRole
    , withSmall
    )

import Element exposing (Attribute, Color, el, paddingXY, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import UiFramework.Badge as Badge
import UiFramework.ColorUtils exposing (alterColor, darken, transparent)
import UiFramework.Icon as Icon
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


type Button context msg
    = Button (Options context msg)


type alias Options context msg =
    { role : Role
    , outlined : Bool
    , block : Bool
    , disabled : Bool
    , size : Size
    , onPress : Maybe msg
    , icon : Maybe (Icon.Icon msg)
    , label : String
    , badge : Maybe (Badge.Badge context msg)
    , attributes : List (Attribute msg)
    }


withRole : Role -> Button context msg -> Button context msg
withRole role (Button options) =
    Button { options | role = role }


withOutlined : Button context msg -> Button context msg
withOutlined (Button options) =
    Button { options | outlined = True }


withBlock : Button context msg -> Button context msg
withBlock (Button options) =
    Button { options | block = True }


withDisabled : Button context msg -> Button context msg
withDisabled (Button options) =
    Button { options | disabled = True }


withLarge : Button context msg -> Button context msg
withLarge (Button options) =
    Button { options | size = SizeLarge }


withSmall : Button context msg -> Button context msg
withSmall (Button options) =
    Button { options | size = SizeSmall }


withMessage : Maybe msg -> Button context msg -> Button context msg
withMessage msg (Button options) =
    Button { options | onPress = msg }


withIcon : Icon.Icon msg -> Button context msg -> Button context msg
withIcon icon (Button options) =
    Button { options | icon = Just icon }


withBadge : Badge.Badge context msg -> Button context msg -> Button context msg
withBadge badge (Button options) =
    Button { options | badge = Just badge }


withLabel : String -> Button context msg -> Button context msg
withLabel label (Button options) =
    Button { options | label = label }


withExtraAttrs : List (Attribute msg) -> Button context msg -> Button context msg
withExtraAttrs attributes (Button options) =
    Button { options | attributes = attributes }


defaultOptions : Options context msg
defaultOptions =
    { role = Primary
    , outlined = False
    , block = False
    , disabled = False
    , size = SizeDefault
    , onPress = Nothing
    , icon = Nothing
    , label = ""
    , badge = Nothing
    , attributes = []
    }


default : Button context msg
default =
    Button defaultOptions


simple : msg -> String -> UiElement context msg
simple msg label =
    default
        |> withMessage (Just msg)
        |> withLabel label
        |> view



-- Rendering the button


view : Button context msg -> UiElement context msg
view (Button options) =
    Internal.fromElement
        (\context ->
            let
                icons =
                    options.icon
                        |> Maybe.map (Icon.viewAsElement >> List.singleton)
                        |> Maybe.withDefault []

                badges =
                    options.badge
                        |> Maybe.map (Badge.view >> Internal.toElement context >> List.singleton)
                        |> Maybe.withDefault []
            in
            Input.button
                (viewAttributes context options)
                { onPress = options.onPress
                , label = row [ spacing 5 ] (icons ++ [ text options.label ] ++ badges)
                }
        )


viewAttributes : Internal.UiContextual context -> Options context msg -> List (Attribute msg)
viewAttributes context options =
    let
        config =
            context.themeConfig.buttonConfig

        btnColors =
            buttonColors context options
    in
    [ paddingXY (config.paddingX options.size) (config.paddingY options.size)
    , Font.center
    , Font.size <| config.fontSize options.size
    , Font.color btnColors.font
    , Border.rounded <| config.borderRadius options.size
    , Border.width <| config.borderWidth options.size
    , Border.solid
    , Border.color <| btnColors.border
    , Background.color btnColors.background
    , Element.mouseOver
        [ Background.color btnColors.hoverBackground
        , Font.color btnColors.hoverFont
        , Border.color btnColors.hoverBorder
        ]
    , Border.shadow <|
        case config.withShadow of
            Nothing ->
                { offset = ( 0, 0 )
                , size = 0
                , blur = 0
                , color = Element.rgba 0 0 0 1
                }

            Just shadow ->
                shadow
    ]


type alias ButtonColorsConfig =
    { background : Color
    , border : Color
    , font : Color
    , hoverBackground : Color
    , hoverBorder : Color
    , hoverFont : Color
    }


buttonColors : Internal.UiContextual context -> Options context msg -> ButtonColorsConfig
buttonColors context options =
    let
        config =
            context.themeConfig.buttonConfig

        defaultColors =
            { background = config.backgroundColor options.role
            , border = config.backgroundColor options.role
            , font = config.fontColor options.role
            , hoverBackground = config.backgroundColor options.role |> darken 0.075
            , hoverBorder = config.backgroundColor options.role |> darken 0.075
            , hoverFont = config.fontColor options.role
            }
    in
    if options.outlined then
        { defaultColors
            | background = transparent
            , border = config.backgroundColor options.role
            , font = config.backgroundColor options.role
            , hoverBackground = config.backgroundColor options.role
            , hoverBorder = config.backgroundColor options.role
        }

    else if options.disabled then
        { defaultColors
            | border = config.backgroundColor options.role |> alterColor 0.65
            , background = config.backgroundColor options.role |> alterColor 0.65
            , hoverBorder = config.backgroundColor options.role |> alterColor 0.65
            , hoverBackground = config.backgroundColor options.role |> alterColor 0.65
        }

    else
        defaultColors



--  Link Button


link :
    { onPress : Maybe msg
    , label : UiElement context msg
    }
    -> UiElement context msg
link { onPress, label } =
    Internal.fromElement
        (\context ->
            let
                linkConfig =
                    context.themeConfig.linkConfig
            in
            Input.button
                [ Font.color linkConfig.linkColor
                , Element.mouseOver [ Font.color linkConfig.linkHoverColor ]
                ]
                { onPress = onPress
                , label = Internal.toElement context label
                }
        )
