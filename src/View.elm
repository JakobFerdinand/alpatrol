module View exposing (View, map, none, placeholder, toBrowserDocument)

import Browser
import Element exposing (..)


type alias View msg =
    { title : String
    , attributes : List (Attribute msg)
    , body : Element msg
    }


placeholder : String -> View msg
placeholder str =
    { title = str
    , attributes = []
    , body = text str
    }


none : View msg
none =
    placeholder ""


map : (a -> b) -> View a -> View b
map fn view =
    { title = view.title
    , attributes = List.map (Element.mapAttribute fn) view.attributes
    , body = Element.map fn view.body
    }


toBrowserDocument : View msg -> Browser.Document msg
toBrowserDocument view =
    { title = view.title
    , body =
        [ Element.layout view.attributes view.body
        ]
    }
