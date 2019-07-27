module UiFramework.Colors exposing (alterColor, calculateWeight, colorLevel, contrastTextColor, darken, fromHex, fromHex8, getColor, hex2ToInt, hexToInt, hsla, lighten, limit, mixChannel, toHsla, transparent, weightedMix)

import Bitwise exposing (shiftLeftBy)
import Element exposing (Color, fromRgb, rgb255, rgba, toRgb)
import UiFramework.Types exposing (Role(..))


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
contrastTextColor : Color -> Color -> Color -> Color
contrastTextColor backgroundColor darkColor lightColor =
    let
        rgbRec =
            toRgb backgroundColor

        contrast =
            ((rgbRec.red * 299.0) + (rgbRec.green * 587.0) + (rgbRec.blue * 114.0)) * 256 / 1000.0
    in
    if contrast > 150.0 then
        darkColor

    else
        lightColor


colorLevel : Int -> Color -> Color
colorLevel level color =
    let
        baseColor =
            if level > 0 then
                getColor "#000"

            else
                getColor "#fff"
    in
    weightedMix baseColor color <| 0.08 * toFloat (abs level)


alterColor : Color -> Float -> Color
alterColor color alpha =
    let
        rgba =
            toRgb color
    in
    fromRgb
        { red = rgba.red
        , green = rgba.green
        , blue = rgba.blue
        , alpha = alpha
        }



-- Util functions
-- Copied from https://github.com/lucamug/elm-style-framework


getColor : String -> Color
getColor hexStr =
    fromHex hexStr |> Maybe.withDefault (rgb255 0 0 0)


fromHex : String -> Maybe Color
fromHex hexString =
    case String.toList hexString of
        [ '#', r, g, b ] ->
            fromHex8 ( r, r ) ( g, g ) ( b, b ) ( 'f', 'f' )

        [ r, g, b ] ->
            fromHex8 ( r, r ) ( g, g ) ( b, b ) ( 'f', 'f' )

        [ '#', r, g, b, a ] ->
            fromHex8 ( r, r ) ( g, g ) ( b, b ) ( a, a )

        [ r, g, b, a ] ->
            fromHex8 ( r, r ) ( g, g ) ( b, b ) ( a, a )

        [ '#', r1, r2, g1, g2, b1, b2 ] ->
            fromHex8 ( r1, r2 ) ( g1, g2 ) ( b1, b2 ) ( 'f', 'f' )

        [ r1, r2, g1, g2, b1, b2 ] ->
            fromHex8 ( r1, r2 ) ( g1, g2 ) ( b1, b2 ) ( 'f', 'f' )

        [ '#', r1, r2, g1, g2, b1, b2, a1, a2 ] ->
            fromHex8 ( r1, r2 ) ( g1, g2 ) ( b1, b2 ) ( a1, a2 )

        [ r1, r2, g1, g2, b1, b2, a1, a2 ] ->
            fromHex8 ( r1, r2 ) ( g1, g2 ) ( b1, b2 ) ( a1, a2 )

        _ ->
            Nothing


fromHex8 : ( Char, Char ) -> ( Char, Char ) -> ( Char, Char ) -> ( Char, Char ) -> Maybe Color
fromHex8 ( r1, r2 ) ( g1, g2 ) ( b1, b2 ) ( a1, a2 ) =
    Maybe.map4
        (\r g b a ->
            rgba
                (toFloat r / 255)
                (toFloat g / 255)
                (toFloat b / 255)
                (toFloat a / 255)
        )
        (hex2ToInt r1 r2)
        (hex2ToInt g1 g2)
        (hex2ToInt b1 b2)
        (hex2ToInt a1 a2)


hex2ToInt : Char -> Char -> Maybe Int
hex2ToInt c1 c2 =
    Maybe.map2 (\v1 v2 -> shiftLeftBy 4 v1 + v2) (hexToInt c1) (hexToInt c2)


hexToInt : Char -> Maybe Int
hexToInt char =
    case Char.toLower char of
        '0' ->
            Just 0

        '1' ->
            Just 1

        '2' ->
            Just 2

        '3' ->
            Just 3

        '4' ->
            Just 4

        '5' ->
            Just 5

        '6' ->
            Just 6

        '7' ->
            Just 7

        '8' ->
            Just 8

        '9' ->
            Just 9

        'a' ->
            Just 10

        'b' ->
            Just 11

        'c' ->
            Just 12

        'd' ->
            Just 13

        'e' ->
            Just 14

        'f' ->
            Just 15

        _ ->
            Nothing



-- Color manipulation util functions
-- Copied from https://github.com/noahzgordon/elm-color-extra


weightedMix : Color -> Color -> Float -> Color
weightedMix color1 color2 weight =
    let
        clampedWeight =
            clamp 0 1 weight

        c1 =
            toRgb color1

        c2 =
            toRgb color2

        w =
            calculateWeight c1.alpha c2.alpha clampedWeight

        rMixed =
            mixChannel w c1.red c2.red

        gMixed =
            mixChannel w c1.green c2.green

        bMixed =
            mixChannel w c1.blue c2.blue

        alphaMixed =
            c1.alpha * clampedWeight + c2.alpha * (1 - clampedWeight)
    in
    rgba rMixed gMixed bMixed alphaMixed


calculateWeight : Float -> Float -> Float -> Float
calculateWeight a1 a2 weight =
    let
        a =
            a1 - a2

        w1 =
            weight * 2 - 1

        w2 =
            if w1 * a == -1 then
                w1

            else
                (w1 + a) / (1 + w1 * a)
    in
    (w2 + 1) / 2


mixChannel : Float -> Float -> Float -> Float
mixChannel weight c1 c2 =
    c1 * weight + c2 * (1 - weight)


darken : Float -> Color -> Color
darken offset cl =
    let
        { hue, saturation, lightness, alpha } =
            toHsla cl
    in
    hsla hue saturation (limit (lightness - offset)) alpha


hsla : Float -> Float -> Float -> Float -> Color
hsla hue sat light alpha =
    let
        ( h, s, l ) =
            ( hue, sat, light )

        m2 =
            if l <= 0.5 then
                l * (s + 1)

            else
                l + s - l * s

        m1 =
            l * 2 - m2

        r =
            hueToRgb (h + 1 / 3)

        g =
            hueToRgb h

        b =
            hueToRgb (h - 1 / 3)

        hueToRgb h__ =
            let
                h_ =
                    if h__ < 0 then
                        h__ + 1

                    else if h__ > 1 then
                        h__ - 1

                    else
                        h__
            in
            if h_ * 6 < 1 then
                m1 + (m2 - m1) * h_ * 6

            else if h_ * 2 < 1 then
                m2

            else if h_ * 3 < 2 then
                m1 + (m2 - m1) * (2 / 3 - h_) * 6

            else
                m1
    in
    fromRgb
        { red = r
        , green = g
        , blue = b
        , alpha = alpha
        }


{-| Increase the lightning of a color
-}
lighten : Float -> Color -> Color
lighten offset cl =
    darken -offset cl


limit : Float -> Float
limit =
    clamp 0 1


toHsla : Color -> { hue : Float, saturation : Float, lightness : Float, alpha : Float }
toHsla color =
    let
        rgba =
            toRgb color

        ( r, g ) =
            ( rgba.red, rgba.green )

        ( b, a ) =
            ( rgba.blue, rgba.alpha )

        minColor =
            min r (min g b)

        maxColor =
            max r (max g b)

        h1 =
            if maxColor == r then
                (g - b) / (maxColor - minColor)

            else if maxColor == g then
                2 + (b - r) / (maxColor - minColor)

            else
                4 + (r - g) / (maxColor - minColor)

        h2 =
            h1 * (1 / 6)

        h3 =
            if isNaN h2 then
                0

            else if h2 < 0 then
                h2 + 1

            else
                h2

        l =
            (minColor + maxColor) / 2

        s =
            if minColor == maxColor then
                0

            else if l < 0.5 then
                (maxColor - minColor) / (maxColor + minColor)

            else
                (maxColor - minColor) / (2 - maxColor - minColor)
    in
    { hue = h3
    , saturation = s
    , lightness = l
    , alpha = a
    }


transparent : Color
transparent =
    rgba 0 0 0 0
