module Photos exposing (main)

import Browser
import Config exposing (baseUrl)
import Http
import Json.Decode exposing (Decoder, list)
import Model exposing (Feed, Id, Model, Photo, initialModel)
import Update exposing (Msg(..), photoDecoder, subscriptions, update)
import View exposing (view)


init : () -> ( Model, Cmd Msg )
init () =
    ( initialModel, fetchFeed )


fetchFeed : Cmd Msg
fetchFeed =
    Http.get
        { url = baseUrl ++ "feed"
        , expect = Http.expectJson LoadFeed (list photoDecoder)
        }


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
