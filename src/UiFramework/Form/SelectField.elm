module UiFramework.Form.SelectField exposing
    ( Attributes
    , SelectField
    , SelectFieldConfig
    , defaultAttributes
    , form
    , view
    , withLabel
    , withOptions
    , withPlaceholder
    )

import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes
import Html.Events
import Json.Decode
import UiFramework.ColorUtils exposing (colorToHex)
import UiFramework.Configuration as Configuration
import UiFramework.Form.Base as Base
import UiFramework.Form.Error exposing (Error)
import UiFramework.Form.Field as Field
import UiFramework.Form.FormUtils exposing (getLabelAbove, withCommonAttrs)
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


type alias SelectField values =
    Field.Field Attributes String values


type Attributes
    = Attributes Options


type alias Options =
    { label : Maybe String
    , placeholder : Maybe String
    , size : Size
    , selectOptions : List ( String, String )
    }


defaultAttributes : Attributes
defaultAttributes =
    Attributes
        { label = Nothing
        , placeholder = Nothing
        , size = SizeDefault
        , selectOptions = []
        }


withLabel : String -> Attributes -> Attributes
withLabel label (Attributes options) =
    Attributes { options | label = Just label }


withPlaceholder : String -> Attributes -> Attributes
withPlaceholder placeholder (Attributes options) =
    Attributes { options | placeholder = Just placeholder }


withLarge : Attributes -> Attributes
withLarge (Attributes options) =
    Attributes { options | size = SizeLarge }


withSmall : Attributes -> Attributes
withSmall (Attributes options) =
    Attributes { options | size = SizeSmall }


withOptions : List ( String, String ) -> Attributes -> Attributes
withOptions selectOptions (Attributes options) =
    Attributes { options | selectOptions = selectOptions }


form :
    (SelectField values -> field)
    -> Base.FieldConfig Attributes String values output
    -> Base.Form values output field
form =
    Base.field { isEmpty = String.isEmpty }


type alias SelectFieldConfig msg =
    { onChange : String -> msg
    , onBlur : Maybe msg
    , disabled : Bool
    , value : String
    , error : Maybe Error
    , showError : Bool
    , attributes : Attributes
    }


view : SelectFieldConfig msg -> UiElement context msg
view config =
    let
        options =
            case config.attributes of
                Attributes opt ->
                    opt
    in
    Internal.fromElement
        (\context ->
            let
                labelElement =
                    case options.label of
                        Nothing ->
                            Element.none

                        Just label ->
                            Element.el [ Element.paddingXY 0 8 ] <| Element.text label

                inputElement =
                    Element.html <|
                        htmlSingleSelect config context options
            in
            Element.column
                [ Element.width Element.fill
                , Element.spacing 20
                , Element.paddingXY 0 8
                ]
                [ labelElement, inputElement ]
        )


htmlSingleSelect config context options =
    Html.select
        (selectHtmlAttributes config context options)
        (List.map (htmlOption config.value) options.selectOptions)


htmlOption : String -> ( String, String ) -> Html.Html msg
htmlOption selectedValue ( value, label ) =
    Html.option
        [ Html.Attributes.value value
        , Html.Attributes.selected (selectedValue == value)
        ]
        [ Html.text label ]


selectHtmlAttributes { onChange, onBlur, disabled, value, error, showError, attributes } context options =
    let
        inputConfig =
            context.themeConfig.inputConfig
    in
    [ Html.Attributes.style "width" "100%"
    , Html.Attributes.style "height" "calc(1.5em + .75rem + 2px)"
    , Html.Attributes.style "padding-top" (inputConfig.paddingY options.size |> toPx)
    , Html.Attributes.style "padding-right" (inputConfig.paddingX options.size |> toPx)
    , Html.Attributes.style "padding-bottom" (inputConfig.paddingY options.size |> toPx)
    , Html.Attributes.style "padding-left" (inputConfig.paddingX options.size |> toPx)
    , Html.Attributes.style "font-size" "1rem"
    , Html.Attributes.style "font-weight" "400"
    , Html.Attributes.style "line-height" "1.5"
    , Html.Attributes.style "color" (colorToHex inputConfig.fontColor)
    , Html.Attributes.style "vertical-align" "middle"
    , Html.Attributes.style "background-color" (colorToHex inputConfig.backgroundColor)
    , Html.Attributes.style "background-image" "url(\"data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 4 5'%3e%3cpath d='M2 0L0 2h4zm0 5L0 3h4z'/%3e%3c/svg%3e\")"
    , Html.Attributes.style "background-repeat" "no-repeat"
    , Html.Attributes.style "background-position" "right 12px center"
    , Html.Attributes.style "background-size" "8px 10px"
    , Html.Attributes.style "border-width" (inputConfig.borderWidth options.size |> toPx)
    , Html.Attributes.style "border-style" "solid"
    , Html.Attributes.style "border-color" (colorToHex inputConfig.borderColor)
    , Html.Attributes.style "border-radius" (inputConfig.borderRadius options.size |> toPx)
    , Html.Attributes.style "box-shadow" "inset 0 1px 2px rgba(#000, .075)"
    , Html.Attributes.style "appearance" "none"
    , Html.Attributes.style "-webkit-appearance" "none"
    , Html.Attributes.style "-moz-appearance" "none"
    , Html.Attributes.style "display" "inline-block"
    , Html.Events.on "change" (Json.Decode.map onChange Html.Events.targetValue)
    ]
        ++ (case onBlur of
                Just handler ->
                    [ Html.Events.onBlur handler ]

                Nothing ->
                    []
           )


toPx : Int -> String
toPx value =
    String.fromInt value ++ "px"
