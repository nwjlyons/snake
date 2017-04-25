module Models exposing (..)

import Time
import TouchEvents


type Msg
    = NextState
    | MoveToState State
    | NextSpeed
    | MoveToSpeed Speed
    | NewApple Point
    | Move Direction
    | ReDraw Time.Time
    | ToggleBorders
    | SwipeStart TouchEvents.Touch
    | SwipeEnd TouchEvents.Touch
    | NoOp


type alias Point =
    ( Int, Int )


type alias Snake =
    List Point


type Square
    = Apple
    | SnakeSegment


type State
    = Ready
    | Playing
    | Paused
    | Over


type Speed
    = Slow
    | Fast


type Direction
    = Up
    | Down
    | Left
    | Right


type alias Model =
    { snake : Snake
    , apple : Point
    , state : State
    , speed : Speed
    , count : Int
    , nextDirections : List Direction
    , lastDirection : Direction
    , borders : Bool
    , highScoreBorders : Float
    , highScoreNoBorders : Float
    , swipeStart : TouchEvents.Touch
    , isNewHighScore : Bool
    }


gridSize : Int
gridSize =
    20


{-| Zero based grid size
-}
gridSize0 : Int
gridSize0 =
    gridSize - 1
