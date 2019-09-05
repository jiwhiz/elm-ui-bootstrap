module UiFramework.Container exposing (Container(..), Options, UiElement, default, defaultOptions, jumbotron, maxWidth, simple, view, viewAttributes, withChild, withExtraAttrs, withFullWidth)

import Element exposing (Attribute, DeviceClass(..))
import Element.Background as Background
import Element.Border as Border
import UiFramework
import UiFramework.ColorUtils exposing (transparent)
import UiFramework.Internal as Internal


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


type Container context msg
    = Container (Options context msg)


{-| jumbotron adds a background to the container
fillWidth is the same as toggling container-fluid. If it's false it will automatically have a "max-width" attribute
containers only have one child element.
-}
type alias Options context msg =
    { jumbotron : Bool
    , fillWidth : Bool
    , child : UiElement context msg
    , attributes : List (Attribute msg)
    }


defaultOptions : Options context msg
defaultOptions =
    { jumbotron = False
    , fillWidth = False
    , child = UiFramework.uiNone
    , attributes = []
    }


withChild : UiElement context msg -> Container context msg -> Container context msg
withChild child (Container options) =
    Container { options | child = child }


{-| same as declaring 'container-fluid"
-}
withFullWidth : Container context msg -> Container context msg
withFullWidth (Container options) =
    Container { options | fillWidth = True }


jumbotron : Container context msg
jumbotron =
    Container { defaultOptions | jumbotron = True }


withExtraAttrs : List (Attribute msg) -> Container context msg -> Container context msg
withExtraAttrs attributes (Container options) =
    Container { options | attributes = attributes }


default : Container context msg
default =
    Container defaultOptions


{-| basically `<div class="container> child </div>`
-}
simple : List (Attribute msg) -> UiElement context msg -> UiElement context msg
simple attributes child =
    default
        |> withExtraAttrs attributes
        |> withChild child
        |> view


view : Container context msg -> UiElement context msg
view (Container options) =
    Internal.fromElement
        (\context ->
            Element.el
                (viewAttributes context options)
                (Internal.toElement context options.child)
        )


viewAttributes : Internal.UiContextual context -> Options context msg -> List (Attribute msg)
viewAttributes context options =
    let
        config =
            context.themeConfig.containerConfig

        ( backgroundColor, padding ) =
            if options.jumbotron then
                ( config.jumbotronBackgroundColor, config.jumbotronPadding context.device.class )

            else
                ( transparent, config.containerPadding )

        width =
            Element.fill
                |> (if options.fillWidth then
                        identity

                    else
                        Element.maximum (maxWidth context.device.class)
                   )
    in
    [ Element.paddingXY padding.x padding.y
    , Border.rounded config.borderRadius
    , Border.color config.borderColor
    , Border.width config.borderWidth
    , Background.color backgroundColor
    , Element.width width
    , Element.centerX
    ]
        ++ options.attributes


maxWidth : DeviceClass -> Int
maxWidth device =
    case device of
        Phone ->
            540

        Tablet ->
            720

        _ ->
            1140
