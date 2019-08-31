module UiFramework.Form.CheckboxField exposing
    ( Attributes
    , CheckboxField
    , defaultAttributes
    , form
    , view
    , withLabel
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
import UiFramework.Form.FormUtils exposing (getLabelRight, getPlaceholder, when, whenJust, withCommonAttrs)
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


type alias CheckboxField values =
    Field.Field Attributes Bool values


type Attributes
    = Attributes Options


type alias Options =
    { label : Maybe String }


defaultAttributes : Attributes
defaultAttributes =
    Attributes
        { label = Nothing
        }


withLabel : String -> Attributes -> Attributes
withLabel label (Attributes options) =
    Attributes { options | label = Just label }


form :
    (CheckboxField values -> field)
    -> Base.FieldConfig Attributes Bool values output
    -> Base.Form values output field
form =
    Base.field { isEmpty = always False }


type alias CheckboxFieldConfig msg =
    { onChange : Bool -> msg
    , onBlur : Maybe msg
    , disabled : Bool
    , value : Bool
    , error : Maybe Error
    , showError : Bool
    , attributes : Attributes
    }


view : CheckboxFieldConfig msg -> UiElement context msg
view { onChange, onBlur, value, disabled, error, showError, attributes } =
    let
        options =
            case attributes of
                Attributes opt ->
                    opt
    in
    Internal.fromElement
        (\context ->
            Input.checkbox
                ([ paddingXY 0 8 ]
                    |> withCommonAttrs showError error False onBlur context
                )
                { onChange = onChange
                , icon = Input.defaultCheckbox
                , checked = value
                , label =
                    getLabelRight (showError && error /= Nothing)
                        options.label
                        context.themeConfig.themeColor
                }
        )
