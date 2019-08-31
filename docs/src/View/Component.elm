module View.Component exposing (Header, componentNavbar, section, title, viewHeader, wrappedText, code)

{-| Reusable view functions for each Component page
    I need to rename this!
-}

import Element exposing (Color, fill, height, width, Attribute)
import Element.Background as Background
import Element.Events as Events
import Element.Font as Font
import Element.Border as Border
import Routes exposing (Route(..))
import UiFramework exposing (WithContext)
import UiFramework.ColorUtils as ColorUtils
import UiFramework.Container as Container
import UiFramework.Typography as Typography
import Util


type alias Header =
    { title : String
    , description : String
    }


viewHeader : Header -> WithContext { c | purpleColor : Color } msg
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
                    UiFramework.uiParagraph [] [ Util.text pageContent.title ]
                , UiFramework.uiParagraph []
                    [ Typography.textLead [] <| Util.text pageContent.description ]
                ]
    in
    UiFramework.flatMap
        (\context ->
            Container.jumbotron
                |> Container.withFullWidth
                |> Container.withChild (Container.simple [] jumbotronContent)
                |> Container.withExtraAttrs [ Background.color context.purpleColor ]
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
                    Typography.textSmall [ Element.pointer, Element.padding 8 ] (Util.text name)

                else
                    Typography.textSmall
                        [ Font.color (ColorUtils.hexToColor "#99979c")
                        , Element.mouseOver [ Font.color (ColorUtils.hexToColor "#8e869d") ]
                        , Element.pointer
                        , Events.onClick (navigateToMsg r)
                        , Element.padding 8
                        ]
                        (Util.text name)
            )
            routeNameList



-- for things like "Basic example" and "Configurations"


title : String -> WithContext c msg
title str =
    Typography.display4 [ Font.size 48 ] (Util.text str)



-- for the separate parts in the configurations. This is just with Typography.h1


section : String -> WithContext c msg
section str =
    Typography.h1 [] (Util.text str)



-- basically a Util.text wrapped in a uiParagraph


wrappedText : String -> WithContext c msg
wrappedText str =
    UiFramework.uiParagraph []
        [ Util.text str ]

-- kinda like strings wrapped in tick marks 
code : String -> WithContext c msg 
code str =
    Typography.span 
        [ Util.firacode
        , Font.size 14
        , Element.padding 3
        , Border.rounded 3
        , Background.color <| Element.rgba 0 0 0 0.04 
        , Element.width Element.shrink
        ]
        (Util.text str)

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
    ]
