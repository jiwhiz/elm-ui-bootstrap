module UiFramework.Alert exposing
    ( Alert
    , Options
    , default
    , link
    , simple
    , view
    , withChild
    , withExtraAttrs
    , withLarge
    , withRole
    , withSmall
    )

import Element exposing (Attribute, el, fill, none, paddingXY, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


type Alert context msg
    = Alert (Options context msg)


type alias Options context msg =
    { role : Role
    , size : Size
    , attributes : List (Attribute msg)
    , child : UiElement context msg
    }


withRole : Role -> Alert context msg -> Alert context msg
withRole role (Alert options) =
    Alert { options | role = role }


withLarge : Alert context msg -> Alert context msg
withLarge (Alert options) =
    Alert { options | size = SizeLarge }


withSmall : Alert context msg -> Alert context msg
withSmall (Alert options) =
    Alert { options | size = SizeSmall }


withExtraAttrs : List (Attribute msg) -> Alert context msg -> Alert context msg
withExtraAttrs attributes (Alert options) =
    Alert { options | attributes = attributes }


withChild : UiElement context msg -> Alert context msg -> Alert context msg
withChild child (Alert options) =
    Alert { options | child = child }


defaultOptions : Options context msg
defaultOptions =
    { role = Primary
    , size = SizeDefault
    , attributes = []
    , child = Internal.fromElement (\_ -> none)
    }


default : Alert context msg
default =
    Alert defaultOptions


simple : Role -> UiElement context msg -> UiElement context msg
simple role child =
    default
        |> withRole role
        |> withChild child
        |> view



-- Rendering Alert


view : Alert context msg -> UiElement context msg
view (Alert options) =
    Internal.fromElement
        (\context ->
            el (viewAttributes context options) <|
                Internal.toElement
                    { context | parentRole = Just options.role }
                    options.child
        )


viewAttributes : Internal.UiContextual context -> Options context mag -> List (Attribute msg)
viewAttributes context options =
    let
        config =
            context.themeConfig.alertConfig
    in
    [ width fill
    , paddingXY config.paddingX config.paddingY
    , Font.alignLeft
    , Font.size <| config.fontSize options.size
    , Font.color <| config.fontColor options.role
    , Border.rounded <| config.borderRadius options.size
    , Border.width <| config.borderWidth options.size
    , Border.solid
    , Border.color <| config.borderColor options.role
    , Background.color <| config.backgroundColor options.role
    ]



-- Alert Link


link :
    { onPress : Maybe msg
    , label : UiElement context msg
    }
    -> UiElement context msg
link { onPress, label } =
    Internal.fromElement
        (\context ->
            let
                role =
                    context.parentRole |> Maybe.withDefault Primary

                fontColor =
                    context.themeConfig.alertConfig.fontColor role
            in
            Input.button
                [ Font.bold, Font.color fontColor ]
                { onPress = onPress
                , label = Internal.toElement context label
                }
        )
