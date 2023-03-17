module UiFramework exposing
    ( UiContext
    , UiContextual
    , UiElement
    , WithContext
    , fromElement
    , toElement
    , uiColumn
    , uiContextualText
    , uiElement
    , uiLink
    , uiNone
    , uiParagraph
    , uiRow
    , uiText
    , uiWrappedRow
    , withContext
    )

import Element exposing (Attribute, Device, Element)
import UiFramework.Internal as Internal
import UiFramework.Configuration exposing (ThemeConfig)
import UiFramework.Types exposing (Role(..))

type alias UiContext =
    { device : Device
    , themeConfig : ThemeConfig
    , parentRole : Maybe Role
    }

type alias UiElement msg =
    Internal.WithContext (Internal.UiContextual UiContext) msg


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


withContext : (UiContextual c -> WithContext c msg) -> WithContext c msg
withContext =
    Internal.withContext


uiElement : List (Attribute msg) -> WithContext c msg -> WithContext c msg
uiElement = 
    Internal.uiElement

uiNone : WithContext c msg
uiNone =
    Internal.uiNone


uiText : String -> WithContext c msg
uiText =
    Internal.uiText


uiContextualText : (UiContextual c -> String) -> WithContext c msg
uiContextualText =
    Internal.uiContextualText


uiLink : { url : String, label : String } -> WithContext c msg
uiLink =
    Internal.uiLink


uiRow : List (Attribute msg) -> List (WithContext c msg) -> WithContext c msg
uiRow =
    Internal.uiRow


uiWrappedRow : List (Attribute msg) -> List (WithContext c msg) -> WithContext c msg
uiWrappedRow =
    Internal.uiWrappedRow


uiColumn : List (Attribute msg) -> List (WithContext c msg) -> WithContext c msg
uiColumn =
    Internal.uiColumn


uiParagraph : List (Attribute msg) -> List (WithContext c msg) -> WithContext c msg
uiParagraph =
    Internal.uiParagraph
