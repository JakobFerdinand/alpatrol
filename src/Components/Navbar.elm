module Components.Navbar exposing (view)

import Api.User exposing (User)
import Element exposing (..)


view : Maybe User -> Element msg
view user =
    row
        [ alignTop, width fill, spacing 20, padding 20 ]
        [ el [ alignLeft ] <| text "Alpatrol"
        , el [ alignRight ] <| text "Login"
        ]
