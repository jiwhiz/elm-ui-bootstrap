module Themes.Materia exposing (materiaThemeConfig)

import Element.Font as Font
import UiFramework.ColorUtils exposing (alterColor, contrastTextColor, darken, hexToColor, lighten, transparent)
import UiFramework.Configuration
    exposing
        ( AlertConfig
        , ButtonConfig
        , Colors
        , ContainerConfig
        , DropdownConfig
        , FontConfig
        , InputConfig
        , NavConfig
        , NavbarConfig
        , PaginationConfig
        , TableConfig
        , ThemeColor
        , ThemeConfig
        , bootstrapColors
        , defaultAlertConfig
        , defaultBadgeConfig
        , defaultButtonConfig
        , defaultContainerConfig
        , defaultDropdownConfig
        , defaultFontConfig
        , defaultFontSize
        , defaultInputConfig
        , defaultNavConfig
        , defaultNavbarConfig
        , defaultPaginationConfig
        , defaultTableConfig
        )
import UiFramework.Types exposing (Role(..), Size(..))


materiaColors : Colors
materiaColors =
    { white = hexToColor "#fff"
    , gray = hexToColor "#6c757d"
    , gray100 = hexToColor "#f8f9fa"
    , gray200 = hexToColor "#eee"
    , gray300 = hexToColor "#dee2e6"
    , gray400 = hexToColor "#ced4da"
    , gray500 = hexToColor "#bbb"
    , gray600 = hexToColor "#666"
    , gray700 = hexToColor "#444"
    , gray800 = hexToColor "#222"
    , gray900 = hexToColor "#212121"
    , black = hexToColor "#000"
    , blue = hexToColor "#2196F3"
    , indigo = hexToColor "#6610f2"
    , purple = hexToColor "#6f42c1"
    , pink = hexToColor "#e83e8c"
    , red = hexToColor "#e51c23"
    , orange = hexToColor "#fd7e14"
    , yellow = hexToColor "#ff9800"
    , green = hexToColor "#4CAF50"
    , teal = hexToColor "#20c997"
    , cyan = hexToColor "#9C27B0"
    }


materiaThemeColor : Colors -> ThemeColor
materiaThemeColor colors role =
    case role of
        Primary ->
            colors.blue

        Secondary ->
            colors.white

        Success ->
            colors.green

        Info ->
            colors.cyan

        Warning ->
            colors.yellow

        Danger ->
            colors.red

        Light ->
            colors.gray200

        Dark ->
            colors.gray800


materiaButtonConfig : ThemeColor -> ButtonConfig
materiaButtonConfig themeColor =
    let
        default =
            defaultButtonConfig themeColor
    in
    { default
        | paddingX =
            \size ->
                case size of
                    SizeSmall ->
                        8

                    SizeDefault ->
                        16

                    SizeLarge ->
                        16
        , paddingY =
            \size ->
                case size of
                    SizeSmall ->
                        4

                    SizeDefault ->
                        16

                    SizeLarge ->
                        8
    }


materiaFontConfig : FontConfig
materiaFontConfig =
    { defaultFontConfig
        | fontFamily =
            [ Font.typeface "Roboto"
            , Font.typeface "Segoe UI"
            , Font.sansSerif
            ]
    }


materiaInputConfig : ThemeColor -> InputConfig
materiaInputConfig themeColor =
    let
        default =
            defaultInputConfig themeColor
    in
    { default
        | paddingX = 16
        , paddingY = 0
        , borderColor = transparent
        , borderRadius = 0
    }


materiaNavConfig : NavConfig
materiaNavConfig =
    { defaultNavConfig
        | disabledColor = bootstrapColors.gray500
        , linkPaddingY = 18
    }


materiaNavbarConfig : NavbarConfig
materiaNavbarConfig =
    { defaultNavbarConfig
        | paddingY = 20
    }


materiaThemeConfig : ThemeConfig
materiaThemeConfig =
    let
        themeColor =
            materiaThemeColor materiaColors
    in
    { colors = materiaColors
    , themeColor = themeColor
    , bodyBackground = materiaColors.white
    , bodyColor = materiaColors.gray700
    , fontColor = \bgColor -> contrastTextColor bgColor materiaColors.gray900 materiaColors.white
    , fontConfig = defaultFontConfig
    , alertConfig = defaultAlertConfig themeColor
    , badgeConfig = defaultBadgeConfig themeColor
    , buttonConfig = materiaButtonConfig themeColor
    , dropdownConfig = defaultDropdownConfig
    , navConfig = materiaNavConfig
    , navbarConfig = materiaNavbarConfig
    , inputConfig = materiaInputConfig themeColor
    , paginationConfig = defaultPaginationConfig themeColor
    , containerConfig = defaultContainerConfig
    , tableConfig = defaultTableConfig
    }
