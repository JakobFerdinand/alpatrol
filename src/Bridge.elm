module Bridge exposing (..)

import Auth exposing (User)



-- In an elm-spa app with Lamdera, the ToBackend type must be in this
-- Bridge file to avoid import cycle issues between generated pages and Types.elm


type ToBackend
    = SigneOut User
    | UserAuthentication_Login { params : { email : String, password : String } }
    | UserRegistration_Register { params : { username : String, email : String, password : String } }
