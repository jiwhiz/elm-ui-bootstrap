module UiFramework.Form.FormUtils exposing (..)

import Element exposing (Attribute, Color, Element, el, none, paddingXY, text)
import Element.Background as Background
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Html
import UiFramework.Form.Error as Error exposing (Error)
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


withCommonAttrs :
    Bool
    -> Maybe Error
    -> Bool
    -> Maybe msg
    -> Internal.UiContextual context
    -> List (Attribute msg)
    -> List (Attribute msg)
withCommonAttrs showError error disabled onBlur context attrs =
    let
        themeColor =
            context.themeConfig.globalConfig.themeColor

        config =
            context.themeConfig.inputConfig
    in
    attrs
        |> when showError
            (Element.below
                (error
                    |> Maybe.map errorToString
                    |> Maybe.map (fieldError themeColor)
                    |> Maybe.withDefault none
                )
            )
        |> whenJust onBlur Events.onLoseFocus
        |> when disabled (Background.color config.disabledBackgroundColor)


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
    Maybe.map (toAttribute >> Element.htmlAttribute >> (\attr -> attr :: attrs)) maybeValue
        |> Maybe.withDefault attrs


errorToString : Error -> String
errorToString error =
    case error of
        Error.RequiredFieldIsEmpty ->
            "This field is required"

        Error.ValidationFailed validationError ->
            validationError

        Error.External externalError ->
            externalError


getPlaceholder : Internal.UiContextual context -> Maybe String -> Maybe (Input.Placeholder msg)
getPlaceholder context =
    let
        config =
            context.themeConfig.inputConfig
    in
    Maybe.map
        (\placeholder ->
            Input.placeholder []
                (el
                    [ Font.color config.placeholderColor
                    ]
                    (text placeholder)
                )
        )


getLabelAbove : Bool -> Maybe String -> (Role -> Color) -> Input.Label msg
getLabelAbove showError maybeLabel themeColor =
    case maybeLabel of
        Nothing ->
            Input.labelHidden ""

        Just label ->
            Input.labelAbove
                ([ paddingXY 0 8 ]
                    |> when showError (Font.color <| themeColor Danger)
                )
                (text label)


getLabelRight : Bool -> Maybe String -> (Role -> Color) -> Input.Label msg
getLabelRight showError maybeLabel themeColor =
    case maybeLabel of
        Nothing ->
            Input.labelHidden ""

        Just label ->
            Input.labelRight
                ([ paddingXY 0 8 ]
                    |> when showError (Font.color <| themeColor Danger)
                )
                (text label)


fieldError : (Role -> Color) -> String -> Element msg
fieldError themeColor error =
    el [ Font.color <| themeColor Danger ] (text error)
