module Subscriptions exposing (subscriptions)

import Keyboard
import Time
import Models exposing (..)
import Engine


-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        subs =
            [ Keyboard.downs onKeyDown ]

        {- Only ReDraw if game is in playing state. To make the Debugger easier to read. -}
        subs1 =
            case model.state of
                Playing ->
                    Time.every (Engine.moveInterval model) ReDraw :: subs

                _ ->
                    subs
    in
        Sub.batch subs1


onKeyDown : Keyboard.KeyCode -> Msg
onKeyDown key =
    case key of
        -- Up arrow
        38 ->
            Move Up

        -- Down arrow
        40 ->
            Move Down

        -- Left arrow
        37 ->
            Move Left

        -- Right arrow
        39 ->
            Move Right

        -- Spacebar
        32 ->
            NextState

        -- One
        49 ->
            MoveToSpeed Slow

        -- Two
        50 ->
            MoveToSpeed Fast

        -- Letter B
        66 ->
            ToggleBorders

        -- Esc
        27 ->
            MoveToState Ready

        _ ->
            NoOp
