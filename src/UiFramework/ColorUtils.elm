module UiFramework.ColorUtils exposing
    ( alterColor
    , colorLevel
    , contrastTextColor
    , darken
    , hexToColor
    , lighten
    , transparent
    )

import Color
import Color.Convert
import Color.Manipulate
import Element


{-| Copy from Bootstrap 4.x
// Color contrast
@function color-yiq($color, $dark: $yiq-text-dark, $light: $yiq-text-light) {
$r: red($color);
$g: green($color);
$b: blue($color);

     $yiq: (($r * 299) + ($g * 587) + ($b * 114)) / 1000;

     @return if($yiq >= $yiq-contrasted-threshold, $dark, $light);

}

-}
contrastTextColor : Element.Color -> Element.Color -> Element.Color -> Element.Color
contrastTextColor backgroundColor darkColor lightColor =
    let
        rgbRec =
            Element.toRgb backgroundColor

        contrast =
            ((rgbRec.red * 299.0) + (rgbRec.green * 587.0) + (rgbRec.blue * 114.0)) * 256 / 1000.0
    in
    if contrast > 150.0 then
        darkColor

    else
        lightColor


colorLevel : Int -> Element.Color -> Element.Color
colorLevel level color =
    let
        baseColor =
            if level > 0 then
                hexToColor "#000"

            else
                hexToColor "#fff"
    in
    fromColor <|
        Color.Manipulate.weightedMix (toColor baseColor) (toColor color) <|
            0.08
                * toFloat (abs level)


alterColor : Float -> Element.Color -> Element.Color
alterColor alpha color =
    let
        rgba =
            Element.toRgb color
    in
    Element.fromRgb
        { red = rgba.red
        , green = rgba.green
        , blue = rgba.blue
        , alpha = alpha
        }


transparent : Element.Color
transparent =
    Element.rgba 0 0 0 0



--  Copied from lucamug/style-framework


{-| Convert an Element.Color into a Color.Color
-}
toColor : Element.Color -> Color.Color
toColor elementColor =
    let
        cl =
            Element.toRgb elementColor
    in
    Color.rgba cl.red cl.green cl.blue cl.alpha


{-| Convert a Color.Color into an Element.Color
-}
fromColor : Color.Color -> Element.Color
fromColor elementColor =
    let
        cl =
            Color.toRgba elementColor
    in
    Element.rgba cl.red cl.green cl.blue cl.alpha


{-| Increase the lightning of a color
-}
lighten : Float -> Element.Color -> Element.Color
lighten offset elementColor =
    let
        cl =
            toColor elementColor
    in
    fromColor <| Color.Manipulate.lighten offset cl


{-| Decrease the lightning of a color
-}
darken : Float -> Element.Color -> Element.Color
darken offset elementColor =
    let
        cl =
            toColor elementColor
    in
    fromColor <| Color.Manipulate.darken offset cl


{-| Converts a string to a color.
-}
hexToColor : String -> Element.Color
hexToColor string =
    let
        cl =
            Color.Convert.hexToColor string
    in
    fromColor <| Result.withDefault (Color.rgb 0 0 0) cl
