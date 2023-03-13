module UiFramework.Form.PasswordField exposing
    ( Attributes
    , PasswordField
    , PasswordFieldConfig
    , defaultAttributes
    , form
    , view
    , withAutoFillCurrent
    , withHelpText
    , withLabel
    , withPlaceholder
    )

import Element
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Html.Attributes
import UiFramework.Configuration as Configuration
import UiFramework.Form.Base as Base
import UiFramework.Form.Error exposing (Error)
import UiFramework.Form.Field as Field
import UiFramework.Form.FormUtils exposing (errorToString, getLabelAbove, getPlaceholder, when, whenJust, withCommonAttrs, withHtmlAttribute)
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


type alias PasswordField values =
    Field.Field Attributes String values


type Attributes
    = Attributes Options


type alias Options =
    { label : Maybe String
    , placeholder : Maybe String
    , helpText : Maybe String
    , mandatory : Bool
    , size : Maybe Size
    , disabled : Bool
    , show : Bool
    , current : Bool
    }


defaultAttributes : Attributes
defaultAttributes =
    Attributes
        { label = Nothing
        , placeholder = Nothing
        , helpText = Nothing
        , mandatory = True
        , size = Nothing
        , disabled = False
        , show = False
        , current = False
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


withShowPassword : Attributes -> Attributes
withShowPassword (Attributes options) =
    Attributes { options | show = True }


withAutoFillCurrent : Attributes -> Attributes
withAutoFillCurrent (Attributes options) =
    Attributes { options | current = True }


form :
    (PasswordField values -> field)
    -> Base.FieldConfig Attributes String values output
    -> Base.Form values output field
form =
    Base.field { isEmpty = String.isEmpty }


type alias PasswordFieldConfig msg =
    { onChange : String -> msg
    , onBlur : Maybe msg
    , disabled : Bool
    , value : String
    , error : Maybe Error
    , showError : Bool
    , attributes : Attributes
    }


view : PasswordFieldConfig msg -> UiElement context msg
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

                fieldFunction =
                    if options.current then
                        Input.currentPassword

                    else
                        Input.newPassword

                inputField =
                    fieldFunction
                        (inputAttributes context
                            |> whenJust onBlur Events.onLoseFocus
                            |> when disabled (Background.color config.disabledBackgroundColor)
                        )
                        { onChange = onChange
                        , text = value
                        , placeholder = getPlaceholder context options.placeholder
                        , label = getLabelAbove (showError && error /= Nothing) options.label themeColor
                        , show = options.show
                        }

                errorMessage =
                    case ( showError, error ) of
                        ( True, Just err ) ->
                            Element.el
                                [ Font.color <| themeColor Danger
                                , Element.paddingXY 0 (config.paddingY SizeDefault // 2)
                                ]
                                (Element.text <| errorToString err)

                        _ ->
                            Element.none

                helpMessage =
                    options.helpText
                        |> Maybe.map
                            (\helpText ->
                                Element.el
                                    [ Font.color config.placeholderColor
                                    , Font.size <| Configuration.defaultFontSize SizeSmall
                                    , Element.paddingXY 0 (config.paddingY SizeDefault // 2)
                                    ]
                                    (Element.text helpText)
                            )
                        |> Maybe.withDefault Element.none
            in
            Element.column
                [ Element.width Element.fill ]
                [ inputField
                , errorMessage
                , helpMessage
                ]
        )


inputAttributes : Internal.UiContextual context -> List (Element.Attribute msg)
inputAttributes context =
    let
        config : Configuration.InputConfig
        config =
            context.themeConfig.inputConfig
    in
    [ Element.paddingXY (config.paddingX SizeDefault) (config.paddingY SizeDefault)
    , Element.height (Element.px 40)
    , Element.alignBottom
    , Font.size config.fontSize
    , Font.color config.fontColor
    , Font.center
    , Border.rounded <| config.borderRadius SizeDefault
    , Border.width <| config.borderWidth SizeDefault
    , Border.solid
    , Border.color config.borderColor
    , Element.focused [ Border.color config.focusedBorderColor ]
    ]
