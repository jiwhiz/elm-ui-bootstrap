module UiFramework.Typography exposing (h1, h2, h3, h4, h5, h6, textExtraSmall, textLead, textSmall)

{-|


# Functions

@docs h1, h2, h3, h4, h5, h6, introspection, textExtraSmall, textLead, textSmall

-}

import Element exposing (alignLeft, paddingEach)
import Element.Font as Font
import Element.Region as Region
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


{-| -}
h1 : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
h1 listAttr element =
    heading SizeH1 listAttr element


{-| -}
h2 : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
h2 =
    heading SizeH2


{-| -}
h3 : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
h3 =
    heading SizeH3


{-| -}
h4 : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
h4 =
    heading SizeH4


{-| -}
h5 : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
h5 =
    heading SizeH5


{-| -}
h6 : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
h6 =
    heading SizeH6


{-| -}
textLead : List (Element.Attribute msg) -> UiElement context msg -> UiElement context msg
textLead =
    textSection SizeLead


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
                 , Font.bold
                 ]
                    ++ attributes
                )
                (Internal.toElement context child)
        )


type FontLevel
    = SizeH1
    | SizeH2
    | SizeH3
    | SizeH4
    | SizeH5
    | SizeH6
    | SizeLead
    | SizeSmall
    | SizeExtraSmall


headingLevel : FontLevel -> Int
headingLevel level =
    case level of
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

        SizeSmall ->
            14

        SizeExtraSmall ->
            12
