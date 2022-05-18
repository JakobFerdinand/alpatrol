module Pages.Register exposing (Model, Msg(..), page)

import Api.Data exposing (Data)
import Api.User exposing (User)
import Effect exposing (Effect)
import Element exposing (..)
import Page
import Request exposing (Request)
import Shared
import View exposing (View)


page : Shared.Model -> Request -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init shared
        , update = update req
        , subscriptions = subscriptions
        , view = view
        }



-- INIT


type alias Model =
    { user : Data User
    , username : String
    , email : String
    , password : String
    }


init : Shared.Model -> ( Model, Effect Msg )
init shared =
    ( Model
        (case shared.user of
            Just user ->
                Api.Data.Success user

            Nothing ->
                Api.Data.NotAsked
        )
        ""
        ""
        ""
    , Effect.none
    )



-- UPDATE


type Msg
    = Updated Field String


type Field
    = Username
    | Email
    | Password


update : Request -> Msg -> Model -> ( Model, Effect Msg )
update req msg model =
    case msg of
        Updated Username username ->
            ( { model | username = username }
            , Effect.none
            )

        Updated Email email ->
            ( { model | email = email }
            , Effect.none
            )

        Updated Password password ->
            ( { model | password = password }
            , Effect.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View msg
view model =
    { title = "Sign Up"
    , attributes = []
    , body = Element.none
    }
