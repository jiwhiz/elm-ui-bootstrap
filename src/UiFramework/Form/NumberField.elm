module UiFramework.Form.NumberField exposing
    ( Attributes
    , NumberField
    , NumberFieldConfig
    , defaultAttributes
    , form
    , view
    , withHelpText
    , withLabel
    , withPlaceholder
    )

import Element exposing (text)
import Element.Input as Input
import Form.Base as Base
import Form.Error exposing (Error)
import Form.Field as Field
import Html.Attributes
import UiFramework.Form.FormUtils exposing (getLabelAbove, getPlaceholder, withCommonAttrs, withHtmlAttribute)
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


type alias NumberField values =
    Field.Field Attributes String values


type Attributes
    = Attributes Options


type alias Options =
    { label : Maybe String
    , placeholder : Maybe String
    , step : Maybe Float
    , min : Maybe Float
    , max : Maybe Float
    , helpText : Maybe String
    , mandatory : Bool
    , size : Maybe Size
    , prepend : Maybe String
    , append : Maybe String
    , readOnly : Bool
    , disabled : Bool
    }


defaultAttributes : Attributes
defaultAttributes =
    Attributes
        { label = Nothing
        , placeholder = Nothing
        , step = Nothing
        , min = Nothing
        , max = Nothing
        , helpText = Nothing
        , mandatory = True
        , size = Nothing
        , prepend = Nothing
        , append = Nothing
        , readOnly = False
        , disabled = False
        }


withLabel : String -> Attributes -> Attributes
withLabel label (Attributes options) =
    Attributes { options | label = Just label }


withPlaceholder : String -> Attributes -> Attributes
withPlaceholder placeholder (Attributes options) =
    Attributes { options | placeholder = Just placeholder }


withHelpText : String -> Attributes -> Attributes
withHelpText helpText (Attributes options) =
    Attributes { options | helpText = Just helpText }


form :
    (NumberField values -> field)
    -> Base.FieldConfig Attributes String values output
    -> Base.Form values output field
form =
    Base.field { isEmpty = String.isEmpty }


type alias NumberFieldConfig msg =
    { onChange : String -> msg
    , onBlur : Maybe msg
    , disabled : Bool
    , value : String
    , error : Maybe Error
    , showError : Bool
    , attributes : Attributes
    }


view : NumberFieldConfig msg -> UiElement context msg
view { onChange, onBlur, disabled, value, error, showError, attributes } =
    let
        options =
            case attributes of
                Attributes opt ->
                    opt

        stepAttr =
            options.step
                |> Maybe.map String.fromFloat
                |> Maybe.withDefault "any"
    in
    Internal.fromElement
        (\context ->
            Input.text
                ([]
                    |> withHtmlAttribute Html.Attributes.type_ (Just "number")
                    |> withHtmlAttribute Html.Attributes.step (Just stepAttr)
                    |> withHtmlAttribute (String.fromFloat >> Html.Attributes.max) options.max
                    |> withHtmlAttribute (String.fromFloat >> Html.Attributes.min) options.min
                    |> withCommonAttrs showError error disabled onBlur context
                )
                { onChange = onChange
                , text = value
                , placeholder = getPlaceholder context options.placeholder
                , label = getLabelAbove (showError && error /= Nothing) options.label context.themeConfig.globalConfig.themeColor
                }
        )
