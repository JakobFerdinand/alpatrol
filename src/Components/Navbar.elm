module Components.Navbar exposing (view)

import Api.User exposing (User, UserId)
import Element exposing (..)
import Element.Events as Events


view :
    Maybe User
    -> msg
    -> msg
    -> (UserId -> msg)
    -> Element msg
view user onRegister onLogin onLogout =
    row
        [ alignTop, width fill, spacing 20, padding 20 ]
        [ el [ alignLeft ] <| text "Alpatrol"
        , case user of
            Just u ->
                el [ alignRight, Events.onClick (onLogout u.id) ] <| text "Logout"

            Nothing ->
                row [ alignRight, spacing 20 ]
                    [ el [ Events.onClick onRegister ] <| text "Register"
                    , el [ Events.onClick onLogin ] <| text "Login"
                    ]
        ]
