module View exposing (..)

import String
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Types exposing (..)

view : Model -> Html Msg
view model =
  div [] [ loginBox model ]

loginForm model =
    div [ id "form" ] [
        h2 [ class "text-center" ] [ text "Log In" ]
        , p [ class "help-block" ] [ text "If you already have an account, please Log In." ]
        , div [ class "" ] [ messageBox model ]
        , div [ class "form-group row" ] [
            div [ class "col-md-offset-2 col-md-8" ] [
                label [ for "email" ] [ text "Email:" ]
                , input [ id "email", type' "text", class "form-control", Html.Attributes.value model.email, onInput SetEmail ] []
            ]
        ]
        , div [ class "form-group row" ] [
            div [ class "col-md-offset-2 col-md-8" ] [
                label [ for "password" ] [ text "Password:" ]
                , input [ id "password", type' "password", class "form-control", Html.Attributes.value model.password, onInput SetPassword ] []
            ]
        ]
        , div [ class "text-center" ] [
            button [ class "btn btn-primary", onClick ClickLogIn ] [ text "Log In" ]
        ]
    ]

messageBox model =
  let
    hasError : Bool
    hasError =
      if String.length model.errorMsg > 0 then True else False
  in
    if hasError then
      div [ class "alert alert-danger" ] [ text model.errorMsg ]
    else
      div [] []

logedBox model =
  div [id "greeting" ][
    h3 [ class "text-center" ] [ (text ("Hello, " ++ model.email )) ]
      , p [ class "text-center" ] [ text "You are logged in!!!" ]
      , p [ class "text-center" ] [
        button [ class "btn btn-danger", onClick LogOut ] [ text "Log Out" ]
        ]
  ]

loginBox model =
    let
      loggedIn : Bool
      loggedIn =
          if String.length model.token > 0 then True else False
    in
      if loggedIn then
        logedBox model
      else
        (loginForm model)
