module UiFramework.Internal exposing
    ( UiContextual
    , WithContext
    , fromElement
    , node
    , toElement
    , uiColumn
    , uiContextualText
    , uiLink
    , uiNone
    , uiParagraph
    , uiRow
    , uiText
    , uiWrappedRow
    , withContext
    )

import Element exposing (Attribute, Device, Element)
import Element.Font as Font
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


withContext : (context -> WithContext context msg) -> WithContext context msg
withContext f =
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


uiText : String -> WithContext (UiContextual c) msg
uiText string =
    Leaf <| \context -> Element.text string


uiContextualText : (UiContextual c -> String) -> WithContext (UiContextual c) msg
uiContextualText f =
    Leaf <| \context -> Element.text <| f context


uiLink : { url : String, label : String } -> WithContext (UiContextual c) msg
uiLink { url, label } =
    Leaf <|
        \context ->
            let
                linkConfig =
                    context.themeConfig.linkConfig
            in
            Element.newTabLink
                [ Font.color linkConfig.linkColor
                , Element.mouseOver [ Font.color linkConfig.linkHoverColor ]
                ]
                { url = url
                , label = Element.text label
                }


uiRow : List (Attribute msg) -> List (WithContext (UiContextual c) msg) -> WithContext (UiContextual c) msg
uiRow attrs =
    node
        (\_ ->
            Element.row attrs
        )


uiWrappedRow : List (Attribute msg) -> List (WithContext (UiContextual c) msg) -> WithContext (UiContextual c) msg
uiWrappedRow attrs =
    node
        (\_ ->
            Element.wrappedRow attrs
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
