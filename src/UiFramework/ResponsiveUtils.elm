module UiFramework.ResponsiveUtils exposing (classifyDevice)

import Element exposing (Device, DeviceClass(..), Orientation(..))


{-| Use Bootstrap responsive breakpoints:
<https://getbootstrap.com/docs/4.3/layout/overview/#responsive-breakpoints>
-}
classifyDevice : { window | height : Int, width : Int } -> Device
classifyDevice window =
    { class =
        if window.width < 768 then
            Phone

        else if window.width < 992 then
            Tablet

        else if window.width < 1200 then
            Desktop

        else
            BigDesktop
    , orientation =
        if window.width < window.height then
            Portrait

        else
            Landscape
    }
