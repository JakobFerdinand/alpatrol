module Pages.Login exposing (Model, Msg(..), page)

import Api.Data exposing (Data)
import Api.User exposing (User)
import Bridge exposing (ToBackend(..), sendToBackend)
import Components.ErrorList
import Effect exposing (Effect)
import Element exposing (..)
import Element.Border as Border
import Element.Input as Input
import Gen.Route as Route
import Page
import Request exposing (Request)
import Shared
import Utils.Route
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
    , Effect.none
    )



-- UPDATE


type Msg
    = Updated Field String
    | AttemptedSignIn
    | GotUser (Data User)


type Field
    = Email
    | Password


update : Request -> Msg -> Model -> ( Model, Effect Msg )
update req msg model =
    case msg of
        Updated Email email ->
            ( { model | email = email }, Effect.none )

        Updated Password password ->
            ( { model | password = password }, Effect.none )

        AttemptedSignIn ->
            ( model
            , (Effect.fromCmd << sendToBackend) <|
                UserAuthentication_Login
                    { params =
                        { email = model.email
                        , password = model.password
                        }
                    }
            )

        GotUser user ->
            case Api.Data.toMaybe user of
                Just user_ ->
                    ( { model | user = user }
                    , Effect.batch
                        [ Effect.fromCmd (Utils.Route.navigate req.key Route.Home_)
                        , Effect.fromShared (Shared.SignedInUser user_)
                        ]
                    )

                Nothing ->
                    ( { model | user = user }
                    , Effect.none
                    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Sign In"
    , attributes = []
    , body =
        column [ alignTop, centerX, spacing 10 ]
            [ text "Sign In"
            , link []
                { url = Route.toHref Route.Register
                , label = text "Need an account?"
                }
            , case model.user of
                Api.Data.Failure reasons ->
                    Components.ErrorList.view reasons

                _ ->
                    text ""
            , column []
                [ Input.email []
                    { onChange = Updated Email
                    , text = model.email
                    , placeholder = Nothing
                    , label = Input.labelAbove [] <| text "Email"
                    }
                , Input.newPassword []
                    { onChange = Updated Password
                    , text = model.password
                    , placeholder = Nothing
                    , label = Input.labelAbove [] <| text "Password"
                    , show = False
                    }
                ]
            , Input.button
                [ alignRight
                , Border.width 1
                , Border.rounded 4
                , padding 5
                ]
                { onPress = Just AttemptedSignIn
                , label = text "Sign in"
                }
            ]
    }
