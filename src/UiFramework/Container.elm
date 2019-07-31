module UiFramework.Container exposing (Container(..), Options, UiElement, default, defaultOptions, jumbotron, view, viewAttributes, withChild)

import Element exposing (Attribute)
import Element.Background as Background
import Element.Border as Border
import UiFramework
import UiFramework.Internal as Internal


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


type Container context msg
    = Container (Options context msg)


type alias Options context msg =
    { jumbotron : Bool
    , child : UiElement context msg
    }


defaultOptions : Options context msg
defaultOptions =
    { jumbotron = False
    , child = UiFramework.uiNone
    }


withChild : UiElement context msg -> Container context msg -> Container context msg
withChild child (Container options) =
    Container { options | child = child }


jumbotron : Container context msg
jumbotron =
    Container { defaultOptions | jumbotron = True }


default : Container context msg
default =
    Container defaultOptions


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

        backgroundColor =
            if options.jumbotron then
                config.jumbotronBackgroundColor

            else
                config.backgroundColor
    in
    [ Element.paddingXY 32 64
    , Border.rounded config.borderRadius
    , Border.color config.borderColor
    , Border.width config.borderWidth
    , Background.color backgroundColor
    , Element.width Element.fill
    ]
