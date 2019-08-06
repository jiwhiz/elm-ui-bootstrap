module UiFramework.Table exposing
    ( Column
    , Table
    , simpleTable
    , view
    , withBordered
    , withBorderless
    , withColumns
    , withCompact
    , withExtraAttrs
    , withStriped
    )

import Element
    exposing
        ( Attribute
        , el
        , fill
        , height
        , indexedTable
        , paddingXY
        , row
        , scrollbars
        , spacing
        , text
        , width
        )
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import UiFramework.Icon as Icon
import UiFramework.Internal as Internal
import UiFramework.Types exposing (Role(..), Size(..))


type alias UiElement context msg =
    Internal.WithContext (Internal.UiContextual context) msg


{-| Table type
-}
type Table data context msg
    = Table (Options data context msg)


type alias Options data context msg =
    { striped : Bool
    , border : BorderType
    , compact : Bool
    , attributes : List (Attribute msg)
    , columns : List (Column data context msg)
    }


type BorderType
    = Default
    | Borderless
    | Bordered


type alias Column data context msg =
    { head : UiElement context msg
    , viewData : data -> UiElement context msg
    }


withStriped : Table data context msg -> Table data context msg
withStriped (Table options) =
    Table { options | striped = True }


withBordered : Table data context msg -> Table data context msg
withBordered (Table options) =
    Table { options | border = Bordered }


withBorderless : Table data context msg -> Table data context msg
withBorderless (Table options) =
    Table { options | border = Borderless }


withCompact : Table data context msg -> Table data context msg
withCompact (Table options) =
    Table { options | compact = True }


withExtraAttrs : List (Attribute msg) -> Table data context msg -> Table data context msg
withExtraAttrs attributes (Table options) =
    Table { options | attributes = attributes }


withColumns : List (Column data context msg) -> Table data context msg -> Table data context msg
withColumns columns (Table options) =
    Table { options | columns = columns }


simpleTable : Table data context msg
simpleTable =
    Table
        { striped = False
        , border = Default
        , compact = False
        , attributes = []
        , columns = []
        }



-- Rendering the button


view : List data -> Table data context msg -> UiElement context msg
view data (Table options) =
    Internal.fromElement
        (\context ->
            let
                config =
                    context.themeConfig.tableConfig

                cellPaddingXY =
                    if options.compact then
                        paddingXY config.cellPaddingCompact config.cellPaddingCompact

                    else
                        paddingXY config.cellPadding config.cellPadding

                tableAttributes =
                    [ Background.color <| config.backgroundColor
                    , Font.color config.color
                    , scrollbars
                    ]

                borderWidthX =
                    case options.border of
                        Bordered ->
                            config.borderWidth

                        _ ->
                            0

                borderWidthY =
                    case options.border of
                        Borderless ->
                            0

                        _ ->
                            config.borderWidth

                headWrapper head =
                    el
                        [ cellPaddingXY
                        , Font.alignLeft
                        , Font.bold
                        , Font.color config.headColor
                        , Background.color config.headBackgroundColor
                        , Border.color config.borderColor
                        , Border.solid
                        , Border.widthEach
                            { bottom = borderWidthY * 2
                            , left = borderWidthX
                            , right = borderWidthX
                            , top = borderWidthY
                            }
                        ]
                        (Internal.toElement context head)

                cellWrapper index cell =
                    let
                        background =
                            if modBy 2 index == 0 then
                                config.backgroundColor

                            else
                                config.accentBackground
                    in
                    el
                        [ cellPaddingXY
                        , width fill
                        , height fill
                        , Font.alignLeft
                        , Font.color config.color
                        , Background.color background
                        , Border.color config.borderColor
                        , Border.solid
                        , Border.widthXY borderWidthX borderWidthY
                        ]
                        (Internal.toElement context cell)
            in
            indexedTable
                tableAttributes
                { data = data
                , columns =
                    List.map
                        (\column ->
                            { header = headWrapper column.head
                            , width = fill
                            , view =
                                \index record -> cellWrapper index (column.viewData record)
                            }
                        )
                        options.columns
                }
        )
