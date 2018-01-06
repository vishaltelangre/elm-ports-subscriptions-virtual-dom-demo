port module Main exposing (..)

import Html exposing (Html, br, div, h1, p, span, text)
import Html.Attributes exposing (style, class)
import Time exposing (Time, second)
import AnimationFrame


-- PORTS


port request : () -> Cmd msg


port receive : (WindowDimensions -> msg) -> Sub msg



-- MODEL


type alias WindowDimensions =
    { innerWidth : Float
    , innerHeight : Float
    , totalWidth : Float
    , totalHeight : Float
    }


type alias Model =
    { dimensions : WindowDimensions }


init : ( Model, Cmd Msg )
init =
    ( { dimensions = WindowDimensions 0 0 0 0 }, Cmd.none )



-- UPDATE


type Msg
    = Tick Time
    | OnReceive WindowDimensions


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick time ->
            ( model, request () )

        OnReceive dimensions ->
            ( { model | dimensions = dimensions }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every second Tick -- AnimationFrame.times Tick
        , receive OnReceive
        ]



-- VIEW


view : Model -> Html Msg
view ({ dimensions } as model) =
    let
        proportionate =
            flip (/) 2.5 >> toString >> flip (++) "px"

        outerBoxCss =
            [ ( "background", "#000" )
            , ( "margin", "20px" )
            , ( "position", "relative" )
            , ( "width", proportionate dimensions.totalWidth )
            , ( "height", proportionate dimensions.totalHeight )
            ]

        innerBoxCss =
            [ ( "color", "#fff" )
            , ( "verticalAlign", "middle" )
            , ( "background", "rgba(255, 0, 0, 0.5)" )
            , ( "width", proportionate dimensions.innerWidth )
            , ( "height", proportionate dimensions.innerHeight )
            , ( "lineHeight", proportionate dimensions.innerHeight )
            ]
    in
        div [ style outerBoxCss ]
            [ div [ style innerBoxCss ]
                [ span [] [ text <| toString dimensions.innerWidth ]
                , text " x "
                , span [] [ text <| toString dimensions.innerHeight ]
                ]
            ]



-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
