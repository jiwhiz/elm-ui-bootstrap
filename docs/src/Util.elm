module Util exposing (firacode, highlightCode, navigate, text, uiHighlightCode, flip, tupleExtend)

{-| code from <https://github.com/rundis/elm-bootstrap.info/blob/master/src/Util.elm>
-}

import Browser.Navigation as Navigation
import Element exposing (Attribute, Element)
import Element.Font as Font
import Html
import Html.Attributes as Attr
import Markdown
import Routes
import UiFramework exposing (WithContext)


text : String -> WithContext context msg
text str =
    UiFramework.uiText (\_ -> str)




flip : (a -> b -> c) -> (b -> a -> c)
flip f b a =
    f a b


tupleExtend : ( a, b ) -> c -> ( a, b, c )
tupleExtend ( a, b ) c =
    ( a, b, c )



-- into a UiElement


uiHighlightCode : String -> String -> WithContext context msg
uiHighlightCode lang =
    highlightCode lang
        >> (\elem -> \_ -> elem)
        >> UiFramework.fromElement



-- into an Element


highlightCode : String -> String -> Element msg
highlightCode language code =
    Markdown.toHtml
        []
        ("```" ++ language ++ code ++ "```")
        |> List.singleton
        |> Html.div
            [ Attr.style "width" "100%"
            ]
        |> Element.html


firacode : Attribute msg
firacode =
    Font.family
        [ Font.typeface "Fira Code"
        , Font.serif
        ]



-- navigate and push a flag to highlight code


navigate : Navigation.Key -> Routes.Route -> Cmd msg
navigate navKey route =
    Navigation.pushUrl navKey (Routes.toUrlString route) 
