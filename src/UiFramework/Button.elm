module UiFramework.Button exposing
    ( Button
    , default
    , simple
    , view
    , withBlock
    , withDisabled
    , withIcon
    , withLabel
    , withLarge
    , withMessage
    , withOutlined
    , withRole
    , withSmall
    )

import Element exposing (Attribute, el, paddingXY, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import UiFramework.Icon as Icon
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


{-| Button type
-}
type Button context msg
    = Button (Options msg)


type alias Options msg =
    { role : Role
    , outlined : Bool
    , block : Bool
    , disabled : Bool
    , size : Size
    , onPress : Maybe msg
    , icon : Maybe Icon.Icon
    , label : String
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


withIcon : Icon.Icon -> Button context msg -> Button context msg
withIcon icon (Button options) =
    Button { options | icon = Just icon }


withLabel : String -> Button context msg -> Button context msg
withLabel label (Button options) =
    Button { options | label = label }


withExtraAttrs : List (Attribute msg) -> Button context msg -> Button context msg
withExtraAttrs attributes (Button options) =
    Button { options | attributes = attributes }


defaultOptions : Options msg
defaultOptions =
    { role = Primary
    , outlined = False
    , block = False
    , disabled = False
    , size = SizeDefault
    , onPress = Nothing
    , icon = Nothing
    , label = ""
    , attributes = []
    }


default : Button context msg
default =
    Button defaultOptions


simple : msg -> String -> Button context msg
simple msg label =
    default
        |> withMessage (Just msg)
        |> withLabel label



-- Rendering the button


view : Button context msg -> UiElement context msg
view (Button options) =
    Internal.fromElement
        (\context ->
            Input.button
                (viewAttributes context options)
                { onPress = options.onPress
                , label =
                    case options.icon of
                        Nothing ->
                            text options.label

                        Just icon ->
                            row [ spacing 5 ] [ el [] <| Icon.view icon, el [] (text options.label) ]
                }
        )


viewAttributes : Internal.UiContextual context -> Options mag -> List (Attribute msg)
viewAttributes context options =
    let
        config =
            context.themeConfig.buttonConfig
    in
    [ paddingXY (config.paddingX options.size) (config.paddingY options.size)
    , Font.center
    , Font.size <| config.fontSize options.size
    , Font.color <| config.fontColor options.role
    , Border.rounded <| config.borderRadius options.size
    , Border.width <| config.borderWidth options.size
    , Border.solid
    , Border.color <| config.borderColor options.role
    , Background.color <| config.backgroundColor options.role
    ]
