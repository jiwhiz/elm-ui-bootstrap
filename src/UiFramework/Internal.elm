module UiFramework.Internal exposing (UiContextual, WithContext, flatMap, fromElement, node, toElement, uiColumn, uiNone, uiParagraph, uiRow, uiText)

import Element exposing (Attribute, Device, Element)
import UiFramework.Configuration exposing (ThemeConfig)
import UiFramework.Types exposing (Role(..))


{-| An opaque type representing elm-ui Element with a context.
-}
type WithContext context msg
    = Node (context -> List (Element msg) -> Element msg) (List (WithContext context msg))
    | Leaf (context -> Element msg)


type alias UiContextual context =
    { context
        | device : Device
        , themeConfig : ThemeConfig
        , parentRole : Maybe Role
    }


{-| Convert to elm-ui Element.
-}
toElement : context -> WithContext context msg -> Element msg
toElement context wc =
    case wc of
        Node f children ->
            f context <| List.map (toElement context) children

        Leaf f ->
            f context


fromElement : (context -> Element msg) -> WithContext context msg
fromElement =
    Leaf


flatMap : (c -> WithContext c msg) -> WithContext c msg
flatMap f =
    fromElement
        (\context ->
            toElement context (f context)
        )


{-| Custom node.
-}
node :
    (context -> List (Element msg) -> Element msg)
    -> List (WithContext context msg)
    -> WithContext context msg
node =
    Node


uiNone : WithContext (UiContextual c) msg
uiNone =
    Leaf <| \_ -> Element.none


uiText : (UiContextual c -> String) -> WithContext (UiContextual c) msg
uiText f =
    Leaf <| \context -> Element.text <| f context


uiRow : List (Attribute msg) -> List (WithContext (UiContextual c) msg) -> WithContext (UiContextual c) msg
uiRow attrs =
    node
        (\_ ->
            Element.row attrs
        )


uiColumn : List (Attribute msg) -> List (WithContext (UiContextual c) msg) -> WithContext (UiContextual c) msg
uiColumn attrs =
    node
        (\_ ->
            Element.column attrs
        )


uiParagraph : List (Attribute msg) -> List (WithContext (UiContextual c) msg) -> WithContext (UiContextual c) msg
uiParagraph attrs =
    node
        (\_ ->
            Element.paragraph attrs
        )
