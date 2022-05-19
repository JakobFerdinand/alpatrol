module Types exposing (..)

import Api.User exposing (User, UserFull, UserId)
import Bridge
import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Gen.Pages as Pages
import Lamdera exposing (ClientId, SessionId)
import Shared exposing (Flags)
import Time
import Url exposing (Url)


type alias FrontendModel =
    { url : Url
    , key : Key
    , shared : Shared.Model
    , page : Pages.Model
    }


type FrontendMsg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | Shared Shared.Msg
    | Page Pages.Msg
    | Noop


type alias Session =
    { userId : Int, expires : Time.Posix }


type alias BackendModel =
    { sessions : Dict SessionId Session
    , users : Dict Int UserFull
    }


type alias ToBackend =
    Bridge.ToBackend


type BackendMsg
    = RenewSession UserId SessionId ClientId Time.Posix


type ToFrontend
    = ActiveSession User
    | PageMsg Pages.Msg
