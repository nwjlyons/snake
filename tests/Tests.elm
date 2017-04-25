module Tests exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, tuple, string)
import String
import Snake


all : Test
all =
    describe "Elm Snake Unit Tests"
        [ describe "Collision Tests"
            [ test "collisionWithBorder" <|
                \() ->
                    Expect.true "Point should be true" <| Snake.collisionWithBorder (0, 0)
                    ,
              test "collisionWithBorder" <|
                \() ->
                    Expect.false "Point should be false" <| Snake.collisionWithBorder (-1, 0)
            ]
        ]
