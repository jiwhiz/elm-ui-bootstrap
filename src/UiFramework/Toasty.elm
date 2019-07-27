module UiFramework.Toasty exposing (view)

import Element exposing (Element, html)
import Toasty
import Toasty.Defaults


view : (Toasty.Msg Toasty.Defaults.Toast -> msg) -> Toasty.Stack Toasty.Defaults.Toast -> Element msg
view toMsg toasties =
    Toasty.view Toasty.Defaults.config Toasty.Defaults.view toMsg toasties
        |> html
