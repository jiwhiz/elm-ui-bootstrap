module Router exposing (DropdownMenuState(..), Model, Msg(..), Page(..), init, initWith, navigateTo, update, updateWith, viewApplication)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Element exposing (Element)
import Element.Background as Background
import Element.Events as Events
import Element.Font as Font
import FontAwesome.Styles
import Html exposing (Html)
import Page.Alert as Alert
import Page.Badge as Badge
import Page.Button as Button
import Page.Container as Container
import Page.Dropdown as Dropdown
import Page.GettingStarted as GettingStarted
import Page.Home as Home
import Page.Icon as Icon
import Page.Navbar as Navbar
import Page.NotFound as NotFound
import Page.Pagination as Pagination
import Page.Table as Table
import Page.Typography as Typography
import Ports
import Routes exposing (Route(..))
import SharedState exposing (SharedState, SharedStateUpdate, Theme(..))
import Task
import UiFramework exposing (WithContext, toElement)
import UiFramework.Navbar
import UiFramework.Types exposing (Role(..))
import Url
import Util



-- MODEL


type alias Model =
    { route : Routes.Route
    , currentPage : Page
    , navKey : Nav.Key
    , dropdownMenuState : DropdownMenuState
    , toggleMenuState : Bool
    }


type Page
    = HomePage Home.Model
    | GettingStartedPage GettingStarted.Model
    | ButtonPage Button.Model
    | AlertPage Alert.Model
    | BadgePage Badge.Model
    | ContainerPage Container.Model
    | DropdownPage Dropdown.Model
    | IconPage Icon.Model
    | NavbarPage Navbar.Model
    | PaginationPage Pagination.Model
    | TablePage Table.Model
    | TypographyPage Typography.Model
    | NotFoundPage NotFound.Model


type DropdownMenuState
    = AllClosed
    | ThemeSelectOpen



-- init with the NotFoundPage, but send a command where we look at the Url and change the page


init : Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init url key =
    let
        currentRoute =
            Routes.fromUrl url
    in
    ( { route = currentRoute
      , currentPage = NotFoundPage {}
      , navKey = key
      , dropdownMenuState = AllClosed
      , toggleMenuState = False
      }
    , (Task.perform identity << Task.succeed) <| UrlChanged url
    )



-- VIEW


viewApplication : (Msg -> msg) -> Model -> SharedState -> Browser.Document msg
viewApplication toMsg model sharedState =
    { title = tabBarTitle model
    , body =
        [ FontAwesome.Styles.css
        , view toMsg model sharedState
        ]
    }



-- title of our app (shows in tab bar)


tabBarTitle : Model -> String
tabBarTitle model =
    case model.currentPage of
        HomePage _ ->
            "Home"

        GettingStartedPage _ ->
            "Getting Started"

        ButtonPage _ ->
            "Button"

        AlertPage _ ->
            "Alert"

        BadgePage _ ->
            "Badge"

        ContainerPage _ ->
            "Container"

        DropdownPage _ ->
            "Dropdown"

        IconPage _ ->
            "Icon"

        NavbarPage _ ->
            "Navbar"

        PaginationPage _ ->
            "Pagination"

        TablePage _ ->
            "Table"

        TypographyPage _ ->
            "Typography"

        NotFoundPage _ ->
            "Not Found"


view : (Msg -> msg) -> Model -> SharedState -> Html msg
view toMsg model sharedState =
    let
        themeConfig =
            SharedState.getThemeConfig sharedState.theme
    in
    Element.el
        [ Element.width Element.fill
        , Element.height Element.fill
        , Background.color themeConfig.bodyBackground
        , Font.color <| themeConfig.fontColor themeConfig.bodyBackground
        , Element.paddingXY 0 50
        , Font.family themeConfig.fontConfig.fontFamily
        , Font.size 16 -- idk why I have to add this here. Somehow it automatically makes it 20??
        ]
        (content model sharedState)
        |> Element.layout
            [ Element.inFront <| navbar model sharedState
            , Font.family themeConfig.fontConfig.fontFamily
            ]
        |> Html.map toMsg


navbar : Model -> SharedState -> Element Msg
navbar model sharedState =
    let
        navbarState =
            { toggleMenuState = model.toggleMenuState
            , dropdownState = model.dropdownMenuState
            }

        context =
            { device = sharedState.device
            , themeConfig = SharedState.getThemeConfig sharedState.theme
            , parentRole = Nothing
            }

        brand =
            Element.row
                [ Events.onClick (NavigateTo Home)
                , Element.pointer
                ]
                [ Element.text "Elm Ui Bootstrap" ]

        homeItem =
            UiFramework.Navbar.linkItem (NavigateTo GettingStarted)
                |> UiFramework.Navbar.withMenuTitle "Getting Started"

        buttonsItem =
            UiFramework.Navbar.linkItem (NavigateTo Button)
                |> UiFramework.Navbar.withMenuTitle "Modules"

        examplesItem =
            UiFramework.Navbar.linkItem NoOp
                |> UiFramework.Navbar.withMenuTitle "Examples"
    in
    UiFramework.Navbar.default ToggleMenu
        |> UiFramework.Navbar.withBrand brand
        |> UiFramework.Navbar.withBackground Light
        |> UiFramework.Navbar.withMenuItems
            [ homeItem
            , buttonsItem
            , examplesItem
            ]
        |> UiFramework.Navbar.withExtraAttrs []
        |> UiFramework.Navbar.view navbarState
        |> UiFramework.toElement context


content : Model -> SharedState -> Element Msg
content model sharedState =
    case model.currentPage of
        HomePage pageModel ->
            Home.view sharedState pageModel
                |> Element.map HomeMsg

        GettingStartedPage pageModel ->
            GettingStarted.view sharedState pageModel
                |> Element.map GettingStartedMsg

        ButtonPage pageModel ->
            Button.view sharedState pageModel
                |> Element.map ButtonMsg

        AlertPage pageModel ->
            Alert.view sharedState pageModel
                |> Element.map AlertMsg

        BadgePage pageModel ->
            Badge.view sharedState pageModel
                |> Element.map BadgeMsg

        ContainerPage pageModel ->
            Container.view sharedState pageModel
                |> Element.map ContainerMsg

        DropdownPage pageModel ->
            Dropdown.view sharedState pageModel
                |> Element.map DropdownMsg

        IconPage pageModel ->
            Icon.view sharedState pageModel
                |> Element.map IconMsg

        NavbarPage pageModel ->
            Navbar.view sharedState pageModel
                |> Element.map NavbarMsg

        PaginationPage pageModel ->
            Pagination.view sharedState pageModel
                |> Element.map PaginationMsg

        TablePage pageModel ->
            Table.view sharedState pageModel
                |> Element.map TableMsg

        TypographyPage pageModel ->
            Typography.view sharedState pageModel
                |> Element.map TypographyMsg

        NotFoundPage pageModel ->
            NotFound.view sharedState pageModel
                |> Element.map NotFoundMsg



-- UPDATE


type Msg
    = UrlChanged Url.Url
    | NavigateTo Route
    | HomeMsg Home.Msg
    | GettingStartedMsg GettingStarted.Msg
    | ButtonMsg Button.Msg
    | AlertMsg Alert.Msg
    | BadgeMsg Badge.Msg
    | ContainerMsg Container.Msg
    | DropdownMsg Dropdown.Msg
    | IconMsg Icon.Msg
    | NavbarMsg Navbar.Msg
    | PaginationMsg Pagination.Msg
    | TableMsg Table.Msg
    | TypographyMsg Typography.Msg
    | NotFoundMsg NotFound.Msg
    | SelectTheme Theme
    | ToggleDropdown
    | ToggleMenu
    | NoOp


update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case ( msg, model.currentPage ) of
        ( UrlChanged url, _ ) ->
            let
                route =
                    Routes.fromUrl url

                ( newModel, newCmd, newSharedStateUpdate ) =
                    navigateTo route sharedState model
            in
            ( { newModel | route = route }
            , Cmd.batch [ newCmd ]
            , newSharedStateUpdate
            )

        ( NavigateTo route, _ ) ->
            -- changes url
            ( model
            , Util.navigate sharedState.navKey route
            , SharedState.NoUpdate
            )

        ( HomeMsg subMsg, HomePage subModel ) ->
            Home.update sharedState subMsg subModel
                |> updateWith HomePage HomeMsg model

        ( GettingStartedMsg subMsg, GettingStartedPage subModel ) ->
            GettingStarted.update sharedState subMsg subModel
                |> updateWith GettingStartedPage GettingStartedMsg model

        ( ButtonMsg subMsg, ButtonPage subModel ) ->
            Button.update sharedState subMsg subModel
                |> updateWith ButtonPage ButtonMsg model

        ( AlertMsg subMsg, AlertPage subModel ) ->
            Alert.update sharedState subMsg subModel
                |> updateWith AlertPage AlertMsg model

        ( BadgeMsg subMsg, BadgePage subModel ) ->
            Badge.update sharedState subMsg subModel
                |> updateWith BadgePage BadgeMsg model

        ( ContainerMsg subMsg, ContainerPage subModel ) ->
            Container.update sharedState subMsg subModel
                |> updateWith ContainerPage ContainerMsg model

        ( DropdownMsg subMsg, DropdownPage subModel ) ->
            Dropdown.update sharedState subMsg subModel
                |> updateWith DropdownPage DropdownMsg model

        ( IconMsg subMsg, IconPage subModel ) ->
            Icon.update sharedState subMsg subModel
                |> updateWith IconPage IconMsg model

        ( NavbarMsg subMsg, NavbarPage subModel ) ->
            Navbar.update sharedState subMsg subModel
                |> updateWith NavbarPage NavbarMsg model

        ( PaginationMsg subMsg, PaginationPage subModel ) ->
            Pagination.update sharedState subMsg subModel
                |> updateWith PaginationPage PaginationMsg model

        ( TableMsg subMsg, TablePage subModel ) ->
            Table.update sharedState subMsg subModel
                |> updateWith TablePage TableMsg model

        ( TypographyMsg subMsg, TypographyPage subModel ) ->
            Typography.update sharedState subMsg subModel
                |> updateWith TypographyPage TypographyMsg model

        ( NotFoundMsg subMsg, NotFoundPage subModel ) ->
            NotFound.update sharedState subMsg subModel
                |> updateWith NotFoundPage NotFoundMsg model

        ( SelectTheme theme, _ ) ->
            ( { model | dropdownMenuState = AllClosed }
            , Cmd.none
            , SharedState.UpdateTheme theme
            )

        ( ToggleDropdown, _ ) ->
            let
                dropdownMenuState =
                    if model.dropdownMenuState == ThemeSelectOpen then
                        AllClosed

                    else
                        ThemeSelectOpen
            in
            ( { model | dropdownMenuState = dropdownMenuState }
            , Cmd.none
            , SharedState.NoUpdate
            )

        ( ToggleMenu, _ ) ->
            ( { model | toggleMenuState = not model.toggleMenuState }
            , Cmd.none
            , SharedState.NoUpdate
            )

        ( _, _ ) ->
            -- message arrived for the wrong page. Ignore.
            ( model, Cmd.none, SharedState.NoUpdate )


updateWith :
    (subModel -> Page)
    -> (subMsg -> Msg)
    -> Model
    -> ( subModel, Cmd subMsg, SharedStateUpdate )
    -> ( Model, Cmd Msg, SharedStateUpdate )
updateWith toPage toMsg model ( subModel, subCmd, subSharedStateUpdate ) =
    ( { model | currentPage = toPage subModel }
    , Cmd.map toMsg subCmd
    , subSharedStateUpdate
    )


navigateTo : Route -> SharedState -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
navigateTo route sharedState model =
    case route of
        Home ->
            Home.init |> initWith HomePage HomeMsg model SharedState.NoUpdate

        GettingStarted ->
            GettingStarted.init |> initWith GettingStartedPage GettingStartedMsg model SharedState.NoUpdate

        Button ->
            Button.init |> initWith ButtonPage ButtonMsg model SharedState.NoUpdate

        Alert ->
            Alert.init |> initWith AlertPage AlertMsg model SharedState.NoUpdate

        Badge ->
            Badge.init |> initWith BadgePage BadgeMsg model SharedState.NoUpdate

        Container ->
            Container.init |> initWith ContainerPage ContainerMsg model SharedState.NoUpdate

        Dropdown ->
            Dropdown.init |> initWith DropdownPage DropdownMsg model SharedState.NoUpdate

        Icon ->
            Icon.init |> initWith IconPage IconMsg model SharedState.NoUpdate

        Navbar ->
            Navbar.init |> initWith NavbarPage NavbarMsg model SharedState.NoUpdate

        Pagination ->
            Pagination.init |> initWith PaginationPage PaginationMsg model SharedState.NoUpdate

        Table ->
            Table.init |> initWith TablePage TableMsg model SharedState.NoUpdate

        Typography ->
            Typography.init |> initWith TypographyPage TypographyMsg model SharedState.NoUpdate

        NotFound ->
            NotFound.init |> initWith NotFoundPage NotFoundMsg model SharedState.NoUpdate


initWith : (subModel -> Page) -> (subMsg -> Msg) -> Model -> SharedStateUpdate -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg, SharedStateUpdate )
initWith toPage toMsg model sharedStateUpdate ( subModel, subCmd ) =
    ( { model | currentPage = toPage subModel }
    , Cmd.batch
        [ Cmd.map toMsg subCmd
        , Ports.changedUrl ()
        ]
    , sharedStateUpdate
    )
