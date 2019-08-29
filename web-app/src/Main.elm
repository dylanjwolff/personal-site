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
import Bootstrap.Modal as Modal


type alias Flags =
    {}

type alias Model =
    { navKey : Navigation.Key
    , page : Page
    , navState : Navbar.State
    , modalVisibility : Modal.Visibility
    }

type Page
    = Home
    | CV
    | Modules
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
            urlUpdate url { navKey = key, navState = navState, page = Home, modalVisibility= Modal.hidden }
    in
        ( model, Cmd.batch [ urlCmd, navCmd ] )




type Msg
    = UrlChange Url
    | ClickedLink UrlRequest
    | NavMsg Navbar.State
    | CloseModal
    | ShowModal


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

        CloseModal ->
            ( { model | modalVisibility = Modal.hidden }
            , Cmd.none
            )

        ShowModal ->
            ( { model | modalVisibility = Modal.shown }
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
        , UrlParser.map Modules (s "modules")
        ]


view : Model -> Browser.Document Msg
view model =
    { title = "Dylan Wolff"
    , body =
        [ div []
            [ menu model
            , mainContent model
            , modal model
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
            , Navbar.itemLink [ href "#modules" ] [ text "Modules" ]
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

            Modules ->
                pageModules model

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
                    <| Markdown.toHtml Nothing "## About Me: \n I'm a graduate student at ETH Zurich pursuing a masters in Computer Science with a focus in Information Security. Specifically I am interested in leveraging static and dynamic program analysis (and verification) techniques to find and prevent bugs in software. Before starting my masters, I worked at Mathworks on a variety of projects, mostly involving the testing and deployment infrastructure for web applications. "
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
                    <| Markdown.toHtml Nothing "## Fun Facts: \n I'm a recovering ultimate frisbee addict, after 12 years of competative play, starting in high school. In that time I played in two different semi-professional leagues and also won a world championship in 2013 with team USA in Toronto."
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
            Grid.col []
            [
                img [src "GitHub-Mark-32px.png"] [],
                img [src "LI-In-Bug.png", width 40, height 32] []
            ]
        ],
        Grid.row [] [
            Grid.col [] [
                div []
                    <| Markdown.toHtml Nothing "### EDUCATION \n ETHZ, BC"
            ]
        ]

    ]


pageModules : Model -> List (Html Msg)
pageModules model =
    [ h1 [] [ text "Modules" ]
    , Listgroup.ul
        [ Listgroup.li [] [ text "Alert" ]
        , Listgroup.li [] [ text "Badge" ]
        , Listgroup.li [] [ text "Card" ]
        ]
    ]


pageNotFound : List (Html Msg)
pageNotFound =
    [ h1 [] [ text "Not found" ]
    , text "SOrry couldn't find that page"
    ]


modal : Model -> Html Msg
modal model =
    Modal.config CloseModal
        |> Modal.small
        |> Modal.h4 [] [ text "Getting started ?" ]
        |> Modal.body []
            [ Grid.containerFluid []
                [ Grid.row []
                    [ Grid.col
                        [ Col.xs6 ]
                        [ text "Col 1" ]
                    , Grid.col
                        [ Col.xs6 ]
                        [ text "Col 2" ]
                    ]
                ]
            ]
        |> Modal.view model.modalVisibility
