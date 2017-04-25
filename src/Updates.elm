module Updates exposing (..)

import Time
import Models exposing (..)
import Engine
import Init
import Ports
import TouchEvents


-- Main update function


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NextState ->
            nextState model

        MoveToState state ->
            moveToState model state

        NextSpeed ->
            nextSpeed model

        MoveToSpeed speed ->
            moveToSpeed model speed

        Move direction ->
            move model direction

        NewApple point ->
            newApple model point

        ReDraw tick ->
            redraw model tick

        ToggleBorders ->
            toggleBorders model

        SwipeStart touch ->
            swipeStart model touch

        SwipeEnd touch ->
            swipeEnd model touch

        _ ->
            model ! []



-- Sub update functions


nextState : Model -> ( Model, Cmd Msg )
nextState model =
    let
        nextState =
            Engine.nextState model.state
    in
        case nextState of
            Ready ->
                Init.resetModelForNewGame model ! []

            _ ->
                { model | state = Engine.nextState model.state } ! []


moveToState : Model -> State -> ( Model, Cmd Msg )
moveToState model state =
    case state of
        Ready ->
            Init.resetModelForNewGame model ! []

        _ ->
            model ! []


nextSpeed : Model -> ( Model, Cmd Msg )
nextSpeed model =
    case model.state of
        Ready ->
            let
                nextSpeed =
                    Engine.nextSpeed model.speed
            in
                { model | speed = nextSpeed } ! [ Ports.saveSpeed nextSpeed ]

        _ ->
            model ! []


moveToSpeed : Model -> Speed -> ( Model, Cmd Msg )
moveToSpeed model speed =
    case model.state of
        Ready ->
            { model | speed = speed } ! [ Ports.saveSpeed speed ]

        _ ->
            model ! []


move : Model -> Direction -> ( Model, Cmd Msg )
move model direction =
    case model.state of
        Playing ->
            if Engine.canChangeDirection (Engine.lastDirection model) direction then
                { model | nextDirections = Engine.addDirection model direction } ! []
            else
                model ! []

        _ ->
            model ! []


redraw : Model -> Time.Time -> ( Model, Cmd Msg )
redraw model tick =
    case model.state of
        Playing ->
            let
                next =
                    Engine.nextPoint model
            in
                if Engine.collision model next then
                    if model.borders then
                        let
                            score =
                                Engine.score model

                            isNewHighScore =
                                score > model.highScoreBorders

                            highScoreBorders =
                                if isNewHighScore then
                                    score
                                else
                                    model.highScoreBorders
                        in
                            { model
                                | state = Over
                                , highScoreBorders = highScoreBorders
                                , isNewHighScore = isNewHighScore
                            }
                                ! [ Ports.saveHighScoreBorders highScoreBorders ]
                    else
                        let
                            score =
                                Engine.score model

                            isNewHighScore =
                                score > model.highScoreNoBorders

                            highScoreNoBorders =
                                if isNewHighScore then
                                    score
                                else
                                    model.highScoreNoBorders
                        in
                            { model
                                | state = Over
                                , highScoreNoBorders = highScoreNoBorders
                                , isNewHighScore = isNewHighScore
                            }
                                ! [ Ports.saveHighScoreNoBorders highScoreNoBorders ]
                else if model.apple == next then
                    let
                        modelWithUpdatedCount =
                            { model | count = model.count + 1 }
                    in
                        (Engine.move modelWithUpdatedCount next False) ! [ Engine.newAppleCmd ]
                else
                    (Engine.move model next True) ! []

        _ ->
            model ! []


newApple : Model -> Point -> ( Model, Cmd Msg )
newApple model apple =
    let
        validApple =
            if List.member apple model.snake then
                False
            else if apple == model.apple then
                False
            else
                True
    in
        if validApple then
            { model | apple = apple } ! []
        else
            model ! [ Engine.newAppleCmd ]


toggleBorders : Model -> ( Model, Cmd Msg )
toggleBorders model =
    case model.state of
        Ready ->
            let
                hasBorders =
                    not model.borders
            in
                { model | borders = hasBorders } ! [ Ports.saveBorders hasBorders ]

        _ ->
            model ! []


swipeStart : Model -> TouchEvents.Touch -> ( Model, Cmd Msg )
swipeStart model touch =
    case model.state of
        Playing ->
            { model | swipeStart = touch } ! []

        _ ->
            model ! []


swipeDirection : TouchEvents.Touch -> TouchEvents.Touch -> TouchEvents.Direction
swipeDirection start end =
    let
        xSize =
            abs (start.clientX - end.clientX)

        ySize =
            abs (start.clientY - end.clientY)
    in
        if xSize > ySize then
            TouchEvents.getDirectionX start.clientX end.clientX
        else
            TouchEvents.getDirectionY start.clientY end.clientY


swipeEnd : Model -> TouchEvents.Touch -> ( Model, Cmd Msg )
swipeEnd model end =
    case model.state of
        Playing ->
            case swipeDirection model.swipeStart end of
                TouchEvents.Up ->
                    move model Up

                TouchEvents.Down ->
                    move model Down

                TouchEvents.Left ->
                    move model Left

                TouchEvents.Right ->
                    move model Right

        _ ->
            model ! []
