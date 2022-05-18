module Components.UserForm exposing (Field, view)

import Api.Data exposing (Data)
import Api.User exposing (User)
import Element exposing (..)
import Element.Input as Input
import Gen.Route as Route exposing (Route)


type alias Field msg =
    { label : String
    , value : String
    , onInput : String -> msg
    }


view :
    { user : Data User
    , label : String
    , onFormSubmit : msg
    , alternateLink : { label : String, route : Route }
    , fields : List (Field msg)
    }
    -> Element msg
view options =
    none
