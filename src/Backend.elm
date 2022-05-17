module Backend exposing (..)

import Api.Data exposing (Data(..))
import Api.User exposing (User, UserFull, UserId)
import Bridge exposing (..)
import Dict
import Dict.Extra as Dict
import Gen.Msg
import Lamdera exposing (..)
import Pages.Home_
import Task
import Time
import Time.Extra as Time
import Types exposing (BackendModel, BackendMsg(..), FrontendMsg(..), ToFrontend(..))


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \m -> Sub.none
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { sessions = Dict.empty
      , users = Dict.empty
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        RenewSession uid sid cid now ->
            ( model, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> Types.ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        SigneOut user ->
            ( { model | sessions = model.sessions |> Dict.remove sessionId }, Cmd.none )

        UserAuthentication_Login { params } ->
            ( model, Cmd.none )

        UserRegistration_Register { params } ->
            let
                ( model_, cmd, res ) =
                    if model.users |> Dict.any (\k u -> u.email == params.email) then
                        ( model, Cmd.none, Failure [ "email address already taken" ] )

                    else
                        let
                            user_ =
                                { id = Dict.size model.users
                                , email = params.email
                                , username = params.username
                                , password = params.password
                                }
                        in
                        ( { model | users = model.users |> Dict.insert user_.id user_ }
                        , renewSession user_.id sessionId clientId
                        , Success (Api.User.toUser user_)
                        )
            in
            ( model, Cmd.none )


renewSession email sid cid =
    Time.now |> Task.perform (RenewSession email sid cid)
