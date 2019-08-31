module SharedState exposing (SharedState, SharedStateUpdate(..), Theme(..), getThemeConfig, init, update)

import Browser.Navigation
import Element exposing (Color, Device)
import UiFramework.ColorUtils as ColorUtils
import UiFramework.Configuration exposing (ThemeConfig, defaultThemeConfig)

type alias SharedState =
    { navKey : Browser.Navigation.Key -- used by other pages to navigate (through Browser.Navigation.pushUrl)
    , device : Device
    , theme : Theme
    , purpleColor : Color
    }


type Theme
    = Default ThemeConfig
    | Darkly ThemeConfig
    | Materia ThemeConfig


getThemeConfig : Theme -> ThemeConfig
getThemeConfig theme =
    case theme of
        Default config ->
            config

        Darkly config ->
            config

        Materia config ->
            config


type SharedStateUpdate
    = UpdateDevice Device
    | UpdateTheme Theme
    | NoUpdate


init : Device -> Browser.Navigation.Key -> SharedState
init device key =
    { navKey = key
    , device = device
    , theme = Default defaultThemeConfig
    , purpleColor = ColorUtils.hexToColor "563D7C"
    }


update : SharedState -> SharedStateUpdate -> SharedState
update sharedState updateMsg =
    case updateMsg of
        UpdateDevice device ->
            { sharedState | device = device }

        UpdateTheme theme ->
            { sharedState | theme = theme }

        NoUpdate ->
            sharedState
