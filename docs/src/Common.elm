module Common exposing
    ( Header
    , code
    , componentNavbar
    , highlightCode
    , roleAndNameList
    , section
    , title
    , viewHeader
    , wrappedText
    )

import Element exposing (Attribute, Color, fill, height, width)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Html
import Html.Attributes as Attr
import Markdown
import Routes exposing (Route(..))
import UiFramework exposing (WithContext)
import UiFramework.ColorUtils as ColorUtils
import UiFramework.Container as Container
import UiFramework.Types exposing (Role(..))
import UiFramework.Typography as Typography


type alias Header =
    { title : String
    , description : String
    }


viewHeader : Header -> WithContext c msg
viewHeader pageContent =
    let
        jumbotronContent =
            UiFramework.uiColumn
                [ height fill
                , width fill
                , Element.spacing 16
                , Font.color (Element.rgb 1 1 1)
                ]
                [ Typography.display3 [] <|
                    UiFramework.uiParagraph [] [ UiFramework.uiText pageContent.title ]
                , UiFramework.uiParagraph []
                    [ Typography.textLead [] <| UiFramework.uiText pageContent.description ]
                ]
    in
    UiFramework.flatMap
        (\context ->
            Container.jumbotron
                |> Container.withFullWidth
                |> Container.withChild (Container.simple [] jumbotronContent)
                |> Container.withExtraAttrs [ Background.color context.themeConfig.globalConfig.colors.purple ]
                |> Container.view
        )


componentNavbar : (Route -> msg) -> Route -> WithContext c msg
componentNavbar navigateToMsg route =
    UiFramework.uiColumn
        []
    <|
        List.map
            (\( r, name ) ->
                if r == route then
                    Typography.textSmall [ Element.pointer, Element.padding 8 ] (UiFramework.uiText name)

                else
                    Typography.textSmall
                        [ Font.color (ColorUtils.hexToColor "#99979c")
                        , Element.mouseOver [ Font.color (ColorUtils.hexToColor "#8e869d") ]
                        , Element.pointer
                        , Events.onClick (navigateToMsg r)
                        , Element.padding 8
                        ]
                        (UiFramework.uiText name)
            )
            routeNameList



-- for things like "Basic example" and "Configurations"


title : String -> WithContext c msg
title str =
    Typography.display4 [ Font.size 48 ] (UiFramework.uiText str)



-- for the separate parts in the configurations. This is just with Typography.h1


section : String -> WithContext c msg
section str =
    Typography.h1 [] (UiFramework.uiText str)



-- basically a  UiFramework.uiText wrapped in a uiParagraph


wrappedText : String -> WithContext c msg
wrappedText str =
    UiFramework.uiParagraph []
        [ UiFramework.uiText str ]



-- kinda like strings wrapped in tick marks


code : String -> WithContext c msg
code str =
    Typography.span
        [ firacode
        , Font.size 14
        , Element.padding 3
        , Border.rounded 3
        , Background.color <| Element.rgba 0 0 0 0.04
        , Element.width Element.shrink
        ]
        (UiFramework.uiText str)


firacode : Attribute msg
firacode =
    Font.family
        [ Font.typeface "Fira Code"
        , Font.serif
        ]



-- uiHighlightCode : String -> String -> WithContext context msg
-- uiHighlightCode lang =
--     markdownCode lang
--         >> (\elem -> \_ -> elem)
--         >> UiFramework.fromElement


highlightCode : String -> String -> WithContext context msg
highlightCode languageStr codeStr =
    UiFramework.fromElement
        (\_ ->
            Markdown.toHtml
                []
                ("```" ++ languageStr ++ codeStr ++ "```")
                |> List.singleton
                |> Html.div
                    [ Attr.style "width" "100%"
                    ]
                |> Element.html
        )


routeNameList : List ( Route, String )
routeNameList =
    [ ( Button, "Button" )
    , ( Alert, "Alert" )
    , ( Badge, "Badge" )
    , ( Container, "Container" )
    , ( Dropdown, "Dropdown" )
    , ( Icon, "Icon" )
    , ( Navbar, "Navbar" )
    , ( Pagination, "Pagination" )
    , ( Table, "Table" )
    , ( Typography, "Typography" )
    , ( Form, "Form" )
    ]


roleAndNameList : List ( Role, String )
roleAndNameList =
    [ ( Primary, "Primary" )
    , ( Secondary, "Secondary" )
    , ( Success, "Success" )
    , ( Info, "Info" )
    , ( Warning, "Warning" )
    , ( Danger, "Danger" )
    , ( Light, "Light" )
    , ( Dark, "Dark" )
    ]
