module Flags exposing (..)

import Models exposing (..)
import Json.Encode as Encode
import Json.Decode as Decode


type alias Flags =
    { speed : Maybe String
    , highScoreBorders : Maybe String
    , highScoreNoBorders : Maybe String
    , borders : Maybe String
    }


decodeSpeed : Maybe String -> Speed
decodeSpeed speed =
    case speed of
        Just speedAsString ->
            if speedAsString == "Fast" then
                Fast
            else
                {- For all other values return Slow -}
                Slow

        Nothing ->
            Slow


decodeHighScoreBorders : Maybe String -> Float
decodeHighScoreBorders score =
    case score of
        Just scoreAsString ->
            case Decode.decodeString Decode.float scoreAsString of
                Ok score ->
                    score

                Err _ ->
                    0

        Nothing ->
            0


decodeHighScoreNoBorders : Maybe String -> Float
decodeHighScoreNoBorders score =
    case score of
        Just scoreAsString ->
            case Decode.decodeString Decode.float scoreAsString of
                Ok score ->
                    score

                Err _ ->
                    0

        Nothing ->
            0


decodeBorders : Maybe String -> Bool
decodeBorders hasBorders =
    case hasBorders of
        Just borders ->
            if borders == "True" then
                True
            else
                False

        Nothing ->
            False
