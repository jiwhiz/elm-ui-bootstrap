module UiFramework.Badge exposing
    ( Badge
    , default
    , simple
    , view
    , withExtraAttrs
    , withLabel
    , withPill
    , withRole
    )

import Element exposing (Attribute, el, paddingXY, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


type Badge context msg
    = Badge (Options msg)


type alias Options msg =
    { role : Role
    , label : String
    , pill : Bool
    , attributes : List (Attribute msg)
    }


withRole : Role -> Badge context msg -> Badge context msg
withRole role (Badge options) =
    Badge { options | role = role }


withLabel : String -> Badge context msg -> Badge context msg
withLabel label (Badge options) =
    Badge { options | label = label }


withPill : Badge context msg -> Badge context msg
withPill (Badge options) =
    Badge { options | pill = True }


withExtraAttrs : List (Attribute msg) -> Badge context msg -> Badge context msg
withExtraAttrs attributes (Badge options) =
    Badge { options | attributes = attributes }


default : Badge context msg
default =
    Badge
        { role = Primary
        , label = ""
        , pill = False
        , attributes = []
        }


simple : Role -> String -> UiElement context msg
simple role label =
    default
        |> withRole role
        |> withLabel label
        |> view



-- Rendering Badge


view : Badge context msg -> UiElement context msg
view (Badge options) =
    Internal.fromElement
        (\context ->
            el
                (viewAttributes context options)
                (text options.label)
        )


viewAttributes : Internal.UiContextual context -> Options msg -> List (Attribute msg)
viewAttributes context options =
    let
        config =
            context.themeConfig.badgeConfig

        ( paddingX, borderRadius ) =
            if options.pill then
                ( config.pillPaddingX, config.pillBorderRadius )

            else
                ( config.paddingX, config.borderRadius )
    in
    [ paddingXY paddingX config.paddingY
    , Font.center
    , Font.bold
    , Font.size 12 -- TODO 75% of parent font size
    , Font.color <| config.fontColor options.role
    , Border.rounded borderRadius
    , Border.width 0
    , Background.color <| config.backgroundColor options.role
    ]
        ++ options.attributes
