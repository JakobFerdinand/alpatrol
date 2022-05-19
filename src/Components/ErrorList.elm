module Components.ErrorList exposing (view)

import Element exposing (..)
import Element.Font as Font


view : List String -> Element msg
view reasons =
    column [ Font.color <| rgb 1 0 0 ] <|
        List.map (\message -> text message) reasons
