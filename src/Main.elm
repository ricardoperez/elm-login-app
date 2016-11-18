port module Main exposing (..)

import Html.App as Html
import String

import Http
import Task exposing (Task)
import Json.Decode as Decode exposing (..)

import View exposing (..)
import Types exposing (..)

main =
    Html.programWithFlags
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = View.view
        }


--  Check if user is alreade logged in
init : Maybe Model -> (Model, Cmd Msg)
init model =
  (Model "" "" "" "", Cmd.none)

-- TODO Move this to a config file
hostUrl : String
hostUrl =
     "http://authost.com/"

authUrl : String
authUrl =
  hostUrl ++ "auth"

-- Encode user to construct POST request body (for Register and Log In)
authBody : Model -> Http.Body
authBody model =
  Http.multipart
    [ Http.stringData "email" (model.email)
    , Http.stringData "password"  (model.password)
    ]

-- Decode POST response to get token
tokenDecoder : Decoder String
tokenDecoder =
    "token" := Decode.string

-- POST login request
authUser : Model -> String -> Task Http.Error String
authUser model apiUrl =
  Http.post tokenDecoder apiUrl (authBody model)

authUserCmd : Model -> String -> Cmd Msg
authUserCmd model apiUrl =
    Task.perform AuthError GetTokenSuccess <| authUser model apiUrl


-- Helper to update model and set localStorage with the updated model
setStorageHelper : Model -> ( Model, Cmd Msg )
setStorageHelper model =
    ( model, setStorage model )

-- Ports
port setStorage : Model -> Cmd msg
port removeStorage : Model -> Cmd msg

-- Handling Error
handlingError : Http.Error -> String
handlingError err =
  case err of
    Http.Timeout ->
      "Error Accessing the Login, try again latter"
    Http.NetworkError ->
      "Error Accessing the Login, try again latter"
    Http.UnexpectedPayload _ ->
      "Wrong params"
    Http.BadResponse status payload ->
      handlingBadResponse status

handlingBadResponse : number -> String
handlingBadResponse status =
  case status of
    401 ->
      "Invalid Email or Password"
    400 ->
      "Missing Email or Password"
    _ ->
      "Some Uncaught Error"

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ClickLogIn ->
            ( model, authUserCmd model authUrl )
        HttpError _ ->
            ( model, Cmd.none )
        AuthError error ->
            ( { model | errorMsg = (handlingError error) }, Cmd.none )
        SetEmail email ->
            ( { model | email = email }, Cmd.none )
        SetPassword password ->
            ( { model | password = password }, Cmd.none )
        GetTokenSuccess newToken ->
            setStorageHelper { model | token = newToken, password = "", errorMsg = "" }
        LogOut ->
            ( { model | token = "" }, Cmd.none )

