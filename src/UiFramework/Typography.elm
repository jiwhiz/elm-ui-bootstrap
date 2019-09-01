module UiFramework.Typography exposing (display1, display2, display3, display4, h1, h2, h3, h4, h5, h6, textExtraSmall, textLead, textSmall, span)

{-|


# Functions

@docs display1, display2, display3, display4, h1, h2, h3, h4, h5, h6, introspection, textExtraSmall, textLead, textSmall

-}

import Element exposing (alignLeft, paddingEach)
import Element.Font as Font
import Element.Region as Region
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


span : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
span attrs =
    textSection SizeRegular attrs


display1 : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
display1 listAttr =
    heading Display1 (Font.light :: listAttr)


display2 : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
display2 listAttr =
    heading Display2 (Font.light :: listAttr)


display3 : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
display3 listAttr =
    heading Display3 (Font.light :: listAttr)


display4 : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
display4 listAttr =
    heading Display4 (Font.light :: listAttr)


{-| -}
h1 : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
h1 listAttr =
    heading SizeH1 (Font.bold :: listAttr)


{-| -}
h2 : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
h2 listAttr =
    heading SizeH2 (Font.bold :: listAttr)


{-| -}
h3 : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
h3 listAttr =
    heading SizeH3 (Font.bold :: listAttr)


{-| -}
h4 : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
h4 listAttr =
    heading SizeH4 (Font.bold :: listAttr)


{-| -}
h5 : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
h5 listAttr =
    heading SizeH5 (Font.bold :: listAttr)


{-| -}
h6 : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
h6 listAttr =
    heading SizeH6 (Font.bold :: listAttr)


{-| -}
textLead : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
textLead listAttr =
    textSection SizeLead (Font.light :: listAttr)


{-| -}
textSmall : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
textSmall =
    textSection SizeSmall


{-| -}
textExtraSmall : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
textExtraSmall =
    textSection SizeExtraSmall


textSection :
    FontLevel
    -> List (Element.Attr () msg)
    -> UiElement context msg
    -> UiElement context msg
textSection level attributes child =
    Internal.fromElement
        (\context ->
            Element.el
                ((Font.size <| fontSize level)
                    :: attributes
                )
                (Internal.toElement context child)
        )


heading :
    FontLevel
    -> List (Element.Attribute msg)
    -> UiElement context msg
    -> UiElement context msg
heading level attributes child =
    Internal.fromElement
        (\context ->
            Element.el
                ([ Region.heading <| headingLevel level
                 , Font.size <| fontSize level
                 , paddingEach { top = 0, right = 0, bottom = 0, left = 0 }
                 , alignLeft
                 ]
                    ++ attributes
                )
                (Internal.toElement context child)
        )


type FontLevel
    = Display1
    | Display2
    | Display3
    | Display4
    | SizeH1
    | SizeH2
    | SizeH3
    | SizeH4
    | SizeH5
    | SizeH6
    | SizeLead
    | SizeRegular
    | SizeSmall
    | SizeExtraSmall


headingLevel : FontLevel -> Int
headingLevel level =
    case level of
        Display1 ->
            1

        Display2 ->
            1

        Display3 ->
            1

        Display4 ->
            1

        SizeH1 ->
            1

        SizeH2 ->
            2

        SizeH3 ->
            3

        SizeH4 ->
            4

        SizeH5 ->
            5

        SizeH6 ->
            6

        _ ->
            5


fontSize : FontLevel -> Int
fontSize level =
    case level of
        Display1 ->
            96

        Display2 ->
            88

        Display3 ->
            72

        Display4 ->
            56

        SizeH1 ->
            32

        SizeH2 ->
            28

        SizeH3 ->
            24

        SizeH4 ->
            20

        SizeH5 ->
            16

        SizeH6 ->
            14

        SizeLead ->
            24

        SizeRegular ->
            17

        SizeSmall ->
            14

        SizeExtraSmall ->
            12
