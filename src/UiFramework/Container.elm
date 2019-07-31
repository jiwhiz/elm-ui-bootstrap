module UiFramework.Container exposing (Container, Options, UiElement, child, default, defaultOptions, jumbotron, roundCorners, view, viewAttributes)

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
    , roundedCorners : Int
    , child : UiElement context msg
    }


defaultOptions : Options context msg
defaultOptions =
    { jumbotron = False
    , roundedCorners = 4
    , child = UiFramework.uiNone
    }


jumbotron : Container context msg -> Container context msg
jumbotron (Container options) =
    Container { options | jumbotron = True }


roundCorners : Int -> Container context msg -> Container context msg
roundCorners int (Container options) =
    Container { options | roundedCorners = int }


child : UiElement context msg -> Container context msg -> Container context msg
child c (Container options) =
    Container { options | child = c }


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
    in
    [ Element.paddingXY 32 64
    , Border.rounded <| options.roundedCorners
    , Background.color <| config.backgroundColor
    , Element.width Element.fill
    ]
