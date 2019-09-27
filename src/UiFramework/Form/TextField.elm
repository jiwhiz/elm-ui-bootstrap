module UiFramework.Form.TextField exposing
    ( Attributes
    , TextField
    , TextFieldConfig
    , defaultAttributes
    , form
    , view
    , withHelpText
    , withLabel
    , withPlaceholder
    )

import Element exposing (Attribute, alignBottom, column, el, fill, height, none, paddingEach, paddingXY, px, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Form.Base as Base
import Form.Error exposing (Error)
import Form.Field as Field
import UiFramework.Configuration exposing (defaultFontSize)
import UiFramework.Form.FormUtils exposing (errorToString, getLabelAbove, getPlaceholder, when, whenJust, withCommonAttrs)
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


type alias TextField values =
    Field.Field Attributes String values


type Attributes
    = Attributes Options


type alias Options =
    { label : Maybe String
    , placeholder : Maybe String
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
    (TextField values -> field)
    -> Base.FieldConfig Attributes String values output
    -> Base.Form values output field
form =
    Base.field { isEmpty = String.isEmpty }


type alias TextFieldConfig msg =
    { onChange : String -> msg
    , onBlur : Maybe msg
    , disabled : Bool
    , value : String
    , error : Maybe Error
    , showError : Bool
    , attributes : Attributes
    }


view :
    TextFieldConfig msg
    -> UiElement context msg
view { onChange, onBlur, disabled, value, error, showError, attributes } =
    let
        options =
            case attributes of
                Attributes opt ->
                    opt
    in
    Internal.fromElement
        (\context ->
            let
                themeColor =
                    context.themeConfig.globalConfig.themeColor

                config =
                    context.themeConfig.inputConfig

                inputField =
                    Input.text
                        (inputAttributes context
                            |> whenJust onBlur Events.onLoseFocus
                            |> when disabled (Background.color config.disabledBackgroundColor)
                        )
                        { onChange = onChange
                        , text = value
                        , placeholder = getPlaceholder context options.placeholder
                        , label = getLabelAbove (showError && error /= Nothing) options.label themeColor
                        }

                errorMessage =
                    case ( showError, error ) of
                        ( True, Just err ) ->
                            el
                                [ Font.color <| themeColor Danger
                                , paddingXY 0 (config.paddingY // 2)
                                ]
                                (text <| errorToString err)

                        _ ->
                            none

                helpMessage =
                    options.helpText
                        |> Maybe.map
                            (\helpText ->
                                el
                                    [ Font.color config.placeholderColor
                                    , Font.size <| defaultFontSize SizeSmall
                                    , paddingXY 0 (config.paddingY // 2)
                                    ]
                                    (text helpText)
                            )
                        |> Maybe.withDefault none
            in
            column
                [ width fill ]
                [ inputField
                , errorMessage
                , helpMessage
                ]
        )


inputAttributes : Internal.UiContextual context -> List (Attribute msg)
inputAttributes context =
    let
        config =
            context.themeConfig.inputConfig
    in
    [ paddingXY config.paddingX config.paddingY
    , height (px 40)
    , alignBottom
    , Font.size config.fontSize
    , Font.color config.fontColor
    , Font.center
    , Border.rounded <| config.borderRadius SizeDefault
    , Border.width <| config.borderWidth SizeDefault
    , Border.solid
    , Border.color config.borderColor
    , Element.focused [ Border.color config.focusedBorderColor ]
    ]
