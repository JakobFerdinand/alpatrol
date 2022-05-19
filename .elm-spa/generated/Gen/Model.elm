module Gen.Model exposing (Model(..))

import Gen.Params.Home_
import Gen.Params.Login
import Gen.Params.NotFound
import Gen.Params.Register
import Pages.Home_
import Pages.Login
import Pages.NotFound
import Pages.Register


type Model
    = Redirecting_
    | Home_ Gen.Params.Home_.Params Pages.Home_.Model
    | Login Gen.Params.Login.Params Pages.Login.Model
    | NotFound Gen.Params.NotFound.Params
    | Register Gen.Params.Register.Params Pages.Register.Model

