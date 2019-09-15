module UiFramework.Icon exposing
    ( Animation(..)
    , Atom(..)
    , Icon(..)
    , Options
    , Size(..)
    , UiElement
    , fontAwesome
    , lay
    , simple
    , textIcon
    , view
    , viewAsElement
    , withBorder
    , withColor
    , withExtraAttributes
    , withFixedWidth
    , withFlipH
    , withFlipV
    , withGrow
    , withHtmlAttributes
    , withInverse
    , withPosDown
    , withPosLeft
    , withPosRight
    , withPosUp
    , withPulse
    , withRotation
    , withShrink
    , withSize
    , withSpin
    , withSvgAttributes
    )

import Element exposing (Attribute, Color, Element, html)
import FontAwesome.Attributes
import FontAwesome.Icon
import FontAwesome.Layering
import FontAwesome.Transforms
import Html exposing (Html)
import Html.Attributes
import Svg
import Svg.Attributes
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role)



-- TYPES


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


type Icon msg
    = Icon (Options msg)


type alias Options msg =
    { atom : Atom msg
    , attributes : List (Attribute msg)
    , svgAttributes : List (Svg.Attribute msg)
    , htmlAttributes : List (Html.Attribute msg)
    , size : Size
    , animation : Animation
    , border : Bool
    , fixedWidth : Bool
    , inverse : Bool
    , transformations : List Transformation -- ordered first to last
    }


type Atom msg
    = FontAwesome FontAwesome.Icon.Icon
    | Text String
    | Layered (List (Icon msg))
    | Counter String


type Size
    = Xs
    | Sm
    | Lg
    | Num Int
    | Regular


type Animation
    = Spin
    | Pulse
    | NoAnimation



-- Transformations


type Transformation
    = Flip Flip
    | Scale Scale
    | Position Position
    | Rotate Float


type Flip
    = Horizontal
    | Vertical
    | NoFlip


type Scale
    = Shrink Float
    | Grow Float
    | NoScale


type Position
    = Up Float
    | Down Float
    | Left Float
    | Right Float
    | NoPosition



-- INITIALIZATIONS


defaultOptions : Options msg
defaultOptions =
    { atom = Layered []
    , attributes = []
    , svgAttributes = []
    , htmlAttributes = []
    , size = Regular
    , animation = NoAnimation
    , border = False
    , fixedWidth = False
    , inverse = False
    , transformations = []
    }


fontAwesome : FontAwesome.Icon.Icon -> Icon msg
fontAwesome fontAwesomeIcon =
    Icon { defaultOptions | atom = FontAwesome fontAwesomeIcon }


textIcon : String -> Icon msg
textIcon str =
    Icon { defaultOptions | atom = Text str }



-- COMPOSITIONS


{-| Second Icon is the one piping into the function - and the one we need to evaluate
icon2
|> Icon.lay icon1

    lay : Icon1 -> Icon2 -> Icon3

-}
lay : Icon msg -> Icon msg -> Icon msg
lay icon1 (Icon option2) =
    case option2.atom of
        Layered layers ->
            -- add icon to layers
            Icon { option2 | atom = Layered (layers ++ [ icon1 ]) }

        nonLayered ->
            Icon { defaultOptions | atom = Layered [ Icon option2, icon1 ] }


simple : FontAwesome.Icon.Icon -> UiElement context msg
simple icon =
    fontAwesome icon
        |> view


viewAsHtml : Icon msg -> Html msg
viewAsHtml (Icon options) =
    let
        -- Attributes
        size =
            case options.size of
                Xs ->
                    Just FontAwesome.Attributes.xs

                Sm ->
                    Just FontAwesome.Attributes.sm

                Lg ->
                    Just FontAwesome.Attributes.lg

                Num 2 ->
                    Just FontAwesome.Attributes.fa2x

                Num 3 ->
                    Just FontAwesome.Attributes.fa3x

                Num 4 ->
                    Just FontAwesome.Attributes.fa4x

                Num 5 ->
                    Just FontAwesome.Attributes.fa5x

                Num 6 ->
                    Just FontAwesome.Attributes.fa6x

                Num 7 ->
                    Just FontAwesome.Attributes.fa7x

                Num 8 ->
                    Just FontAwesome.Attributes.fa8x

                Num 9 ->
                    Just FontAwesome.Attributes.fa9x

                Num 10 ->
                    Just FontAwesome.Attributes.fa10x

                _ ->
                    Nothing

        animation =
            case options.animation of
                Spin ->
                    Just FontAwesome.Attributes.spin

                Pulse ->
                    Just FontAwesome.Attributes.pulse

                NoAnimation ->
                    Nothing

        border =
            case options.border of
                True ->
                    Just FontAwesome.Attributes.border

                _ ->
                    Nothing

        fixedWidth =
            case options.fixedWidth of
                True ->
                    Just FontAwesome.Attributes.fw

                _ ->
                    Nothing

        inverse =
            case options.inverse of
                True ->
                    Just FontAwesome.Attributes.inverse

                _ ->
                    Nothing

        attributes =
            [ size, animation, border, fixedWidth, inverse ]
                |> List.filterMap identity
                |> (++) options.svgAttributes

        -- Transformations
        transformations =
            List.filterMap
                (\t ->
                    case t of
                        Flip Horizontal ->
                            Just FontAwesome.Transforms.flipH

                        Flip Vertical ->
                            Just FontAwesome.Transforms.flipV

                        Scale (Shrink amount) ->
                            Just <| FontAwesome.Transforms.shrink amount

                        Scale (Grow amount) ->
                            Just <| FontAwesome.Transforms.grow amount

                        Position (Up a) ->
                            Just <| FontAwesome.Transforms.up a

                        Position (Down a) ->
                            Just <| FontAwesome.Transforms.down a

                        Position (Left a) ->
                            Just <| FontAwesome.Transforms.left a

                        Position (Right a) ->
                            Just <| FontAwesome.Transforms.right a

                        Rotate amount ->
                            Just <| FontAwesome.Transforms.rotate amount

                        _ ->
                            Nothing
                )
                options.transformations
    in
    Html.span options.htmlAttributes <|
        List.singleton <|
            case options.atom of
                FontAwesome icon ->
                    FontAwesome.Icon.viewTransformed attributes transformations icon

                Text str ->
                    FontAwesome.Layering.textTransformed attributes transformations str

                Layered layers ->
                    FontAwesome.Layering.layers
                        attributes
                        (List.map viewAsHtml layers)

                _ ->
                    Html.text ""


viewAsElement : Icon msg -> Element msg
viewAsElement (Icon options) =
    viewAsHtml (Icon options)
        |> html
        |> Element.el [Element.width Element.shrink]



-- |> Element.el options.attributes


view : Icon msg -> UiElement context msg
view icon =
    Internal.fromElement
        (\context ->
            viewAsElement icon
        )



-- ELEMENT ATTRIBUTES - used in the el wrapper


withExtraAttributes : List (Attribute msg) -> Icon msg -> Icon msg
withExtraAttributes attrs (Icon options) =
    Icon { options | attributes = attrs }


withSvgAttributes : List (Svg.Attribute msg) -> Icon msg -> Icon msg
withSvgAttributes attrs (Icon options) =
    Icon { options | svgAttributes = attrs }


withHtmlAttributes : List (Html.Attribute msg) -> Icon msg -> Icon msg
withHtmlAttributes attrs (Icon options) =
    Icon { options | htmlAttributes = attrs }



-- FONTAWESOME ATTRIBUTES


withSize : Size -> Icon msg -> Icon msg
withSize size (Icon options) =
    Icon
        { options
            | size =
                case size of
                    Num int ->
                        Num <| clamp 2 10 int

                    other ->
                        other
        }


withSpin : Icon msg -> Icon msg
withSpin (Icon options) =
    Icon { options | animation = Spin }


withPulse : Icon msg -> Icon msg
withPulse (Icon options) =
    Icon { options | animation = Pulse }


withBorder : Icon msg -> Icon msg
withBorder (Icon options) =
    Icon { options | border = True }


withFixedWidth : Icon msg -> Icon msg
withFixedWidth (Icon options) =
    Icon { options | fixedWidth = True }


withInverse : Icon msg -> Icon msg
withInverse (Icon options) =
    Icon { options | inverse = True }



-- my own attribute thing lol


withColor : String -> Icon msg -> Icon msg
withColor color (Icon options) =
    Icon { options | htmlAttributes = Html.Attributes.style "color" color :: options.htmlAttributes }



-- TRANSFORMATIONS


withRotation : Float -> Icon msg -> Icon msg
withRotation degree =
    addTransformation (Rotate degree)


withFlipV : Icon msg -> Icon msg
withFlipV =
    addTransformation (Flip Vertical)


withFlipH : Icon msg -> Icon msg
withFlipH =
    addTransformation (Flip Horizontal)


withShrink : Float -> Icon msg -> Icon msg
withShrink amount =
    addTransformation (Scale <| Shrink amount)


withGrow : Float -> Icon msg -> Icon msg
withGrow amount =
    addTransformation (Scale <| Grow amount)


withPosUp : Float -> Icon msg -> Icon msg
withPosUp amount =
    addTransformation (Position <| Up amount)


withPosDown : Float -> Icon msg -> Icon msg
withPosDown amount =
    addTransformation (Position <| Down amount)


withPosLeft : Float -> Icon msg -> Icon msg
withPosLeft amount =
    addTransformation (Position <| Left amount)


withPosRight : Float -> Icon msg -> Icon msg
withPosRight amount =
    addTransformation (Position <| Right amount)


addTransformation : Transformation -> Icon msg -> Icon msg
addTransformation t (Icon options) =
    Icon { options | transformations = options.transformations ++ [ t ] }
