module Main exposing (main)

import Html
import Init
import Updates
import Subscriptions
import Views


main =
    Html.programWithFlags
        { init = Init.init
        , update = Updates.update
        , subscriptions = Subscriptions.subscriptions
        , view = Views.view
        }
