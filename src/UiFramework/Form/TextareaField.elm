module UiFramework.Form.TextareaField exposing
    ( Attributes
    , TextareaField
    , TextareaFieldConfig
    , defaultAttributes
    , form
    , view
    , withHelpText
    , withLabel
    , withNoResize
    , withPlaceholder
    , withRows
    , withSpellcheck
    )

import Element exposing (Attribute, alignBottom, column, el, fill, height, none, paddingEach, paddingXY, px, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import UiFramework.Configuration as Configuration exposing (defaultFontSize)
import UiFramework.Form.Base as Base
import UiFramework.Form.Error exposing (Error)
import UiFramework.Form.Field as Field
import UiFramework.Form.FormUtils exposing (errorToString, getLabelAbove, getPlaceholder, when, whenJust, withCommonAttrs, withHtmlAttribute)
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


type alias TextareaField values =
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
    , rows : Int
    , noResize : Bool
    , spellcheck : Bool
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
        , rows = 2
        , noResize = False
        , spellcheck = False
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


withRows : Int -> Attributes -> Attributes
withRows rows (Attributes options) =
    Attributes { options | rows = rows }


withNoResize : Attributes -> Attributes
withNoResize (Attributes options) =
    Attributes { options | noResize = True }


withSpellcheck : Attributes -> Attributes
withSpellcheck (Attributes options) =
    Attributes { options | spellcheck = True }


form :
    (TextareaField values -> field)
    -> Base.FieldConfig Attributes String values output
    -> Base.Form values output field
form =
    Base.field { isEmpty = String.isEmpty }


type alias TextareaFieldConfig msg =
    { onChange : String -> msg
    , onBlur : Maybe msg
    , disabled : Bool
    , value : String
    , error : Maybe Error
    , showError : Bool
    , attributes : Attributes
    }


view :
    TextareaFieldConfig msg
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
                    Input.multiline
                        (inputAttributes context
                            |> whenJust onBlur Events.onLoseFocus
                            |> when disabled (Background.color config.disabledBackgroundColor)
                            |> when options.noResize (Element.htmlAttribute <| Html.Attributes.style "resize" "none")
                            |> withHtmlAttribute Html.Attributes.rows (Just options.rows)
                        )
                        { onChange = onChange
                        , text = value
                        , placeholder = getPlaceholder context options.placeholder
                        , label = getLabelAbove (showError && error /= Nothing) options.label themeColor
                        , spellcheck = options.spellcheck
                        }

                errorMessage =
                    case ( showError, error ) of
                        ( True, Just err ) ->
                            el
                                [ Font.color <| themeColor Danger
                                , paddingXY 0 (config.paddingY SizeDefault // 2)
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
                                    , paddingXY 0 (config.paddingY SizeDefault // 2)
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
        config : Configuration.InputConfig
        config =
            context.themeConfig.inputConfig
    in
    [ paddingXY (config.paddingX SizeDefault) (config.paddingY SizeDefault)

    --, alignBottom
    , Font.size config.fontSize
    , Font.color config.fontColor

    --, Font.center
    , Border.rounded <| config.borderRadius SizeDefault
    , Border.width <| config.borderWidth SizeDefault
    , Border.solid
    , Border.color config.borderColor
    , Element.focused [ Border.color config.focusedBorderColor ]
    ]
