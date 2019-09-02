module UiFramework.Form.RadioField exposing
    ( Attributes
    , RadioField
    , RadioFieldConfig
    , defaultAttributes
    , form
    , view
    , withLabel
    , withOptions
    )

import Element exposing (paddingXY, spacing, text)
import Element.Input as Input
import Form.Base as Base
import Form.Error exposing (Error)
import Form.Field as Field
import UiFramework.Form.FormUtils exposing (getLabelAbove, withCommonAttrs)
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


type alias RadioField values =
    Field.Field Attributes String values


type Attributes
    = Attributes Options


type alias Options =
    { label : Maybe String
    , radioOptions : List ( String, String )
    }


defaultAttributes : Attributes
defaultAttributes =
    Attributes
        { label = Nothing
        , radioOptions = []
        }


withLabel : String -> Attributes -> Attributes
withLabel label (Attributes options) =
    Attributes { options | label = Just label }


withOptions : List ( String, String ) -> Attributes -> Attributes
withOptions radioOptions (Attributes options) =
    Attributes { options | radioOptions = radioOptions }


form :
    (RadioField values -> field)
    -> Base.FieldConfig Attributes String values output
    -> Base.Form values output field
form =
    Base.field { isEmpty = String.isEmpty }


type alias RadioFieldConfig msg =
    { onChange : String -> msg
    , onBlur : Maybe msg
    , disabled : Bool
    , value : String
    , error : Maybe Error
    , showError : Bool
    , attributes : Attributes
    }


view : RadioFieldConfig msg -> UiElement context msg
view { onChange, onBlur, disabled, value, error, showError, attributes } =
    let
        options =
            case attributes of
                Attributes opt ->
                    opt
    in
    Internal.fromElement
        (\context ->
            Input.radio
                ([ spacing 10, paddingXY 0 8 ]
                    |> withCommonAttrs showError error False onBlur context
                )
                { onChange = onChange
                , selected = Just value
                , label = getLabelAbove (showError && error /= Nothing) options.label context.themeConfig.globalConfig.themeColor
                , options =
                    List.map
                        (\( val, name ) ->
                            Input.option val (text name)
                        )
                        options.radioOptions
                }
        )
