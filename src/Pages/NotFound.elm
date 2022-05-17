module Pages.NotFound exposing (view)

import Element exposing (..)
import View exposing (View)


view : View msg
view =
    { title = "404"
    , attributes = []
    , body =
        text "Not found."
    }
