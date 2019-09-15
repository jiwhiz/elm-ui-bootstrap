module UiFramework.Pagination exposing
    ( Item(..)
    , Pagination
    , PaginationState
    , default
    , view
    , withExtraAttrs
    , withItemLabel
    , withItems
    , withLarge
    , withSmall
    , withStringLabels
    )

import Element exposing (Attribute, Device, Element, el, fill, height, paddingXY, pointer, row, text, width)
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
    , currentSliceNumber : Int -- start from 0
    }


type alias Context context =
    { context
        | device : Device
        , themeConfig : ThemeConfig
        , parentRole : Maybe Role
    }


type alias UiElement context msg =
    Internal.WithContext (Context context) msg


{-| Pagination type
-}
type Pagination context msg
    = Pagination (Options msg)


type alias Options msg =
    { selectedMsg : Int -> msg
    , labels : LabelType msg
    , ellipsis : Icon.Icon msg
    , size : Size
    , items : List Item
    , itemLabel : Int -> Element msg
    , attributes : List (Attribute msg)
    }


type LabelType msg
    = IconLabels
        { first : Icon.Icon msg
        , previous : Icon.Icon msg
        , next : Icon.Icon msg
        , last : Icon.Icon msg
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


withItemLabel : (Int -> Element msg) -> Pagination context msg -> Pagination context msg
withItemLabel itemLabel (Pagination options) =
    Pagination { options | itemLabel = itemLabel }


type Item
    = NumberItem Int
    | EllipsisItem


default : (Int -> msg) -> Pagination context msg
default selectedMsg =
    Pagination
        { selectedMsg = selectedMsg
        , labels =
            IconLabels
                { first = Icon.fontAwesome FontAwesome.Solid.stepBackward
                , previous = Icon.fontAwesome FontAwesome.Solid.caretLeft
                , next = Icon.fontAwesome FontAwesome.Solid.caretRight
                , last = Icon.fontAwesome FontAwesome.Solid.stepForward
                }
        , ellipsis = Icon.fontAwesome FontAwesome.Solid.ellipsisH
        , size = SizeDefault
        , items = []
        , itemLabel = \i -> text <| String.fromInt (i + 1)
        , attributes = []
        }



-- Rendering the pagination


view : PaginationState -> Pagination context msg -> UiElement context msg
view state (Pagination options) =
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
                    state.currentSliceNumber == 0

                previousDisabled =
                    state.currentSliceNumber == 0

                nextDisabled =
                    state.currentSliceNumber == state.numberOfSlices - 1

                lastDisabled =
                    state.currentSliceNumber == state.numberOfSlices - 1

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
                            Icon.viewAsElement icons.first

                        StringLabels labels ->
                            text labels.first
                    )
                    firstDisabled
                    0
                , linkItem
                    (Border.rounded 0 :: commonAttrs previousDisabled)
                    (case options.labels of
                        IconLabels icons ->
                            Icon.viewAsElement icons.previous

                        StringLabels labels ->
                            text labels.previous
                    )
                    previousDisabled
                    (state.currentSliceNumber - 1)
                ]
                    ++ List.map (renderItem state context options) options.items
                    ++ [ linkItem
                            (Border.rounded 0 :: commonAttrs nextDisabled)
                            (case options.labels of
                                IconLabels icons ->
                                    Icon.viewAsElement icons.next

                                StringLabels labels ->
                                    text labels.next
                            )
                            nextDisabled
                            (state.currentSliceNumber + 1)
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
                                    Icon.viewAsElement icons.last

                                StringLabels labels ->
                                    text labels.last
                            )
                            lastDisabled
                            (state.numberOfSlices - 1)
                       ]
        )


renderItem : PaginationState -> Context context -> Options msg -> Item -> Element msg
renderItem state context options item =
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
                    if index == state.currentSliceNumber then
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
                , label = options.itemLabel index
                }

        EllipsisItem ->
            el
                [ height fill
                , paddingXY paddingX paddingY
                , Font.color config.color
                ]
                (Icon.viewAsElement options.ellipsis)
