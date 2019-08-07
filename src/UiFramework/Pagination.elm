module UiFramework.Pagination exposing
    ( Item(..)
    , Pagination
    , PaginationState
    , default
    , view
    , withExtraAttrs
    , withItems
    , withLarge
    , withSmall
    , withStringLabels
    )

import Element exposing (Attribute, Device, Element, el, fill, height, paddingXY, pointer, row, spacing, text, width)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import FontAwesome.Solid
import UiFramework.Configuration exposing (ThemeConfig)
import UiFramework.Icon as Icon
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


type alias PaginationState =
    { numberOfSlices : Int
    , currentSliceNumber : Int -- start from 1
    }


type alias Context context =
    { context
        | device : Device
        , themeConfig : ThemeConfig
        , parentRole : Maybe Role
        , state : PaginationState
    }


type alias UiElement context msg =
    Internal.WithContext (Context context) msg


{-| Pagination type
-}
type Pagination context msg
    = Pagination (Options msg)


type alias Options msg =
    { selectedMsg : Int -> msg
    , labels : LabelType
    , ellipsis : Icon.Icon
    , size : Size
    , items : List Item
    , attributes : List (Attribute msg)
    }


type LabelType
    = IconLabels
        { first : Icon.Icon
        , previous : Icon.Icon
        , next : Icon.Icon
        , last : Icon.Icon
        }
    | StringLabels
        { first : String
        , previous : String
        , next : String
        , last : String
        }


withStringLabels :
    { first : String
    , previous : String
    , next : String
    , last : String
    }
    -> Pagination context msg
    -> Pagination context msg
withStringLabels labels (Pagination options) =
    Pagination { options | labels = StringLabels labels }


withLarge : Pagination context msg -> Pagination context msg
withLarge (Pagination options) =
    Pagination { options | size = SizeLarge }


withSmall : Pagination context msg -> Pagination context msg
withSmall (Pagination options) =
    Pagination { options | size = SizeSmall }


withExtraAttrs :
    List (Attribute msg)
    -> Pagination context msg
    -> Pagination context msg
withExtraAttrs attributes (Pagination options) =
    Pagination { options | attributes = attributes }


withItems :
    List Item
    -> Pagination context msg
    -> Pagination context msg
withItems items (Pagination options) =
    Pagination { options | items = items }


{-| Pagination Item type
-}
type Item
    = NumberItem Int
    | EllipsisItem


default : (Int -> msg) -> Pagination context msg
default selectedMsg =
    Pagination
        { selectedMsg = selectedMsg
        , labels =
            IconLabels
                { first = FontAwesome.Solid.stepBackward
                , previous = FontAwesome.Solid.caretLeft
                , next = FontAwesome.Solid.caretRight
                , last = FontAwesome.Solid.stepForward
                }
        , ellipsis = FontAwesome.Solid.ellipsisH
        , size = SizeDefault
        , items = []
        , attributes = []
        }



-- Rendering the pagination


view : Pagination context msg -> UiElement context msg
view (Pagination options) =
    Internal.fromElement
        (\context ->
            let
                config =
                    context.themeConfig.paginationConfig

                paddingX =
                    config.paddingX options.size

                paddingY =
                    config.paddingY options.size

                getColor disabled =
                    if disabled then
                        config.disabledColor

                    else
                        config.color

                getBackgroundColor disabled =
                    if disabled then
                        config.disabledBackgroundColor

                    else
                        config.backgroundColor

                getBorderColor disabled =
                    if disabled then
                        config.disabledBorderColor

                    else
                        config.borderColor

                firstDisabled =
                    context.state.currentSliceNumber == 1

                previousDisabled =
                    context.state.currentSliceNumber == 1

                nextDisabled =
                    context.state.currentSliceNumber == context.state.numberOfSlices

                lastDisabled =
                    context.state.currentSliceNumber == context.state.numberOfSlices

                commonAttrs disabled =
                    [ height fill
                    , paddingXY paddingX paddingY
                    , Font.color <| getColor disabled
                    , Border.width <| config.borderWidth options.size
                    , Border.solid
                    , Border.color <| getBorderColor disabled
                    , Background.color <| getBackgroundColor disabled
                    ]
                        ++ (if disabled then
                                []

                            else
                                [ pointer ]
                           )

                linkItem attrs label disabled index =
                    if disabled then
                        el attrs label

                    else
                        Input.button attrs
                            { onPress = Just <| options.selectedMsg index
                            , label = label
                            }
            in
            row options.attributes <|
                [ linkItem
                    (Border.roundEach
                        { topLeft = config.borderRadius options.size
                        , bottomLeft = config.borderRadius options.size
                        , topRight = 0
                        , bottomRight = 0
                        }
                        :: commonAttrs firstDisabled
                    )
                    (case options.labels of
                        IconLabels icons ->
                            Icon.view icons.first

                        StringLabels labels ->
                            text labels.first
                    )
                    firstDisabled
                    1
                , linkItem
                    (Border.rounded 0 :: commonAttrs previousDisabled)
                    (case options.labels of
                        IconLabels icons ->
                            Icon.view icons.previous

                        StringLabels labels ->
                            text labels.previous
                    )
                    previousDisabled
                    (context.state.currentSliceNumber - 1)
                ]
                    ++ List.map (renderItem context options) options.items
                    ++ [ linkItem
                            (Border.rounded 0 :: commonAttrs nextDisabled)
                            (case options.labels of
                                IconLabels icons ->
                                    Icon.view icons.next

                                StringLabels labels ->
                                    text labels.next
                            )
                            nextDisabled
                            (context.state.currentSliceNumber + 1)
                       , linkItem
                            (Border.roundEach
                                { topRight = config.borderRadius options.size
                                , bottomRight = config.borderRadius options.size
                                , topLeft = 0
                                , bottomLeft = 0
                                }
                                :: commonAttrs lastDisabled
                            )
                            (case options.labels of
                                IconLabels icons ->
                                    Icon.view icons.last

                                StringLabels labels ->
                                    text labels.last
                            )
                            lastDisabled
                            context.state.numberOfSlices
                       ]
        )


renderItem : Context context -> Options msg -> Item -> Element msg
renderItem context options item =
    let
        config =
            context.themeConfig.paginationConfig

        paddingX =
            config.paddingX options.size

        paddingY =
            config.paddingY options.size
    in
    case item of
        NumberItem index ->
            let
                ( color, borderColor, bgColor ) =
                    if index == context.state.currentSliceNumber then
                        ( config.activeColor, config.activeBackgroundColor, config.activeBackgroundColor )

                    else
                        ( config.color, config.borderColor, config.backgroundColor )
            in
            Input.button
                [ height fill
                , paddingXY paddingX paddingY
                , Font.color color
                , Border.rounded 0
                , Border.width <| config.borderWidth options.size
                , Border.solid
                , Border.color borderColor
                , Background.color bgColor
                , pointer
                ]
                { onPress = Just <| options.selectedMsg index
                , label = text <| String.fromInt index
                }

        EllipsisItem ->
            el
                [ height fill
                , paddingXY paddingX paddingY
                , Font.color config.color
                ]
                (Icon.view options.ellipsis)
