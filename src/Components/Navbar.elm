module Components.Navbar exposing (view)

import Api.User exposing (User, UserId)
import Element exposing (..)
import Element.Events as Events
import Element.Font as Font
import Gen.Route as Route exposing (Route)
import Html exposing (label)


view :
    { user : Maybe User
    , currentRoute : Route
    , onSignOut : msg
    }
    -> Element msg
view { user, currentRoute, onSignOut } =
    row
        [ alignTop, width fill, spacing 20, padding 20 ]
        [ el [ alignLeft ] <| text "Alpatrol"
        , row [ alignRight, spacing 10 ] <|
            case user of
                Just u ->
                    [ el [ Events.onClick onSignOut ] <| text "Logout" ]

                Nothing ->
                    List.map (viewLink currentRoute) <|
                        [ ( "Home", Route.Home_ )
                        , ( "Sign in", Route.Login )
                        , ( "Sign up", Route.Register )
                        ]
        ]


viewLink : Route -> ( String, Route ) -> Element msg
viewLink currentRoute ( label, route ) =
    let
        highlightCurrentRoute =
            if currentRoute == route then
                [ Font.underline ]

            else
                []
    in
    link highlightCurrentRoute
        { url = Route.toHref route
        , label = text label
        }
