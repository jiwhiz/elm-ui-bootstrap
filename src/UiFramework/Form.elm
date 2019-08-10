module UiFramework.Form exposing (asStateIn, layout, setState)

import Element
    exposing
        ( Attribute
        , Color
        , Element
        , below
        , centerY
        , el
        , fill
        , focused
        , height
        , htmlAttribute
        , inFront
        , moveRight
        , moveUp
        , none
        , padding
        , paddingXY
        , shrink
        , spacing
        , text
        , width
        )
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Form exposing (Form)
import Form.Error as Error exposing (Error)
import Form.View
    exposing
        ( CheckboxFieldConfig
        , FormConfig
        , FormListConfig
        , FormListItemConfig
        , Model
        , NumberFieldConfig
        , RadioFieldConfig
        , RangeFieldConfig
        , SelectFieldConfig
        , State(..)
        , TextFieldConfig
        , ViewConfig
        )
import Html
import Html.Attributes
import UiFramework.Button as Button
import UiFramework.ColorUtils exposing (hexToColor)
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg



{- Util functions for Form.View.Model record setter when used in nexted page model -}


setState : Form.View.State -> Form.View.Model values -> Form.View.Model values
setState state model =
    { model | state = state }


asStateIn : Form.View.Model values -> Form.View.State -> Form.View.Model values
asStateIn model state =
    setState state model



-- Copied from https://github.com/hecrj/composable-form/blob/master/examples/src/Form/View/Ui.elm


layout : ViewConfig values msg -> Form values msg -> Model values -> UiElement context msg
layout =
    Form.View.custom
        { form = form
        , textField = inputField Input.text
        , emailField = inputField Input.email
        , passwordField = passwordField
        , searchField = inputField Input.search
        , textareaField = textareaField
        , numberField = numberField
        , rangeField = rangeField
        , checkboxField = checkboxField
        , radioField = radioField
        , selectField = selectField
        , group = group
        , section = section
        , formList = formList
        , formListItem = formListItem
        }


form : FormConfig msg (UiElement context msg) -> UiElement context msg
form { onSubmit, action, loading, state, fields } =
    let
        label =
            if state == Loading then
                loading

            else
                action

        submitButton =
            Button.default
                |> Button.withMessage onSubmit
                |> Button.withLabel label
                |> Button.view

        formError =
            case state of
                Error error ->
                    Internal.fromElement (\context -> el [ Font.color (context.themeConfig.themeColor Danger) ] (text error))

                _ ->
                    Internal.uiNone
    in
    Internal.uiColumn [ spacing 16, width fill ] (fields ++ [ formError, submitButton ])


inputField :
    (List (Attribute msg)
     ->
        { onChange : String -> msg
        , text : String
        , placeholder : Maybe (Input.Placeholder msg)
        , label : Input.Label msg
        }
     -> Element msg
    )
    -> TextFieldConfig msg
    -> UiElement context msg
inputField input { onChange, onBlur, disabled, value, error, showError, attributes } =
    Internal.fromElement
        (\context ->
            input
                (viewAttributes context
                    |> withCommonAttrs showError error disabled onBlur context.themeConfig.themeColor
                )
                { onChange = onChange
                , text = value
                , placeholder = placeholder attributes
                , label = labelAbove (showError && error /= Nothing) attributes context.themeConfig.themeColor
                }
        )


passwordField : TextFieldConfig msg -> UiElement context msg
passwordField { onChange, onBlur, disabled, value, error, showError, attributes } =
    Internal.fromElement
        (\context ->
            Input.currentPassword
                (viewAttributes context
                    |> withCommonAttrs showError error disabled onBlur context.themeConfig.themeColor
                )
                { onChange = onChange
                , text = value
                , placeholder = placeholder attributes
                , label = labelAbove (showError && error /= Nothing) attributes context.themeConfig.themeColor
                , show = False
                }
        )


textareaField : TextFieldConfig msg -> UiElement context msg
textareaField { onChange, onBlur, disabled, value, error, showError, attributes } =
    Internal.fromElement
        (\context ->
            Input.multiline
                (viewAttributes context
                    |> withAttribute (height shrink)
                    |> withCommonAttrs showError error disabled onBlur context.themeConfig.themeColor
                )
                { onChange = onChange
                , text = value
                , placeholder = placeholder attributes
                , label = labelAbove (showError && error /= Nothing) attributes context.themeConfig.themeColor
                , spellcheck = True
                }
        )


numberField : NumberFieldConfig msg -> UiElement context msg
numberField { onChange, onBlur, disabled, value, error, showError, attributes } =
    Internal.fromElement
        (\context ->
            let
                stepAttr =
                    attributes.step
                        |> Maybe.map String.fromFloat
                        |> Maybe.withDefault "any"
            in
            Input.text
                (viewAttributes context
                    |> withHtmlAttribute Html.Attributes.type_ (Just "number")
                    |> withHtmlAttribute Html.Attributes.step (Just stepAttr)
                    |> withHtmlAttribute (String.fromFloat >> Html.Attributes.max) attributes.max
                    |> withHtmlAttribute (String.fromFloat >> Html.Attributes.min) attributes.min
                    |> withCommonAttrs showError error disabled onBlur context.themeConfig.themeColor
                )
                { onChange = onChange
                , text = value
                , placeholder = placeholder attributes
                , label = labelAbove (showError && error /= Nothing) attributes context.themeConfig.themeColor
                }
        )


rangeField : RangeFieldConfig msg -> UiElement context msg
rangeField { onChange, onBlur, disabled, value, error, showError, attributes } =
    Internal.fromElement
        (\context ->
            Input.text
                (viewAttributes context
                    |> withHtmlAttribute Html.Attributes.type_ (Just "range")
                    |> withHtmlAttribute (String.fromFloat >> Html.Attributes.step) (Just attributes.step)
                    |> withHtmlAttribute (String.fromFloat >> Html.Attributes.max) attributes.max
                    |> withHtmlAttribute (String.fromFloat >> Html.Attributes.min) attributes.min
                    |> withCommonAttrs showError error disabled onBlur context.themeConfig.themeColor
                )
                { onChange = fromString String.toFloat value >> onChange
                , text = value |> Maybe.map String.fromFloat |> Maybe.withDefault ""
                , placeholder = Nothing
                , label = labelAbove (showError && error /= Nothing) attributes context.themeConfig.themeColor
                }
        )


checkboxField : CheckboxFieldConfig msg -> UiElement context msg
checkboxField { onChange, onBlur, value, disabled, error, showError, attributes } =
    Internal.fromElement
        (\context ->
            Input.checkbox
                ([ paddingXY 0 8 ]
                    |> withCommonAttrs showError error False onBlur context.themeConfig.themeColor
                )
                { onChange = onChange
                , icon = Input.defaultCheckbox
                , checked = value
                , label =
                    labelRight (showError && error /= Nothing)
                        attributes
                        context.themeConfig.themeColor
                }
        )


radioField : RadioFieldConfig msg -> UiElement context msg
radioField { onChange, onBlur, disabled, value, error, showError, attributes } =
    Internal.fromElement
        (\context ->
            Input.radio
                ([ spacing 10, paddingXY 0 8 ]
                    |> withCommonAttrs showError error False onBlur context.themeConfig.themeColor
                )
                { onChange = onChange
                , selected = Just value
                , label = labelAbove (showError && error /= Nothing) attributes context.themeConfig.themeColor
                , options =
                    List.map
                        (\( val, name ) ->
                            Input.option val (text name)
                        )
                        attributes.options
                }
        )


selectField : SelectFieldConfig msg -> UiElement context msg
selectField { onChange, onBlur, disabled, value, error, showError, attributes } =
    -- There is no select field so use a radio instead
    radioField
        { onChange = onChange
        , onBlur = onBlur
        , disabled = disabled
        , value = value
        , error = error
        , showError = showError
        , attributes =
            { label = attributes.label
            , options = attributes.options
            }
        }


group : List (UiElement context msg) -> UiElement context msg
group =
    Internal.uiRow [ spacing 12 ]


section : String -> List (UiElement context msg) -> UiElement context msg
section title fields =
    Internal.uiColumn
        [ Border.solid
        , Border.width 1
        , padding 20
        , width fill
        , inFront
            (el
                [ moveUp 14
                , moveRight 10
                , Background.color (hexToColor "#000")
                , Font.color (hexToColor "#fff")
                , padding 6
                , width shrink
                ]
                (text title)
            )
        ]
        fields


formList : FormListConfig msg (UiElement context msg) -> UiElement context msg
formList { forms, add } =
    Internal.uiNone


formListItem : FormListItemConfig msg (UiElement context msg) -> UiElement context msg
formListItem { fields, delete } =
    Internal.uiNone


errorToString : Error -> String
errorToString error =
    case error of
        Error.RequiredFieldIsEmpty ->
            "This field is required"

        Error.ValidationFailed validationError ->
            validationError

        Error.External externalError ->
            externalError



-- Common Elements


placeholder : { r | placeholder : String } -> Maybe (Input.Placeholder msg)
placeholder attributes =
    Just
        (Input.placeholder []
            (el
                [ Font.color (hexToColor "#6c757d")
                ]
                (text attributes.placeholder)
            )
        )


labelCenterY :
    (List (Attribute msg) -> Element msg -> Input.Label msg)
    -> Bool
    -> { r | label : String }
    -> (Role -> Color)
    -> Input.Label msg
labelCenterY label showError attributes themeColor =
    el [ centerY ] (text attributes.label)
        |> label
            ([]
                |> when showError (Font.color <| themeColor Danger)
            )


labelLeft : Bool -> { r | label : String } -> (Role -> Color) -> Input.Label msg
labelLeft showError attributes themeColor =
    labelCenterY Input.labelLeft showError attributes themeColor


labelRight : Bool -> { r | label : String } -> (Role -> Color) -> Input.Label msg
labelRight showError attributes themeColor =
    labelCenterY Input.labelRight showError attributes themeColor


labelAbove : Bool -> { r | label : String } -> (Role -> Color) -> Input.Label msg
labelAbove showError attributes themeColor =
    text attributes.label
        |> Input.labelAbove
            ([ paddingXY 0 8 ]
                |> when showError (Font.color <| themeColor Danger)
            )


fieldError : (Role -> Color) -> String -> Element msg
fieldError themeColor error =
    el [ Font.color <| themeColor Danger ] (text error)



-- Helpers


viewAttributes : Internal.UiContextual context -> List (Attribute msg)
viewAttributes context =
    let
        config =
            context.themeConfig.inputConfig
    in
    [ paddingXY config.paddingX config.paddingY
    , Font.size <| config.fontSize
    , Font.color <| config.fontColor
    , Border.rounded <| config.borderRadius
    , Border.width <| 1
    , Border.solid
    , Border.color <| config.borderColor
    , focused [ Border.color <| config.focusedBorderColor ]
    ]


withAttribute : Attribute msg -> List (Attribute msg) -> List (Attribute msg)
withAttribute attr list =
    attr :: list


fromString : (String -> Maybe a) -> Maybe a -> String -> Maybe a
fromString parse currentValue input =
    if String.isEmpty input then
        Nothing

    else
        parse input
            |> Maybe.map Just
            |> Maybe.withDefault currentValue


withCommonAttrs :
    Bool
    -> Maybe Error
    -> Bool
    -> Maybe msg
    -> (Role -> Color)
    -> List (Attribute msg)
    -> List (Attribute msg)
withCommonAttrs showError error disabled onBlur themeColor attrs =
    attrs
        |> when showError
            (below
                (error
                    |> Maybe.map errorToString
                    |> Maybe.map (fieldError themeColor)
                    |> Maybe.withDefault none
                )
            )
        |> whenJust onBlur Events.onLoseFocus
        |> when disabled (Background.color <| hexToColor "#6c757d")


when : Bool -> Attribute msg -> List (Attribute msg) -> List (Attribute msg)
when test attr attrs =
    if test then
        attr :: attrs

    else
        attrs


whenJust :
    Maybe a
    -> (a -> Attribute msg)
    -> List (Attribute msg)
    -> List (Attribute msg)
whenJust maybeValue toAttribute attrs =
    Maybe.map (toAttribute >> (\attr -> attr :: attrs)) maybeValue
        |> Maybe.withDefault attrs


withHtmlAttribute :
    (a -> Html.Attribute msg)
    -> Maybe a
    -> List (Attribute msg)
    -> List (Attribute msg)
withHtmlAttribute toAttribute maybeValue attrs =
    Maybe.map (toAttribute >> htmlAttribute >> (\attr -> attr :: attrs)) maybeValue
        |> Maybe.withDefault attrs
