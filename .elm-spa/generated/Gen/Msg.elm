module Gen.Msg exposing (Msg(..))

import Gen.Params.Home_
import Gen.Params.NotFound
import Gen.Params.Register
import Pages.Home_
import Pages.NotFound
import Pages.Register


type Msg
    = Home_ Pages.Home_.Msg

