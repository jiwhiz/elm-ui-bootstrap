module UiFramework exposing
    ( UiContextual
    , WithContext
    , flatMap
    , fromElement
    , toElement
    , uiColumn
    , uiContextualText
    , uiNone
    , uiParagraph
    , uiRow
    , uiText
    , uiWrappedRow
    )

import Element exposing (Attribute, Element)
import UiFramework.Internal as Internal


type alias UiContextual c =
    Internal.UiContextual c


type alias WithContext c msg =
    Internal.WithContext (UiContextual c) msg


toElement : UiContextual c -> WithContext c msg -> Element msg
toElement =
    Internal.toElement


fromElement : (UiContextual c -> Element msg) -> WithContext c msg
fromElement =
    Internal.fromElement


flatMap : (UiContextual c -> WithContext c msg) -> WithContext c msg
flatMap =
    Internal.flatMap


uiNone : WithContext c msg
uiNone =
    Internal.uiNone


{-| Text node.
-}
uiText : String -> WithContext c msg
uiText =
    Internal.uiText


uiContextualText : (UiContextual c -> String) -> WithContext c msg
uiContextualText =
    Internal.uiContextualText


uiRow : List (Attribute msg) -> List (WithContext c msg) -> WithContext c msg
uiRow =
    Internal.uiRow


uiWrappedRow : List (Attribute msg) -> List (WithContext c msg) -> WithContext c msg
uiWrappedRow =
    Internal.uiWrappedRow


uiColumn : List (Attribute msg) -> List (WithContext c msg) -> WithContext c msg
uiColumn =
    Internal.uiColumn


uiParagraph : List (Attribute msg) -> List (WithContext context msg) -> WithContext context msg
uiParagraph =
    Internal.uiParagraph
