module Themes.Darkly exposing (darklyThemeConfig)

import UiFramework.Colors exposing (alterColor, contrastTextColor, darken, getColor, lighten, transparent)
import UiFramework.Configuration
    exposing
        ( AlertConfig
        , Colors
        , ContainerConfig
        , DropdownConfig
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
        , defaultTableConfig
        )
import UiFramework.Types exposing (Role(..), Size(..))


darklyColors : Colors
darklyColors =
    { white = getColor "#fff"
    , gray = getColor "#6c757d"
    , gray100 = getColor "#f8f9fa"
    , gray200 = getColor "#ebebeb"
    , gray300 = getColor "#dee2e6"
    , gray400 = getColor "#ced4da"
    , gray500 = getColor "#adb5bd"
    , gray600 = getColor "#999"
    , gray700 = getColor "#444"
    , gray800 = getColor "#303030"
    , gray900 = getColor "#222"
    , black = getColor "#000"
    , blue = getColor "#375a7f"
    , indigo = getColor "#6610f2"
    , purple = getColor "#6f42c1"
    , pink = getColor "#e83e8c"
    , red = getColor "#E74C3C"
    , orange = getColor "#fd7e14"
    , yellow = getColor "#F39C12"
    , green = getColor "#00bc8c"
    , teal = getColor "#20c997"
    , cyan = getColor "#3498DB"
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


alertConfig : ThemeColor -> AlertConfig
alertConfig themeColor =
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


dropdownConfig : DropdownConfig
dropdownConfig =
    { defaultDropdownConfig
        | backgroundColor = darklyColors.gray900
        , fontColor = darklyColors.white
        , borderColor = darklyColors.gray700
    }


darklyInputConfig : ThemeColor -> InputConfig
darklyInputConfig themeColor =
    let
        default =
            defaultInputConfig themeColor
    in
    { default
        | fontColor = bootstrapColors.gray700
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


darklyContainerConfig : ContainerConfig
darklyContainerConfig =
    { defaultContainerConfig
        | backgroundColor = darklyColors.gray900
        , jumbotronBackgroundColor = darklyColors.gray800
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
    , fontConfig = defaultFontConfig
    , alertConfig = alertConfig themeColor
    , badgeConfig = defaultBadgeConfig themeColor
    , buttonConfig = defaultButtonConfig themeColor
    , dropdownConfig = dropdownConfig
    , navConfig = defaultNavConfig
    , navbarConfig = defaultNavbarConfig
    , inputConfig = darklyInputConfig themeColor
    , paginationConfig = darklyPaginationConfig themeColor
    , containerConfig = darklyContainerConfig
    , tableConfig = darklyTableConfig
    }
