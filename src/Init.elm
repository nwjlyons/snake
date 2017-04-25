module Init exposing (init, initSnake, resetModelForNewGame)

import Models exposing (..)
import Flags exposing (..)
import Json.Decode as Decode
import TouchEvents


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        speed =
            Flags.decodeSpeed flags.speed

        highScoreBorders =
            Flags.decodeHighScoreBorders flags.highScoreBorders

        highScoreNoBorders =
            Flags.decodeHighScoreNoBorders flags.highScoreNoBorders

        hasBorders =
            Flags.decodeBorders flags.borders
    in
        initModel speed highScoreBorders highScoreNoBorders hasBorders ! []



{- Speed and Highscore will come from Flags. They will come from localStorage. -}


initModel : Speed -> Float -> Float -> Bool -> Model
initModel speed highScoreBorders highScoreNoBorders borders =
    { snake = initSnake
    , apple = ( 3, 2 )
    , state = Ready
    , speed = speed
    , count = 0
    , nextDirections = []
    , lastDirection = Right
    , borders = borders
    , highScoreBorders = highScoreBorders
    , highScoreNoBorders = highScoreNoBorders
    , swipeStart = TouchEvents.emptyTouch
    , isNewHighScore = False
    }


resetModelForNewGame : Model -> Model
resetModelForNewGame model =
    initModel model.speed model.highScoreBorders model.highScoreNoBorders model.borders


initSnake : Snake
initSnake =
    let
        middle_row =
            gridSize // 2
    in
        [ ( middle_row, middle_row )
        , ( middle_row - 1, middle_row )
        , ( middle_row - 2, middle_row )
        , ( middle_row - 3, middle_row )
        ]
