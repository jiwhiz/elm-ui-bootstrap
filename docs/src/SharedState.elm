module SharedState exposing (SharedState, SharedStateUpdate(..), init, update)

import Browser.Navigation
import Element exposing (Color, Device)
import UiFramework.ColorUtils as ColorUtils
import UiFramework.Configuration exposing (ThemeConfig, defaultThemeConfig)


type alias SharedState =
    { navKey : Browser.Navigation.Key -- used by other pages to navigate (through Browser.Navigation.pushUrl)
    , device : Device
    , themeConfig : ThemeConfig
    }


type SharedStateUpdate
    = UpdateDevice Device
    | NoUpdate


init : Device -> Browser.Navigation.Key -> SharedState
init device key =
    { navKey = key
    , device = device
    , themeConfig = defaultThemeConfig
    }


update : SharedState -> SharedStateUpdate -> SharedState
update sharedState updateMsg =
    case updateMsg of
        UpdateDevice device ->
            { sharedState | device = device }

        NoUpdate ->
            sharedState
