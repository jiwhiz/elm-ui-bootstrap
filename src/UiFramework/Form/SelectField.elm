module UiFramework.Form.SelectField exposing
    ( Attributes
    , SelectField
    , SelectFieldConfig
    , defaultAttributes
    , form
    , view
    , withLabel
    , withOptions
    , withPlaceholder
    )

import Element exposing (Attribute, Color, Element, centerY, el, fill, height, none, paddingXY, shrink, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Form.Base as Base
import Form.Error as Error exposing (Error)
import Form.Field as Field
import Html
import Html.Attributes
import UiFramework.Form.FormUtils exposing (getLabelAbove, getPlaceholder, when, whenJust, withCommonAttrs)
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


type alias SelectField values =
    Field.Field Attributes String values


type Attributes
    = Attributes Options


type alias Options =
    { label : Maybe String
    , placeholder : Maybe String
    , selectOptions : List ( String, String )
    }


defaultAttributes : Attributes
defaultAttributes =
    Attributes
        { label = Nothing
        , placeholder = Nothing
        , selectOptions = []
        }


withLabel : String -> Attributes -> Attributes
withLabel label (Attributes options) =
    Attributes { options | label = Just label }


withPlaceholder : String -> Attributes -> Attributes
withPlaceholder placeholder (Attributes options) =
    Attributes { options | placeholder = Just placeholder }


withOptions : List ( String, String ) -> Attributes -> Attributes
withOptions selectOptions (Attributes options) =
    Attributes { options | selectOptions = selectOptions }


form :
    (SelectField values -> field)
    -> Base.FieldConfig Attributes String values output
    -> Base.Form values output field
form =
    Base.field { isEmpty = String.isEmpty }


type alias SelectFieldConfig msg =
    { onChange : String -> msg
    , onBlur : Maybe msg
    , disabled : Bool
    , value : String
    , error : Maybe Error
    , showError : Bool
    , attributes : Attributes
    }


view : SelectFieldConfig msg -> UiElement context msg
view { onChange, onBlur, disabled, value, error, showError, attributes } =
    let
        options =
            case attributes of
                Attributes opt ->
                    opt
    in
    Internal.fromElement
        (\context ->
            -- There is no select field so use a radio instead
            Input.radio
                ([ spacing 10, paddingXY 0 8 ]
                    |> withCommonAttrs showError error False onBlur context
                )
                { onChange = onChange
                , selected = Just value
                , label = getLabelAbove (showError && error /= Nothing) options.label context.themeConfig.themeColor
                , options =
                    List.map
                        (\( val, name ) ->
                            Input.option val (text name)
                        )
                        options.selectOptions
                }
        )
