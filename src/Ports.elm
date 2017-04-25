port module Ports exposing (..)

import Json.Encode as Encode
import Models exposing (..)


port setCache : ( String, String ) -> Cmd msg


saveSpeed : Speed -> Cmd msg
saveSpeed speed =
    setCache ( "speed", toString speed )


saveHighScoreBorders : Float -> Cmd msg
saveHighScoreBorders score =
    setCache ( "highScoreBorders", toString score )


saveHighScoreNoBorders : Float -> Cmd msg
saveHighScoreNoBorders score =
    setCache ( "highScoreNoBorders", toString score )


saveBorders : Bool -> Cmd msg
saveBorders hasBorders =
    setCache ( "borders", toString hasBorders )
