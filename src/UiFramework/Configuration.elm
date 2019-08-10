module UiFramework.Configuration exposing (AlertConfig, BadgeConfig, ButtonConfig, Colors, ContainerConfig, DropdownConfig, FontConfig, InputConfig, NavConfig, NavbarConfig, PaginationConfig, TableConfig, ThemeColor, ThemeConfig, bootstrapColors, bootstrapThemeColor, defaultAlertConfig, defaultBadgeConfig, defaultButtonConfig, defaultContainerConfig, defaultDropdownConfig, defaultFontConfig, defaultFontSize, defaultInputConfig, defaultNavConfig, defaultNavbarConfig, defaultPaginationConfig, defaultTableConfig, defaultThemeConfig)

import Element exposing (Color, DeviceClass(..))
import Element.Font as Font
import UiFramework.ColorUtils exposing (alterColor, colorLevel, contrastTextColor, darken, hexToColor, lighten)
import UiFramework.Types exposing (Role(..), Size(..))


type alias PaddingByScreenSize =
    DeviceClass -> { x : Int, y : Int }


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


type alias BadgeConfig =
    { paddingX : Int
    , paddingY : Int
    , backgroundColor : ThemeColor
    , fontColor : ThemeColor
    , borderRadius : Int
    , pillBorderRadius : Int
    , pillPaddingX : Int
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


type alias ContainerConfig =
    { jumbotronBackgroundColor : Color
    , backgroundColor : Color
    , borderColor : Color
    , borderWidth : Int
    , borderRadius : Int
    , jumbotronPadding : PaddingByScreenSize
    , containerPadding : { x : Int, y : Int }
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


type alias NavConfig =
    { linkPaddingX : Int
    , linkPaddingY : Int
    , disabledColor : Color
    , dividerColor : Color
    , dividerMarginY : Int
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


type alias PaginationConfig =
    { paddingX : Size -> Int
    , paddingY : Size -> Int
    , fontSize : Size -> Int
    , color : Color
    , backgroundColor : Color
    , borderColor : Color
    , borderWidth : Size -> Int
    , borderRadius : Size -> Int
    , hoverColor : Color
    , hoverBackgroundColor : Color
    , hoverBorderColor : Color
    , activeColor : Color
    , activeBackgroundColor : Color
    , disabledColor : Color
    , disabledBackgroundColor : Color
    , disabledBorderColor : Color
    }


type alias TableConfig =
    { color : Color
    , backgroundColor : Color
    , accentBackground : Color
    , borderColor : Color
    , borderWidth : Int
    , headColor : Color
    , headBackgroundColor : Color
    , cellPadding : Int
    , cellPaddingCompact : Int
    }


type alias ThemeConfig =
    { colors : Colors
    , themeColor : ThemeColor
    , bodyBackground : Color
    , bodyColor : Color
    , fontConfig : FontConfig
    , fontColor : Color -> Color
    , alertConfig : AlertConfig
    , badgeConfig : BadgeConfig
    , buttonConfig : ButtonConfig
    , dropdownConfig : DropdownConfig
    , navbarConfig : NavbarConfig
    , navConfig : NavConfig
    , inputConfig : InputConfig
    , paginationConfig : PaginationConfig
    , containerConfig : ContainerConfig
    , tableConfig : TableConfig
    }


bootstrapColors : Colors
bootstrapColors =
    { white = hexToColor "#fff"
    , gray = hexToColor "#6c757d"
    , gray100 = hexToColor "#f8f9fa"
    , gray200 = hexToColor "#e9ecef"
    , gray300 = hexToColor "#dee2e6"
    , gray400 = hexToColor "#ced4da"
    , gray500 = hexToColor "#adb5bd"
    , gray600 = hexToColor "#6c757d"
    , gray700 = hexToColor "#495057"
    , gray800 = hexToColor "#343a40"
    , gray900 = hexToColor "#212529"
    , black = hexToColor "#000"
    , blue = hexToColor "#007bff"
    , indigo = hexToColor "#6610f2"
    , purple = hexToColor "#6f42c1"
    , pink = hexToColor "#e83e8c"
    , red = hexToColor "#dc3545"
    , orange = hexToColor "#fd7e14"
    , yellow = hexToColor "#ffc107"
    , green = hexToColor "#28a745"
    , teal = hexToColor "#20c997"
    , cyan = hexToColor "#17a2b8"
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


defaultBorderWidth : Size -> Int
defaultBorderWidth _ =
    1


defaultBorderRadius : Size -> Int
defaultBorderRadius size =
    case size of
        SizeSmall ->
            3

        SizeDefault ->
            4

        SizeLarge ->
            5


defaultAlertConfig : ThemeColor -> AlertConfig
defaultAlertConfig themeColor =
    { paddingX = 20
    , paddingY = 12
    , backgroundColor = themeColor >> colorLevel -10
    , fontColor = themeColor >> colorLevel 6
    , linkFontColor = themeColor >> darken 0.3
    , fontSize = defaultFontSize
    , borderColor = themeColor >> colorLevel -9
    , borderWidth = defaultBorderWidth
    , borderRadius = \_ -> 4
    }


defaultBadgeConfig : ThemeColor -> BadgeConfig
defaultBadgeConfig themeColor =
    { paddingX = 6
    , paddingY = 4
    , backgroundColor = themeColor
    , fontColor =
        \role ->
            contrastTextColor (themeColor role) bootstrapColors.gray900 bootstrapColors.white
    , borderRadius = 4
    , pillBorderRadius = 160
    , pillPaddingX = 9
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
    , borderWidth = defaultBorderWidth
    , borderRadius = defaultBorderRadius
    }


defaultContainerConfig : ContainerConfig
defaultContainerConfig =
    { jumbotronBackgroundColor = bootstrapColors.gray200
    , backgroundColor = bootstrapColors.white
    , borderColor = bootstrapColors.gray200
    , borderWidth = 0
    , borderRadius = 4
    , jumbotronPadding =
        \deviceClass ->
            case deviceClass of
                Phone ->
                    { x = 16, y = 32 }

                _ ->
                    { x = 32, y = 64 }
    , containerPadding = { x = 15, y = 0 }
    }


defaultDropdownConfig : DropdownConfig
defaultDropdownConfig =
    { paddingX = 16
    , paddingY = 8
    , spacer = 2
    , backgroundColor = bootstrapColors.white
    , fontColor = bootstrapColors.gray900
    , fontSize = defaultFontSize
    , borderColor = alterColor 0.15 bootstrapColors.black
    , borderWidth = 1
    , borderRadius = 4
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


defaultNavConfig : NavConfig
defaultNavConfig =
    { linkPaddingX = 16
    , linkPaddingY = 8
    , disabledColor = bootstrapColors.gray600
    , dividerColor = bootstrapColors.gray200
    , dividerMarginY = 8
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


defaultPaginationConfig : ThemeColor -> PaginationConfig
defaultPaginationConfig themeColor =
    let
        paddingX : Size -> Int
        paddingX =
            \size ->
                case size of
                    SizeSmall ->
                        8

                    SizeDefault ->
                        12

                    SizeLarge ->
                        24

        paddingY : Size -> Int
        paddingY =
            \size ->
                case size of
                    SizeSmall ->
                        4

                    SizeDefault ->
                        8

                    SizeLarge ->
                        12
    in
    { paddingX = paddingX
    , paddingY = paddingY
    , fontSize = defaultFontSize
    , color = themeColor Primary
    , backgroundColor = bootstrapColors.white
    , borderColor = bootstrapColors.gray300
    , borderWidth = defaultBorderWidth
    , borderRadius = defaultBorderRadius
    , hoverColor = themeColor Primary |> darken 0.15
    , hoverBackgroundColor = bootstrapColors.gray200
    , hoverBorderColor = bootstrapColors.gray300
    , activeColor = bootstrapColors.white -- component active color?
    , activeBackgroundColor = themeColor Primary
    , disabledColor = bootstrapColors.gray600
    , disabledBackgroundColor = bootstrapColors.white
    , disabledBorderColor = bootstrapColors.gray300
    }


defaultTableConfig : TableConfig
defaultTableConfig =
    { color = bootstrapColors.gray900
    , backgroundColor = bootstrapColors.white
    , accentBackground = alterColor 0.05 bootstrapColors.black
    , borderColor = bootstrapColors.gray300
    , borderWidth = 1
    , headColor = bootstrapColors.gray700
    , headBackgroundColor = bootstrapColors.gray200
    , cellPadding = 12
    , cellPaddingCompact = 5
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
    , badgeConfig = defaultBadgeConfig themeColor
    , buttonConfig = defaultButtonConfig themeColor
    , dropdownConfig = defaultDropdownConfig
    , navConfig = defaultNavConfig
    , navbarConfig = defaultNavbarConfig
    , inputConfig = defaultInputConfig themeColor
    , paginationConfig = defaultPaginationConfig themeColor
    , containerConfig = defaultContainerConfig
    , tableConfig = defaultTableConfig
    }
