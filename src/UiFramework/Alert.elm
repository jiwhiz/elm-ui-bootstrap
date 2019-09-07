module UiFramework.Alert exposing
    ( Alert
    , default
    , externalLink
    , link
    , simple
    , simpleDanger
    , simpleDark
    , simpleInfo
    , simpleLight
    , simplePrimary
    , simpleSecondary
    , simpleSuccess
    , simpleWarning
    , view
    , withChild
    , withDismissButton
    , withExtraAttrs
    , withLarge
    , withRole
    , withSmall
    )

import Element exposing (Attribute, el, fill, none, paddingXY, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


type Alert context msg
    = Alert (Options context msg)


type alias Options context msg =
    { role : Role
    , size : Size
    , dismissable : Maybe msg
    , attributes : List (Attribute msg)
    , child : UiElement context msg
    }


withRole : Role -> Alert context msg -> Alert context msg
withRole role (Alert options) =
    Alert { options | role = role }


withLarge : Alert context msg -> Alert context msg
withLarge (Alert options) =
    Alert { options | size = SizeLarge }


withSmall : Alert context msg -> Alert context msg
withSmall (Alert options) =
    Alert { options | size = SizeSmall }


withDismissButton : msg -> Alert context msg -> Alert context msg
withDismissButton msg (Alert options) =
    Alert { options | dismissable = Just msg }


withExtraAttrs : List (Attribute msg) -> Alert context msg -> Alert context msg
withExtraAttrs attributes (Alert options) =
    Alert { options | attributes = attributes }


withChild : UiElement context msg -> Alert context msg -> Alert context msg
withChild child (Alert options) =
    Alert { options | child = child }


defaultOptions : Options context msg
defaultOptions =
    { role = Primary
    , size = SizeDefault
    , dismissable = Nothing
    , attributes = []
    , child = Internal.fromElement (\_ -> none)
    }


default : Alert context msg
default =
    Alert defaultOptions



-- Simple alert builder functions


simple : Role -> UiElement context msg -> UiElement context msg
simple role child =
    default
        |> withRole role
        |> withChild child
        |> view True


simplePrimary : UiElement context msg -> UiElement context msg
simplePrimary =
    simple Primary


simpleSecondary : UiElement context msg -> UiElement context msg
simpleSecondary =
    simple Secondary


simpleSuccess : UiElement context msg -> UiElement context msg
simpleSuccess =
    simple Success


simpleInfo : UiElement context msg -> UiElement context msg
simpleInfo =
    simple Info


simpleWarning : UiElement context msg -> UiElement context msg
simpleWarning =
    simple Warning


simpleDanger : UiElement context msg -> UiElement context msg
simpleDanger =
    simple Danger


simpleLight : UiElement context msg -> UiElement context msg
simpleLight =
    simple Light


simpleDark : UiElement context msg -> UiElement context msg
simpleDark =
    simple Dark



-- Rendering Alert


view : Bool -> Alert context msg -> UiElement context msg
view visible (Alert options) =
    if visible then
        Internal.fromElement
            (\context ->
                el (viewAttributes context options) <|
                    Internal.toElement
                        { context | parentRole = Just options.role }
                        options.child
            )

    else
        Internal.uiNone


viewAttributes : Internal.UiContextual context -> Options context msg -> List (Attribute msg)
viewAttributes context options =
    let
        config =
            context.themeConfig.alertConfig

        closeButton =
            case options.dismissable of
                Nothing ->
                    []

                Just msg ->
                    [ Element.inFront <|
                        Input.button
                            [ Element.alignTop
                            , Element.alignRight
                            , Element.paddingXY config.paddingX config.paddingY
                            ]
                            { onPress = Just msg
                            , label = Element.text "×"
                            }
                    ]
    in
    [ width fill
    , paddingXY config.paddingX config.paddingY
    , Font.alignLeft
    , Font.size <| config.fontSize options.size
    , Font.color <| config.fontColor options.role
    , Border.rounded <| config.borderRadius options.size
    , Border.width <| config.borderWidth options.size
    , Border.solid
    , Border.color <| config.borderColor options.role
    , Background.color <| config.backgroundColor options.role
    ]
        ++ closeButton
        ++ options.attributes



-- Alert Link


link :
    { onPress : Maybe msg
    , label : UiElement context msg
    }
    -> UiElement context msg
link { onPress, label } =
    Internal.fromElement
        (\context ->
            let
                role =
                    context.parentRole |> Maybe.withDefault Primary

                fontColor =
                    context.themeConfig.alertConfig.fontColor role
            in
            Input.button
                [ Font.bold, Font.color fontColor ]
                { onPress = onPress
                , label = Internal.toElement context label
                }
        )


externalLink :
    { url : String
    , label : UiElement context msg
    }
    -> UiElement context msg
externalLink { url, label } =
    Internal.fromElement
        (\context ->
            let
                role =
                    context.parentRole |> Maybe.withDefault Primary

                fontColor =
                    context.themeConfig.alertConfig.fontColor role
            in
            Element.newTabLink
                [ Font.bold, Font.color fontColor ]
                { url = url
                , label = Internal.toElement context label
                }
        )
