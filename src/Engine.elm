module Engine exposing (..)

import Random
import Models exposing (..)
import Time


nextPoint : Model -> Point
nextPoint model =
    case model.snake of
        ( x, y ) :: _ ->
            case nextDirection model of
                Up ->
                    if model.borders then
                        ( x, y - 1 )
                    else
                        let
                            yy =
                                y - 1

                            yyy =
                                if yy < 0 then
                                    gridSize0
                                else
                                    yy
                        in
                            ( x, yyy )

                Down ->
                    if model.borders then
                        ( x, y + 1 )
                    else
                        let
                            yy =
                                y + 1

                            yyy =
                                if yy > gridSize0 then
                                    0
                                else
                                    yy
                        in
                            ( x, yyy )

                Left ->
                    if model.borders then
                        ( x - 1, y )
                    else
                        let
                            xx =
                                x - 1

                            xxx =
                                if xx < 0 then
                                    gridSize0
                                else
                                    xx
                        in
                            ( xxx, y )

                Right ->
                    if model.borders then
                        ( x + 1, y )
                    else
                        let
                            xx =
                                x + 1

                            xxx =
                                if xx > gridSize0 then
                                    0
                                else
                                    xx
                        in
                            ( xxx, y )

        [] ->
            Debug.crash "Snake is empty"


collision : Model -> Point -> Bool
collision model point =
    if model.borders then
        collisionWithBorder point || collisionWithSnake model point
    else
        collisionWithSnake model point


collisionWithBorder : Point -> Bool
collisionWithBorder ( x, y ) =
    x < 0 || x > gridSize0 || y < 0 || y > gridSize0


collisionWithSnake : Model -> Point -> Bool
collisionWithSnake model point =
    List.member point model.snake


canChangeDirection : Direction -> Direction -> Bool
canChangeDirection from to =
    case to of
        Up ->
            from /= Down && from /= Up

        Down ->
            from /= Up && from /= Down

        Left ->
            from /= Right && from /= Left

        Right ->
            from /= Left && from /= Right


addDirection : Model -> Direction -> List Direction
addDirection model direction =
    List.append model.nextDirections [ direction ]


nextDirection : Model -> Direction
nextDirection model =
    case model.nextDirections of
        next :: _ ->
            next

        [] ->
            model.lastDirection


nextDirectionsTail : Model -> List Direction
nextDirectionsTail model =
    case model.nextDirections of
        _ :: tail ->
            tail

        [] ->
            []


lastDirection : Model -> Direction
lastDirection model =
    case List.reverse model.nextDirections of
        last :: _ ->
            last

        [] ->
            model.lastDirection


moveSnake : Model -> Point -> Bool -> Snake
moveSnake model point trim =
    let
        snake =
            if trim then
                (List.take (List.length model.snake - 1) model.snake)
            else
                model.snake
    in
        point :: snake


move : Model -> Point -> Bool -> Model
move model next trim =
    { model
        | snake = moveSnake model next trim
        , nextDirections = nextDirectionsTail model
        , lastDirection = lastDirection model
    }


newAppleCmd : Cmd Msg
newAppleCmd =
    Random.generate NewApple (Random.pair (Random.int 0 gridSize0) (Random.int 0 gridSize0))


score : Model -> Float
score model =
    let
        multiplier =
            case model.speed of
                Slow ->
                    1.0

                Fast ->
                    2.0
    in
        toFloat model.count * multiplier


highScore : Model -> Float
highScore model =
    if model.borders then
        model.highScoreBorders
    else
        model.highScoreNoBorders


moveInterval : Model -> Time.Time
moveInterval model =
    let
        speed =
            case model.speed of
                Slow ->
                    130

                Fast ->
                    80
    in
        Time.millisecond * speed


nextState : State -> State
nextState state =
    case state of
        Ready ->
            Playing

        Playing ->
            Paused

        Paused ->
            Playing

        Over ->
            Ready


nextSpeed : Speed -> Speed
nextSpeed speed =
    case speed of
        Slow ->
            Fast

        Fast ->
            Slow
