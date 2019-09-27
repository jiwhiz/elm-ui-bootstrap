module UiFramework.Form.WebForm exposing (..)

import Element exposing (Attribute, el, fill, spacing, text, width)
import Element.Font as Font
import FontAwesome.Solid
import Form.Error exposing (Error)
import Set exposing (Set)
import UiFramework.Alert as Alert
import UiFramework.Button as Button
import UiFramework.Form.CheckboxField as CheckboxField
import UiFramework.Form.ComposableForm as ComposableForm exposing (Form)
import UiFramework.Form.NumberField as NumberField
import UiFramework.Form.RadioField as RadioField
import UiFramework.Form.RangeField as RangeField
import UiFramework.Form.SelectField as SelectField
import UiFramework.Form.TextField as TextField
import UiFramework.Icon as Icon
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


type WebForm values context msg
    = WebForm (WebFormOptions values context msg)


type alias WebFormOptions values context msg =
    { onChange : WebFormState values -> msg
    , content : Form values msg
    , submitButton : Button.Button context msg
    , submitLabel : Maybe String
    , loadingLabel : Maybe String
    , loadingIcon : Icon.Icon msg
    , validationStrategy : ValidationStrategy
    , displayFormError : String -> UiElement context msg
    , attributes : List (Attribute msg)
    }


type ValidationStrategy
    = ValidateOnSubmit
    | ValidateOnBlur


withSubmitButton : Button.Button context msg -> WebForm values context msg -> WebForm values context msg
withSubmitButton button (WebForm options) =
    WebForm { options | submitButton = button }


withSubmitLabel : String -> WebForm values context msg -> WebForm values context msg
withSubmitLabel label (WebForm options) =
    WebForm { options | submitLabel = Just label }


withLoadingLabel : String -> WebForm values context msg -> WebForm values context msg
withLoadingLabel label (WebForm options) =
    WebForm { options | loadingLabel = Just label }


withValidationStrategy : ValidationStrategy -> WebForm values context msg -> WebForm values context msg
withValidationStrategy validationStrategy (WebForm options) =
    WebForm { options | validationStrategy = validationStrategy }


withDisplayFormError : (String -> UiElement context msg) -> WebForm values context msg -> WebForm values context msg
withDisplayFormError displayFormError (WebForm options) =
    WebForm { options | displayFormError = displayFormError }


withExtraAttrs : List (Attribute msg) -> WebForm values context msg -> WebForm values context msg
withExtraAttrs attributes (WebForm options) =
    WebForm { options | attributes = attributes }



-- builder functions


simpleForm : (WebFormState values -> msg) -> Form values msg -> WebForm values context msg
simpleForm onChange content =
    WebForm
        { onChange = onChange
        , content = content
        , submitButton = Button.default |> Button.withLabel "Submit"
        , submitLabel = Nothing
        , loadingLabel = Nothing
        , loadingIcon = Icon.fontAwesome FontAwesome.Solid.spinner |> Icon.withSpin |> Icon.withSize Icon.Lg
        , validationStrategy = ValidateOnSubmit
        , displayFormError = defaultDisplayFormError
        , attributes = []
        }


defaultDisplayFormError : String -> UiElement context msg
defaultDisplayFormError error =
    Alert.simpleDanger <| Internal.uiParagraph [] [ Internal.uiText error ]


view :
    WebFormState values
    -> WebForm values context msg
    -> UiElement context msg
view state (WebForm options) =
    let
        { fields, result } =
            Debug.log "ComposableForm.fill result:" <|
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
                    options.displayFormError error

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
            options.submitButton
                |> Button.withMessage onSubmit
                |> (case ( state.status, options.submitLabel, options.loadingLabel ) of
                        ( Loading, _, Just loadingLabel ) ->
                            Button.withLabel loadingLabel
                                >> Button.withDisabled
                                >> Button.withIcon options.loadingIcon

                        ( Loading, _, Nothing ) ->
                            Button.withDisabled >> Button.withIcon options.loadingIcon

                        ( _, Just submitLabel, _ ) ->
                            Button.withLabel submitLabel

                        _ ->
                            identity
                   )
                |> Button.view
    in
    Internal.uiColumn
        ([ spacing 16, width fill ] ++ options.attributes)
        (formError :: renderedFields ++ [ submitButton ])


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
