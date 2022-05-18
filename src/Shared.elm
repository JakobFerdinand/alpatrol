module Shared exposing
    ( Flags
    , Model
    , Msg(..)
    , init
    , subscriptions
    , update
    , view
    )

import Api.User exposing (..)
import Bridge exposing (..)
import Components.Navbar as Navbar
import Element exposing (..)
import Request exposing (Request)
import Utils.Route
import View exposing (View)



-- INIT


type alias Flags =
    ()


type alias Model =
    { user : Maybe User }


init : Request -> Flags -> ( Model, Cmd Msg )
init _ json =
    ( { user = Nothing }
    , Cmd.none
    )



-- UPDATE


type Msg
    = ClickedSignOut


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        ClickedSignOut ->
            ( { model | user = Nothing }
            , model.user |> Maybe.map (\user -> sendToBackend (SignedOut user)) |> Maybe.withDefault Cmd.none
            )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none



-- VIEW


view :
    Request
    -> { page : View msg, toMsg : Msg -> msg }
    -> Model
    -> View msg
view req { page, toMsg } model =
    { title = page.title
    , attributes = page.attributes
    , body =
        column [ centerX, centerY, width fill, height fill ]
            [ Navbar.view
                { user = model.user
                , currentRoute = Utils.Route.fromUrl req.url
                , onSignOut = toMsg ClickedSignOut
                }
            , page.body
            ]
    }
