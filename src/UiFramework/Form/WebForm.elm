module UiFramework.Form.WebForm exposing (..)

import Element exposing (el, fill, spacing, text, width)
import Element.Font as Font
import Form.Error exposing (Error)
import Set exposing (Set)
import UiFramework.Button as Button
import UiFramework.Form.CheckboxField as CheckboxField
import UiFramework.Form.ComposableForm as ComposableForm exposing (Form)
import UiFramework.Form.NumberField as NumberField
import UiFramework.Form.RadioField as RadioField
import UiFramework.Form.RangeField as RangeField
import UiFramework.Form.SelectField as SelectField
import UiFramework.Form.TextField as TextField
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


type alias WebFormState values =
    { values : values
    , status : WebFormStatus
    , errorTracking : ErrorTracking
    }


type WebFormStatus
    = Idle
    | Loading
    | Error String
    | Success String


type ErrorTracking
    = ErrorTracking { showAllErrors : Bool, showFieldError : Set String }


idle : values -> WebFormState values
idle values =
    { values = values
    , status = Idle
    , errorTracking =
        ErrorTracking
            { showAllErrors = False
            , showFieldError = Set.empty
            }
    }


type WebForm values msg
    = WebForm (WebFormOptions values msg)


type alias WebFormOptions values msg =
    { onChange : WebFormState values -> msg
    , actionLabel : String
    , loadingLabel : Maybe String
    , validationStrategy : ValidationStrategy
    , content : Form values msg
    }


type ValidationStrategy
    = ValidateOnSubmit
    | ValidateOnBlur



-- builder functions


simpleForm : (WebFormState values -> msg) -> Form values msg -> String -> WebForm values msg
simpleForm onChange content label =
    WebForm
        { onChange = onChange
        , actionLabel = label
        , loadingLabel = Nothing
        , validationStrategy = ValidateOnSubmit
        , content = content
        }


withLoadingLabel : String -> WebForm values msg -> WebForm values msg
withLoadingLabel label (WebForm options) =
    WebForm { options | loadingLabel = Just label }


view :
    WebFormState values
    -> WebForm values msg
    -> UiElement context msg
view state (WebForm options) =
    let
        { fields, result } =
            ComposableForm.fill options.content state.values

        errorTracking =
            (\(ErrorTracking e) -> e) state.errorTracking

        onBlur =
            case options.validationStrategy of
                ValidateOnSubmit ->
                    Nothing

                ValidateOnBlur ->
                    Just
                        (\label ->
                            options.onChange
                                { state
                                    | errorTracking =
                                        ErrorTracking
                                            { errorTracking
                                                | showFieldError =
                                                    Set.insert label errorTracking.showFieldError
                                            }
                                }
                        )

        showError label =
            errorTracking.showAllErrors || Set.member label errorTracking.showFieldError

        renderedFields =
            List.map
                (renderField
                    { onChange = \values -> options.onChange { state | values = values }
                    , onBlur = onBlur
                    , disabled = state.status == Loading
                    , showError = showError
                    }
                )
                fields

        formError =
            case state.status of
                Error error ->
                    Internal.fromElement (\context -> el [ Font.color (context.themeConfig.themeColor Danger) ] (text error))

                _ ->
                    Internal.uiNone

        onSubmit =
            case result of
                Ok msg ->
                    if state.status == Loading then
                        Nothing

                    else
                        Just msg

                Err _ ->
                    if errorTracking.showAllErrors then
                        Nothing

                    else
                        Just
                            (options.onChange
                                { state
                                    | errorTracking =
                                        ErrorTracking
                                            { errorTracking | showAllErrors = True }
                                }
                            )

        submitButton =
            Button.default
                |> Button.withMessage onSubmit
                |> Button.withLabel
                    (if state.status == Loading then
                        options.loadingLabel |> Maybe.withDefault ""
                        -- add spinner icon?

                     else
                        options.actionLabel
                    )
                |> Button.view
    in
    Internal.uiColumn
        [ spacing 20, width fill ]
        (renderedFields ++ [ formError, submitButton ])


type alias FieldConfig values msg =
    { onChange : values -> msg
    , onBlur : Maybe (String -> msg)
    , disabled : Bool
    , showError : String -> Bool
    }


renderField :
    FieldConfig values msg
    -> ComposableForm.FilledField values
    -> UiElement context msg
renderField ({ onChange, onBlur, disabled, showError } as fieldConfig) field =
    let
        blur label =
            Maybe.map (\onBlurEvent -> onBlurEvent label) onBlur
    in
    case field.state of
        ComposableForm.Text type_ { attributes, value, update } ->
            TextField.view
                { onChange = update >> onChange
                , onBlur = blur ""
                , disabled = field.isDisabled || disabled
                , value = value
                , error = field.error
                , showError = showError "attributes.label"
                , attributes = attributes
                }

        ComposableForm.Number { attributes, value, update } ->
            NumberField.view
                { onChange = update >> onChange
                , onBlur = blur "attributes.label"
                , disabled = field.isDisabled || disabled
                , value = value
                , error = field.error
                , showError = showError "attributes.label"
                , attributes = attributes
                }

        ComposableForm.Range { attributes, value, update } ->
            RangeField.view
                { onChange = update >> onChange
                , onBlur = blur "attributes.label"
                , disabled = field.isDisabled || disabled
                , value = value
                , error = field.error
                , showError = showError "attributes.label"
                , attributes = attributes
                }

        ComposableForm.Checkbox { attributes, value, update } ->
            CheckboxField.view
                { onChange = update >> onChange
                , onBlur = blur ""
                , disabled = field.isDisabled || disabled
                , value = value
                , error = field.error
                , showError = showError "attributes.label"
                , attributes = attributes
                }

        ComposableForm.Radio { attributes, value, update } ->
            RadioField.view
                { onChange = update >> onChange
                , onBlur = blur "attributes.label"
                , disabled = field.isDisabled || disabled
                , value = value
                , error = field.error
                , showError = showError "attributes.label"
                , attributes = attributes
                }

        ComposableForm.Select { attributes, value, update } ->
            SelectField.view
                { onChange = update >> onChange
                , onBlur = blur ""
                , disabled = field.isDisabled || disabled
                , value = value
                , error = field.error
                , showError = showError "attributes.label"
                , attributes = attributes
                }

        ComposableForm.Group fields ->
            fields
                |> List.map (maybeIgnoreChildError field.error >> renderField { fieldConfig | disabled = field.isDisabled || disabled })
                |> Internal.uiRow [ spacing 12 ]


maybeIgnoreChildError : Maybe Error -> ComposableForm.FilledField values -> ComposableForm.FilledField values
maybeIgnoreChildError maybeParentError field =
    case maybeParentError of
        Just _ ->
            field

        Nothing ->
            { field | error = Nothing }
