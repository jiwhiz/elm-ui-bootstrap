module Themes.Materia exposing (materiaThemeConfig)

import Element
import Element.Font as Font
import UiFramework.ColorUtils exposing (colorLevel, contrastTextColor, hexToColor, transparent)
import UiFramework.Configuration
    exposing
        ( AlertConfig
        , BoxShadow
        , ButtonConfig
        , Colors
        , FontConfig
        , GlobalConfig
        , InputConfig
        , NavConfig
        , NavbarConfig
        , ThemeColor
        , ThemeConfig
        , bootstrapColors
        , defaultAlertConfig
        , defaultBadgeConfig
        , defaultButtonConfig
        , defaultContainerConfig
        , defaultDropdownConfig
        , defaultFontConfig
        , defaultInputConfig
        , defaultLinkConfig
        , defaultNavConfig
        , defaultNavbarConfig
        , defaultPaginationConfig
        , defaultRangeSliderConfig
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


materiaPaddingX : Size -> Int
materiaPaddingX size =
    case size of
        SizeSmall ->
            8

        SizeDefault ->
            16

        SizeLarge ->
            16


materiaPaddingY : Size -> Int
materiaPaddingY size =
    case size of
        SizeSmall ->
            4

        SizeDefault ->
            16

        SizeLarge ->
            8


materiaButtonConfig : ThemeColor -> ButtonConfig
materiaButtonConfig themeColor =
    let
        default =
            defaultButtonConfig themeColor
    in
    { default
        | paddingX = materiaPaddingX
        , paddingY = materiaPaddingY
        , withShadow = Just boxShadows
        , borderWidth = \_ -> 0
    }


materiaFontConfig : FontConfig
materiaFontConfig =
    { defaultFontConfig
        | fontFamily =
            [ Font.typeface "Roboto"
            , Font.sansSerif
            ]
    }


materiaGlobalConfig : GlobalConfig
materiaGlobalConfig =
    { colors = materiaColors
    , themeColor = materiaThemeColor materiaColors
    , bodyBackground = materiaColors.white
    , bodyColor = materiaColors.gray700
    , fontColor = \bgColor -> contrastTextColor bgColor materiaColors.gray900 materiaColors.white
    , fontConfig = materiaFontConfig
    }


materiaInputConfig : Colors -> ThemeColor -> InputConfig
materiaInputConfig colors themeColor =
    let
        default =
            defaultInputConfig colors themeColor
    in
    { default
        | paddingX = materiaPaddingX
        , paddingY = materiaPaddingY
        , borderColor = transparent
        , borderRadius = always 0
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
        | paddingY = 16
        , withShadow = Just boxShadows
    }


materiaAlertConfig : ThemeColor -> AlertConfig
materiaAlertConfig themeColor =
    let
        default =
            defaultAlertConfig themeColor
    in
    { default
        | backgroundColor = themeColor >> colorLevel -2
        , fontColor =
            \role ->
                contrastTextColor (themeColor role) bootstrapColors.gray900 bootstrapColors.white
    }



-- values from Bootswatch Materia


boxShadows : BoxShadow
boxShadows =
    { offset = ( 0, 1 )
    , size = 0
    , blur = 4
    , color = Element.rgba 0 0 0 0.4
    }


materiaThemeConfig : ThemeConfig
materiaThemeConfig =
    let
        themeColor =
            materiaThemeColor materiaColors
    in
    { alertConfig = materiaAlertConfig themeColor
    , badgeConfig = defaultBadgeConfig themeColor
    , buttonConfig = materiaButtonConfig themeColor
    , containerConfig = defaultContainerConfig
    , dropdownConfig = defaultDropdownConfig
    , globalConfig = materiaGlobalConfig
    , inputConfig = materiaInputConfig materiaColors themeColor
    , linkConfig = defaultLinkConfig themeColor
    , navbarConfig = materiaNavbarConfig
    , navConfig = materiaNavConfig
    , paginationConfig = defaultPaginationConfig themeColor
    , rangeSliderConfig = defaultRangeSliderConfig materiaColors themeColor
    , tableConfig = defaultTableConfig
    }
