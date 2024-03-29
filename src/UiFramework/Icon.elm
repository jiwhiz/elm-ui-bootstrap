module UiFramework.Icon exposing
    ( Icon
    , Size(..)
    , fontAwesome
    , lay
    , simple
    , textIcon
    , view
    , viewAsElement
    , withBackground
    , withBorder
    , withColor
    , withCounter
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
    )

import Element exposing (Attribute, Color, Element, html)
import FontAwesome.Attributes
import FontAwesome exposing(Icon)
import FontAwesome.Layering
import FontAwesome.Transforms as Transforms
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
    { base : BaseIcon msg
    , attributes : List (Attribute msg)
    , htmlAttributes : List (Html.Attribute msg)
    , size : Size
    , animation : Animation
    , border : Bool
    , fixedWidth : Bool
    , inverse : Bool
    , transformations : List Transforms.Transform
    , counter : Maybe { text : String, attrs : List (Html.Attribute msg) }
    }


type BaseIcon msg
    = FontAwesome (FontAwesome.Icon FontAwesome.WithoutId)
    | Text String
    | Layered (List (Icon msg))


type Size
    = Xs
    | Sm
    | Lg
    | Num Int
    | Default


type Animation
    = Spin
    | Pulse
    | NoAnimation



-- INITIALIZATIONS


defaultOptions : Options msg
defaultOptions =
    { base = Layered []
    , attributes = []
    , htmlAttributes = []
    , size = Default
    , animation = NoAnimation
    , border = False
    , fixedWidth = False
    , inverse = False
    , transformations = []
    , counter = Nothing
    }


fontAwesome : FontAwesome.Icon FontAwesome.WithoutId -> Icon msg
fontAwesome fontAwesomeIcon =
    Icon { defaultOptions | base = FontAwesome fontAwesomeIcon }


textIcon : String -> Icon msg
textIcon str =
    Icon { defaultOptions | base = Text str }


withExtraAttributes : List (Attribute msg) -> Icon msg -> Icon msg
withExtraAttributes attrs (Icon options) =
    Icon { options | attributes = attrs }


withHtmlAttributes : List (Html.Attribute msg) -> Icon msg -> Icon msg
withHtmlAttributes attrs (Icon options) =
    Icon { options | htmlAttributes = attrs }


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


withColor : String -> Icon msg -> Icon msg
withColor color (Icon options) =
    Icon { options | htmlAttributes = Html.Attributes.style "color" color :: options.htmlAttributes }


withBackground : String -> Icon msg -> Icon msg
withBackground color (Icon options) =
    Icon { options | htmlAttributes = Html.Attributes.style "background" color :: options.htmlAttributes }


withCounter : { text : String, attrs : List (Html.Attribute msg) } -> Icon msg -> Icon msg
withCounter counter (Icon options) =
    Icon { options | counter = Just counter }



-- TRANSFORMATIONS


withRotation : Float -> Icon msg -> Icon msg
withRotation degree =
    addTransformation (Transforms.rotate degree)


withFlipV : Icon msg -> Icon msg
withFlipV =
    addTransformation Transforms.flipV


withFlipH : Icon msg -> Icon msg
withFlipH =
    addTransformation Transforms.flipH


withShrink : Float -> Icon msg -> Icon msg
withShrink amount =
    addTransformation (Transforms.shrink amount)


withGrow : Float -> Icon msg -> Icon msg
withGrow amount =
    addTransformation (Transforms.grow amount)


withPosUp : Float -> Icon msg -> Icon msg
withPosUp amount =
    addTransformation (Transforms.up amount)


withPosDown : Float -> Icon msg -> Icon msg
withPosDown amount =
    addTransformation (Transforms.down amount)


withPosLeft : Float -> Icon msg -> Icon msg
withPosLeft amount =
    addTransformation (Transforms.left amount)


withPosRight : Float -> Icon msg -> Icon msg
withPosRight amount =
    addTransformation (Transforms.right amount)


addTransformation : Transforms.Transform -> Icon msg -> Icon msg
addTransformation t (Icon options) =
    Icon { options | transformations = options.transformations ++ [ t ] }



-- COMPOSITIONS


{-| Second Icon is the one piping into the function - and the one we need to evaluate
icon2
|> Icon.lay icon1

    lay : Icon1 -> Icon2 -> Icon3

-}
lay : Icon msg -> Icon msg -> Icon msg
lay icon1 (Icon option2) =
    case option2.base of
        Layered layers ->
            -- add icon to layers
            Icon { option2 | base = Layered (layers ++ [ icon1 ]) }

        _ ->
            Icon { defaultOptions | base = Layered [ Icon option2, icon1 ] }


simple : FontAwesome.Icon FontAwesome.WithoutId -> UiElement context msg
simple icon =
    fontAwesome icon
        |> view


{-| Internal rendering function
-}
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
                    Just FontAwesome.Attributes.spinPulse

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
                |> (++) options.htmlAttributes
    in
    case options.counter of
        Just { text, attrs } ->
            case options.base of
                FontAwesome icon ->
                    FontAwesome.Layering.layers
                        attributes
                        [ FontAwesome.transform options.transformations icon |> FontAwesome.view
                        , FontAwesome.Layering.counter attrs text
                        ]

                Text str ->
                    FontAwesome.Layering.layers
                        attributes
                        [ FontAwesome.Layering.textTransformed [] options.transformations str
                        , FontAwesome.Layering.counter attrs text
                        ]

                Layered layers ->
                    FontAwesome.Layering.layers
                        attributes
                        (FontAwesome.Layering.counter attrs text :: List.map viewAsHtml layers)

        Nothing ->
            case options.base of
                FontAwesome icon ->
                    FontAwesome.transform options.transformations icon |> FontAwesome.view

                Text str ->
                    FontAwesome.Layering.textTransformed attributes options.transformations str

                Layered layers ->
                    FontAwesome.Layering.layers
                        attributes
                        (List.map viewAsHtml layers)


viewAsElement : Icon msg -> Element msg
viewAsElement (Icon options) =
    viewAsHtml (Icon options)
        |> html
        |> Element.el options.attributes


view : Icon msg -> UiElement context msg
view icon =
    Internal.fromElement
        (\context ->
            viewAsElement icon
        )
