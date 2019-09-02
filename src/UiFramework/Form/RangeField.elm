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
    )

import Element exposing (Attribute, centerY, el, fill, height, none, px, width)
import Element.Background as Background
import Element.Border as Border
import Element.Input as Input
import Form.Base as Base
import Form.Error exposing (Error)
import Form.Field as Field
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
    }


defaultAttributes : Attributes
defaultAttributes =
    Attributes
        { label = Nothing
        , step = Nothing
        , min = 0
        , max = 100
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
                (viewAttributes context
                    |> withCommonAttrs showError error disabled onBlur context
                )
                { onChange = onChange
                , label = getLabelAbove (showError && error /= Nothing) options.label context.themeConfig.globalConfig.themeColor
                , min = options.min
                , max = options.max
                , step = options.step
                , value = value
                , thumb =
                    Input.defaultThumb
                }
        )


viewAttributes : Internal.UiContextual context -> List (Attribute msg)
viewAttributes context =
    let
        config =
            context.themeConfig.rangeSliderConfig
    in
    [ height (px 30)
    , Element.behindContent
        (Element.el
            [ Element.width Element.fill
            , Element.height (Element.px config.trackHeight)
            , Element.centerY
            , Background.color config.trackBackgroundColor
            , Border.rounded config.trackBorderRadius
            ]
            Element.none
        )
    ]
