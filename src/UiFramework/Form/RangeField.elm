module UiFramework.Form.RangeField exposing
    ( Attributes
    , RangeField
    , RangeFieldConfig
    , defaultAttributes
    , form
    , view
    , withLabel
    , withMax
    , withMin
    , withStep
    , withVertical
    )

import Element exposing (Attribute, centerY, el, fill, height, none, px, width)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import UiFramework.Form.Base as Base
import UiFramework.Form.Error exposing (Error)
import UiFramework.Form.Field as Field
import UiFramework.Form.FormUtils exposing (getLabelAbove, withCommonAttrs)
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


type alias RangeField values =
    Field.Field Attributes Float values


type Attributes
    = Attributes Options


type alias Options =
    { label : Maybe String
    , step : Maybe Float
    , min : Float
    , max : Float
    , verticalLength : Maybe Int
    }


defaultAttributes : Attributes
defaultAttributes =
    Attributes
        { label = Nothing
        , step = Nothing
        , min = 0
        , max = 100
        , verticalLength = Nothing
        }


withLabel : String -> Attributes -> Attributes
withLabel label (Attributes options) =
    Attributes { options | label = Just label }


withStep : Float -> Attributes -> Attributes
withStep step (Attributes options) =
    Attributes { options | step = Just step }


withMin : Float -> Attributes -> Attributes
withMin min (Attributes options) =
    Attributes { options | min = min }


withMax : Float -> Attributes -> Attributes
withMax max (Attributes options) =
    Attributes { options | max = max }


withVertical : Int -> Attributes -> Attributes
withVertical length (Attributes options) =
    Attributes { options | verticalLength = Just length }


form :
    (RangeField values -> field)
    -> Base.FieldConfig Attributes Float values output
    -> Base.Form values output field
form =
    Base.field { isEmpty = always False }


type alias RangeFieldConfig msg =
    { onChange : Float -> msg
    , onBlur : Maybe msg
    , disabled : Bool
    , value : Float
    , error : Maybe Error
    , showError : Bool
    , attributes : Attributes
    }


view : RangeFieldConfig msg -> UiElement context msg
view { onChange, onBlur, disabled, value, error, showError, attributes } =
    let
        options =
            case attributes of
                Attributes opt ->
                    opt
    in
    Internal.fromElement
        (\context ->
            Input.slider
                (viewAttributes options.verticalLength context
                    |> withCommonAttrs showError error disabled onBlur context
                )
                { onChange = onChange
                , label = getLabelAbove (showError && error /= Nothing) options.label context.themeConfig.globalConfig.themeColor
                , min = options.min
                , max = options.max
                , step = options.step
                , value = value
                , thumb = defaultThumb context
                }
        )


viewAttributes : Maybe Int -> Internal.UiContextual context -> List (Attribute msg)
viewAttributes verticalLength context =
    let
        config =
            context.themeConfig.rangeSliderConfig

        ( sliderAttrs, trackShapeAttrs ) =
            case verticalLength of
                Just length ->
                    ( [ Element.width (Element.px 30)
                      , Element.height (Element.px length)
                      ]
                    , [ Element.centerX
                      , Element.width (Element.px config.trackSize)
                      , Element.height (Element.px length)
                      ]
                    )

                Nothing ->
                    ( [ Element.width Element.fill
                      , Element.height (Element.px 30)
                      ]
                    , [ Element.centerY
                      , Element.width Element.fill
                      , Element.height (Element.px config.trackSize)
                      ]
                    )
    in
    Element.behindContent
        (Element.el
            ([ Background.color config.trackBackgroundColor
             , Border.rounded config.trackBorderRadius
             ]
                ++ trackShapeAttrs
            )
            Element.none
        )
        :: sliderAttrs


defaultThumb : Internal.UiContextual context -> Input.Thumb
defaultThumb context =
    let
        config =
            context.themeConfig.rangeSliderConfig
    in
    Input.thumb
        [ Element.width (Element.px config.thumbWidth)
        , Element.height (Element.px config.thumbHeight)
        , Border.rounded config.thumbBorderRadius
        , Border.width 0
        , Background.color config.thumbBackgroundColor
        ]
