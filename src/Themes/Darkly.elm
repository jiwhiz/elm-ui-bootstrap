module Themes.Darkly exposing (darklyThemeConfig)

import Element.Font as Font
import UiFramework.ColorUtils exposing (alterColor, contrastTextColor, darken, hexToColor, lighten, transparent)
import UiFramework.Configuration
    exposing
        ( AlertConfig
        , Colors
        , ContainerConfig
        , DropdownConfig
        , FontConfig
        , InputConfig
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
        , defaultRangeSliderConfig
        , defaultTableConfig
        )
import UiFramework.Types exposing (Role(..), Size(..))


darklyColors : Colors
darklyColors =
    { white = hexToColor "#fff"
    , gray = hexToColor "#6c757d"
    , gray100 = hexToColor "#f8f9fa"
    , gray200 = hexToColor "#ebebeb"
    , gray300 = hexToColor "#dee2e6"
    , gray400 = hexToColor "#ced4da"
    , gray500 = hexToColor "#adb5bd"
    , gray600 = hexToColor "#999"
    , gray700 = hexToColor "#444"
    , gray800 = hexToColor "#303030"
    , gray900 = hexToColor "#222"
    , black = hexToColor "#000"
    , blue = hexToColor "#375a7f"
    , indigo = hexToColor "#6610f2"
    , purple = hexToColor "#6f42c1"
    , pink = hexToColor "#e83e8c"
    , red = hexToColor "#E74C3C"
    , orange = hexToColor "#fd7e14"
    , yellow = hexToColor "#F39C12"
    , green = hexToColor "#00bc8c"
    , teal = hexToColor "#20c997"
    , cyan = hexToColor "#3498DB"
    }


darklyThemeColor : Colors -> ThemeColor
darklyThemeColor colors role =
    case role of
        Primary ->
            colors.blue

        Secondary ->
            colors.gray700

        Success ->
            colors.green

        Info ->
            colors.cyan

        Warning ->
            colors.yellow

        Danger ->
            colors.red

        Light ->
            colors.gray600

        Dark ->
            colors.gray800


darklyAlertConfig : ThemeColor -> AlertConfig
darklyAlertConfig themeColor =
    let
        default =
            defaultAlertConfig themeColor
    in
    { default
        | backgroundColor = themeColor
        , fontColor = \_ -> darklyColors.white
        , linkFontColor = \_ -> darklyColors.white
        , fontSize = defaultFontSize
        , borderColor = themeColor
        , borderWidth = \_ -> 1
        , borderRadius = \_ -> 4
    }


darklyContainerConfig : ContainerConfig
darklyContainerConfig =
    { defaultContainerConfig
        | backgroundColor = darklyColors.gray900
        , jumbotronBackgroundColor = darklyColors.gray800
    }


darklyDropdownConfig : DropdownConfig
darklyDropdownConfig =
    { defaultDropdownConfig
        | backgroundColor = darklyColors.gray900
        , fontColor = darklyColors.white
        , borderColor = darklyColors.gray700
    }


darklyFontConfig : FontConfig
darklyFontConfig =
    { defaultFontConfig
        | fontFamily =
            [ Font.typeface "Lato"
            , Font.sansSerif
            ]
    }


darklyInputConfig : Colors -> ThemeColor -> InputConfig
darklyInputConfig colors themeColor =
    let
        default =
            defaultInputConfig colors themeColor
    in
    { default
        | fontColor = colors.gray700
        , borderColor = transparent
    }


darklyPaginationConfig : ThemeColor -> PaginationConfig
darklyPaginationConfig themeColor =
    let
        default =
            defaultPaginationConfig themeColor
    in
    { default
        | color = bootstrapColors.white
        , backgroundColor = themeColor Success
        , borderColor = transparent
        , borderWidth = \_ -> 0
        , hoverColor = bootstrapColors.white
        , hoverBackgroundColor = themeColor Success |> lighten 0.1
        , hoverBorderColor = transparent
        , activeBackgroundColor = themeColor Success |> lighten 0.1
        , disabledColor = bootstrapColors.white
        , disabledBackgroundColor = themeColor Success |> darken 0.15
        , disabledBorderColor = transparent
    }


darklyTableConfig : TableConfig
darklyTableConfig =
    { defaultTableConfig
        | color = darklyColors.white
        , backgroundColor = darklyColors.gray800
        , accentBackground = alterColor 0.05 darklyColors.white
        , borderColor = lighten 0.075 darklyColors.gray800
        , headColor = darklyColors.white
        , headBackgroundColor = darklyColors.gray900
    }


darklyThemeConfig : ThemeConfig
darklyThemeConfig =
    let
        themeColor =
            darklyThemeColor darklyColors
    in
    { colors = darklyColors
    , themeColor = themeColor
    , bodyBackground = darklyColors.gray900
    , bodyColor = darklyColors.white
    , fontColor = \bgColor -> contrastTextColor bgColor darklyColors.gray900 darklyColors.white
    , fontConfig = darklyFontConfig
    , alertConfig = darklyAlertConfig themeColor
    , badgeConfig = defaultBadgeConfig themeColor
    , buttonConfig = defaultButtonConfig themeColor
    , dropdownConfig = darklyDropdownConfig
    , navConfig = defaultNavConfig
    , navbarConfig = defaultNavbarConfig
    , inputConfig = darklyInputConfig darklyColors themeColor
    , paginationConfig = darklyPaginationConfig themeColor
    , rangeSliderConfig = defaultRangeSliderConfig darklyColors themeColor
    , containerConfig = darklyContainerConfig
    , tableConfig = darklyTableConfig
    }
