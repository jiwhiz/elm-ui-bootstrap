module UiFramework.Configuration exposing (AlertConfig, ButtonConfig, Colors, ContainerConfig, DropdownConfig, FontConfig, InputConfig, NavConfig, NavbarConfig, ThemeColor, ThemeConfig, bootstrapColors, bootstrapThemeColor, defaultAlertConfig, defaultButtonConfig, defaultContainerConfig, defaultDropdownConfig, defaultFontConfig, defaultFontSize, defaultInputConfig, defaultNavConfig, defaultNavbarConfig, defaultThemeConfig)

import Element exposing (Color)
import Element.Font as Font
import UiFramework.Colors exposing (alterColor, colorLevel, contrastTextColor, darken, getColor, lighten)
import UiFramework.Types exposing (Role(..), Size(..))


type alias Colors =
    { white : Color
    , gray : Color
    , gray100 : Color
    , gray200 : Color
    , gray300 : Color
    , gray400 : Color
    , gray500 : Color
    , gray600 : Color
    , gray700 : Color
    , gray800 : Color
    , gray900 : Color
    , black : Color
    , blue : Color
    , indigo : Color
    , purple : Color
    , pink : Color
    , red : Color
    , orange : Color
    , yellow : Color
    , green : Color
    , teal : Color
    , cyan : Color
    }


type alias ThemeColor =
    Role -> Color


type alias FontConfig =
    { typeface : String
    , typefaceFallback : Font.Font
    , url : String
    }


type alias AlertConfig =
    { paddingX : Int
    , paddingY : Int
    , backgroundColor : ThemeColor
    , fontColor : ThemeColor
    , linkFontColor : ThemeColor
    , fontSize : Size -> Int
    , borderColor : ThemeColor
    , borderWidth : Size -> Int
    , borderRadius : Size -> Int
    }


type alias ButtonConfig =
    { paddingX : Size -> Int
    , paddingY : Size -> Int
    , backgroundColor : ThemeColor
    , fontColor : ThemeColor
    , fontSize : Size -> Int
    , borderColor : ThemeColor
    , borderWidth : Size -> Int
    , borderRadius : Size -> Int
    }


type alias NavbarConfig =
    { paddingX : Int
    , paddingY : Int
    , menubarPaddingX : Int
    , menubarPaddingY : Int
    , brandFontSize : Int
    , brandPaddingY : Int
    , togglerPaddingX : Int
    , togglerPaddingY : Int
    , togglerBorderRadius : Int
    }


type alias NavConfig =
    { linkPaddingX : Int
    , linkPaddingY : Int
    , disabledColor : Color
    , dividerColor : Color
    , dividerMarginY : Int
    }


type alias DropdownConfig =
    { paddingX : Int
    , paddingY : Int
    , spacer : Int
    , backgroundColor : Color
    , fontColor : Color
    , fontSize : Size -> Int
    , borderColor : Color
    , borderWidth : Int
    , borderRadius : Int
    }


type alias InputConfig =
    { fontColor : Color
    , fontSize : Int
    , paddingX : Int
    , paddingY : Int
    , borderRadius : Int
    , borderColor : Color
    , focusedBorderColor : Color
    }


type alias ThemeConfig =
    { colors : Colors
    , themeColor : ThemeColor
    , bodyBackground : Color
    , bodyColor : Color
    , fontConfig : FontConfig
    , fontColor : Color -> Color
    , alertConfig : AlertConfig
    , buttonConfig : ButtonConfig
    , dropdownConfig : DropdownConfig
    , navbarConfig : NavbarConfig
    , navConfig : NavConfig
    , inputConfig : InputConfig
    , containerConfig : ContainerConfig
    }


type alias ContainerConfig =
    { backgroundColor : Color
    }


bootstrapColors : Colors
bootstrapColors =
    { white = getColor "#fff"
    , gray = getColor "#6c757d"
    , gray100 = getColor "#f8f9fa"
    , gray200 = getColor "#e9ecef"
    , gray300 = getColor "#dee2e6"
    , gray400 = getColor "#ced4da"
    , gray500 = getColor "#adb5bd"
    , gray600 = getColor "#6c757d"
    , gray700 = getColor "#495057"
    , gray800 = getColor "#343a40"
    , gray900 = getColor "#212529"
    , black = getColor "#000"
    , blue = getColor "#007bff"
    , indigo = getColor "#6610f2"
    , purple = getColor "#6f42c1"
    , pink = getColor "#e83e8c"
    , red = getColor "#dc3545"
    , orange = getColor "#fd7e14"
    , yellow = getColor "#ffc107"
    , green = getColor "#28a745"
    , teal = getColor "#20c997"
    , cyan = getColor "#17a2b8"
    }


bootstrapThemeColor : Colors -> ThemeColor
bootstrapThemeColor colors role =
    case role of
        Primary ->
            colors.blue

        Secondary ->
            colors.gray600

        Success ->
            colors.green

        Info ->
            colors.cyan

        Warning ->
            colors.yellow

        Danger ->
            colors.red

        Light ->
            colors.gray100

        Dark ->
            colors.gray800


defaultFontConfig : FontConfig
defaultFontConfig =
    { typeface = "Noto Sans"
    , typefaceFallback = Font.sansSerif
    , url = "https://fonts.googleapis.com/css?family=Noto+Sans"
    }


defaultFontSize : Size -> Int
defaultFontSize size =
    case size of
        SizeSmall ->
            14

        SizeDefault ->
            16

        SizeLarge ->
            20


defaultAlertConfig : ThemeColor -> AlertConfig
defaultAlertConfig themeColor =
    { paddingX = 20
    , paddingY = 12
    , backgroundColor = themeColor >> colorLevel -10
    , fontColor = themeColor >> colorLevel 6
    , linkFontColor = themeColor >> darken 0.3
    , fontSize = defaultFontSize
    , borderColor = themeColor >> colorLevel -9
    , borderWidth = \_ -> 1
    , borderRadius = \_ -> 4
    }


defaultButtonConfig : ThemeColor -> ButtonConfig
defaultButtonConfig themeColor =
    { paddingX =
        \size ->
            case size of
                SizeSmall ->
                    8

                SizeDefault ->
                    12

                SizeLarge ->
                    16
    , paddingY =
        \size ->
            case size of
                SizeSmall ->
                    4

                SizeDefault ->
                    6

                SizeLarge ->
                    8
    , backgroundColor = themeColor
    , fontColor =
        \role ->
            contrastTextColor (themeColor role) bootstrapColors.gray900 bootstrapColors.white
    , fontSize = defaultFontSize
    , borderColor = themeColor
    , borderWidth =
        \_ ->
            1
    , borderRadius =
        \size ->
            case size of
                SizeSmall ->
                    3

                SizeDefault ->
                    4

                SizeLarge ->
                    5
    }


defaultDropdownConfig : DropdownConfig
defaultDropdownConfig =
    { paddingX = 16
    , paddingY = 8
    , spacer = 2
    , backgroundColor = bootstrapColors.white
    , fontColor = bootstrapColors.gray900
    , fontSize = defaultFontSize
    , borderColor = alterColor bootstrapColors.black 0.15
    , borderWidth = 1
    , borderRadius = 4
    }


defaultNavbarConfig : NavbarConfig
defaultNavbarConfig =
    { paddingX = 16
    , paddingY = 8
    , menubarPaddingX = 8
    , menubarPaddingY = 8
    , brandFontSize = 20
    , brandPaddingY = 4 -- ?
    , togglerPaddingX = 12
    , togglerPaddingY = 4
    , togglerBorderRadius = 4
    }


defaultNavConfig : NavConfig
defaultNavConfig =
    { linkPaddingX = 16
    , linkPaddingY = 8
    , disabledColor = bootstrapColors.gray600
    , dividerColor = bootstrapColors.gray200
    , dividerMarginY = 8
    }


defaultInputConfig : ThemeColor -> InputConfig
defaultInputConfig themeColor =
    { fontColor = bootstrapColors.gray600
    , fontSize = defaultFontSize SizeDefault
    , paddingX = 12
    , paddingY = 6
    , borderRadius = 4
    , borderColor = bootstrapColors.gray400
    , focusedBorderColor = (themeColor >> lighten 0.25) Primary
    }


defaultContainerConfig : ContainerConfig
defaultContainerConfig =
    { backgroundColor = bootstrapColors.gray200
    }


defaultThemeConfig : ThemeConfig
defaultThemeConfig =
    let
        themeColor =
            bootstrapThemeColor bootstrapColors
    in
    { colors = bootstrapColors
    , themeColor = themeColor
    , bodyBackground = bootstrapColors.white
    , bodyColor = bootstrapColors.gray900
    , fontColor = \bgColor -> contrastTextColor bgColor bootstrapColors.gray900 bootstrapColors.white
    , fontConfig = defaultFontConfig
    , alertConfig = defaultAlertConfig themeColor
    , buttonConfig = defaultButtonConfig themeColor
    , dropdownConfig = defaultDropdownConfig
    , navConfig = defaultNavConfig
    , navbarConfig = defaultNavbarConfig
    , inputConfig = defaultInputConfig themeColor
    , containerConfig = defaultContainerConfig
    }
