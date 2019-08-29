module Main exposing (main)

import Markdown
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Browser.Navigation as Navigation
import Browser exposing (UrlRequest)
import Url exposing (Url)
import Url.Parser as UrlParser exposing ((</>), Parser, s, top)
import Bootstrap.Navbar as Navbar
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row 
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Button as Button
import Bootstrap.ListGroup as Listgroup
import Bootstrap.Utilities.Flex as Flex
import HomeMD
import CvMD

type alias Flags =
    {}

type alias Model =
    { navKey : Navigation.Key
    , page : Page
    , navState : Navbar.State
    }

type Page
    = Home
    | CV
    | Projects
    | NotFound


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = UrlChange
        }

init : Flags -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( navState, navCmd ) =
            Navbar.initialState NavMsg

        ( model, urlCmd ) =
            urlUpdate url { navKey = key, navState = navState, page = Home }
    in
        ( model, Cmd.batch [ urlCmd, navCmd ] )


type Msg
    = UrlChange Url
    | ClickedLink UrlRequest
    | NavMsg Navbar.State


subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navState NavMsg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedLink req ->
             case req of
                 Browser.Internal url ->
                     ( model, Navigation.pushUrl model.navKey <| Url.toString url )

                 Browser.External href ->
                     ( model, Navigation.load href )


        UrlChange url ->
            urlUpdate url model

        NavMsg state ->
            ( { model | navState = state }
            , Cmd.none
            )

urlUpdate : Url -> Model -> ( Model, Cmd Msg )
urlUpdate url model =
    case decode url of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just route ->
            ( { model | page = route }, Cmd.none )


decode : Url -> Maybe Page
decode url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
    |> UrlParser.parse routeParser


routeParser : Parser (Page -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map Home top
        , UrlParser.map CV (s "CV")
        , UrlParser.map Projects (s "projects")
        ]


view : Model -> Browser.Document Msg
view model =
    { title = "Dylan Wolff"
    , body =
        [ div []
            [ menu model
            , mainContent model
            ]
        ]
    }



menu : Model -> Html Msg
menu model =
    Navbar.config NavMsg
        |> Navbar.withAnimation
        |> Navbar.primary
        |> Navbar.brand [ href "#" ] [ text "Dylan Wolff" ]
        |> Navbar.items
            [ Navbar.itemLink [ href "#CV" ] [ text "CV" ]
            , Navbar.itemLink [ href "#projects" ] [ text "Projects" ]
            , Navbar.itemLink [ ] [ ]
            ]
        |> Navbar.customItems [
            Navbar.customItem 
                <| div [] [
                    a [href "https://github.com/wolffdy"] [
                        img [src "GitHub-Mark-Light-64px.png", height 32, width 32] []
                    ],
                    text "\t",
                    a [href "https://www.linkedin.com/in/dylan-j-wolff"] [
                        img [src "linkedin-light.png", height 32, width 32] []
                    ]
                ]
        ]
        |> Navbar.view model.navState


mainContent : Model -> Html Msg
mainContent model =
    Grid.container [] <|
        case model.page of
            Home ->
                pageHome model

            CV ->
                pageCV model

            Projects ->
                pageProjects model

            NotFound ->
                pageNotFound


pageHome : Model -> List (Html Msg)
pageHome model = [
        Grid.row [] [
            Grid.col [] [
                Html.br [] []
            ]
        ],
        Grid.row [ Row.betweenXs ] [
            Grid.col [ Col.md6, Col.orderMd12] [
                div []
                    <| Markdown.toHtml Nothing HomeMD.aboutMe
            ],
            Grid.col [ Col.md6, Col.orderMd1 ] [
                img [src "goat_cosine.png", class "img-fluid"] [],
                Html.br [] [] 
            ]
        ],
        Grid.row [] [
            Grid.col [] [
                Html.br [] []
            ]
        ],
        Grid.row [ Row.aroundXs ] [
            Grid.col [ Col.md6 ] [
                div []
                    <| Markdown.toHtml Nothing HomeMD.funFacts
            ],
            Grid.col [ Col.md6 ] [
                img [src "fris_cosine.png", class "img-fluid"] []
            ]            
        ],
        Grid.row [] [
            Grid.col [] [
                Html.br [] []
            ]
        ]
    ]


pageCV : Model -> List (Html Msg)
pageCV model =
    [ 
        Grid.row [] [
            Grid.col [] [
                div []
                    <| Markdown.toHtml Nothing CvMD.cv
            ]
        ]

    ]


pageProjects : Model -> List (Html Msg)
pageProjects model =
    [ h1 [] [ text "Projects" ] ]


pageNotFound : List (Html Msg)
pageNotFound =
    [ h1 [] [ text "Not found" ]
    , text "Sorry couldn't find that page"
    ]
