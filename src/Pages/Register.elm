module Pages.Register exposing (Model, Msg(..), page)

import Api.Data exposing (Data)
import Api.User exposing (User)
import Bridge exposing (..)
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
    | AttemptedSignUp
    | GotUser (Data User)


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

        AttemptedSignUp ->
            ( model
            , (Effect.fromCmd << sendToBackend) <|
                UserRegistration_Register
                    { params =
                        { username = model.username
                        , email = model.email
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
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Sign Up"
    , attributes = []
    , body =
        column [ alignTop, centerX, spacing 10 ]
            [ text "Sign up"
            , link []
                { url = Route.toHref Route.Login
                , label = text "Have an account?"
                }
            , case model.user of
                Api.Data.Failure reasons ->
                    Components.ErrorList.view reasons

                _ ->
                    text ""
            , column []
                [ Input.username []
                    { onChange = Updated Username
                    , label = Input.labelAbove [] <| text "Your Name"
                    , placeholder = Nothing
                    , text = model.username
                    }
                , Input.email []
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
                { onPress = Just AttemptedSignUp
                , label = text "Sign up"
                }
            ]
    }
