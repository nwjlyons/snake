module Views exposing (view)

import Html exposing (Html, div, text, i, ul, li, span)
import Html.Attributes exposing (class, id, style)
import Html.Events exposing (onClick)
import Models exposing (..)
import Engine
import TouchEvents


-- Main view function


view : Model -> Html Msg
view model =
    div [ id "view" ] [ viewHeader model, viewGrid model ]


viewHeader : Model -> Html Msg
viewHeader model =
    div [ id "header" ]
        [ viewBorders model
        , viewSpeed model
        , viewControls model
        , viewControlsStop model
        , viewHighScore model
        , viewScore model
        ]



-- Header


viewControls : Model -> Html Msg
viewControls model =
    let
        classes =
            case model.state of
                Ready ->
                    "play"

                Playing ->
                    "pause"

                Paused ->
                    "play"

                Over ->
                    "undo"
    in
        div
            [ id "controls-one", class classes, onClick NextState ]
            [ div [ class "header-title" ] [ text "Controls" ], div [ class "header-content" ] [ i [ class ("fa fa-" ++ classes) ] [] ] ]


viewControlsStop : Model -> Html Msg
viewControlsStop model =
    let
        html =
            div
                [ id "controls-two", onClick (MoveToState Ready) ]
                [ div [ class "header-title" ] [], div [ class "header-content" ] [ i [ class "fa fa-stop" ] [] ] ]
    in
        case model.state of
            Playing ->
                html

            Paused ->
                html

            _ ->
                text ""


speedTally : Speed -> Html Msg
speedTally speed =
    text <|
        case speed of
            Slow ->
                "1"

            Fast ->
                "2"


viewSpeed : Model -> Html Msg
viewSpeed model =
    let
        canChangeSpeed =
            case model.state of
                Ready ->
                    "can-change-speed"

                _ ->
                    ""
    in
        div [ id "speed", class canChangeSpeed, onClick NextSpeed ] [ div [ class "header-title" ] [ text "Speed" ], div [ class "header-content" ] [ speedTally model.speed ] ]


viewBorders : Model -> Html Msg
viewBorders model =
    let
        bordersOnOff =
            if model.borders then
                "borders-on"
            else
                ""
    in
        div [ id "borders", onClick ToggleBorders, class bordersOnOff ] [ div [ class "header-title" ] [ text "Borders" ], div [ class "header-content" ] [ i [ class "fa fa-square-o" ] [] ] ]


viewScore : Model -> Html Msg
viewScore model =
    div [ id "score" ] [ div [ class "header-title" ] [ text "Score" ], div [ class "header-content" ] [ text <| toString <| Engine.score model ] ]


viewHighScore : Model -> Html Msg
viewHighScore model =
    let
        newHighScore =
            case model.state of
                Over ->
                    if model.isNewHighScore then
                        "new-high-score"
                    else
                        ""

                _ ->
                    ""
    in
        div [ id "high-score", class newHighScore ]
            [ div [ class "header-title" ] [ text "Best" ]
            , div [ class "header-content" ]
                [ text <|
                    toString
                        (if model.borders then
                            model.highScoreBorders
                         else
                            model.highScoreNoBorders
                        )
                ]
            ]



-- Grid


gridRange : List Int
gridRange =
    List.range 0 gridSize0


viewGrid : Model -> Html Msg
viewGrid model =
    div
        [ id "swipe-area", TouchEvents.onTouchStart SwipeStart, TouchEvents.onTouchEnd SwipeEnd ]
        [ div [ id "grid" ] (List.map (viewRow model) gridRange) ]


cellWidth : String
cellWidth =
    toString (100.0 / toFloat gridSize) ++ "%"


viewRow : Model -> Int -> Html Msg
viewRow model row =
    div [ style [ ( "height", cellWidth ) ] ] (List.map (viewPoint model row) gridRange)


viewPoint : Model -> Int -> Int -> Html Msg
viewPoint model column row =
    let
        point =
            ( row, column )

        classes =
            if List.member point model.snake then
                "snake"
            else if point == model.apple then
                "apple"
            else
                ""
    in
        div [ class classes, style [ ( "width", cellWidth ) ] ] []
