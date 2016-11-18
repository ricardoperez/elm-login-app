module Types exposing (..)

import Http

type alias Model =
    { email : String
    , password : String
    , token : String
    , errorMsg : String
    }

type Msg
    = ClickLogIn
    | LogOut
    | HttpError Http.Error
    | AuthError Http.Error
    | SetEmail String
    | SetPassword String
    | GetTokenSuccess String
