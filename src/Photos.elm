module Photos exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)


type Msg
    = Like
    | Unlike


type alias Model =
    { url : String
    , caption : String
    , liked : Bool
    }


baseUrl : String
baseUrl =
    "https://programming-elm.com/"


initialModel : Model
initialModel =
    { url = baseUrl ++ "1.jpg"
    , caption = "Surfing"
    , liked = False
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Like ->
            { model | liked = True }

        Unlike ->
            { model | liked = False }


viewDetailedPhoto : Model -> Html Msg
viewDetailedPhoto { url, caption, liked } =
    let
        buttonClass =
            if liked then
                "fa"

            else
                "far"

        msg =
            if liked then
                Unlike

            else
                Like
    in
    div [ class "detailed-photo" ]
        [ img [ src url ] []
        , div [ class "photo-info" ]
            [ div [ class "like-button" ]
                [ i
                    [ class "fa-heart fa-2x"
                    , class buttonClass
                    , onClick msg
                    ]
                    []
                ]
            , h2 [ class "caption" ] [ text caption ]
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ div [ class "header" ]
            [ h1 [] [ text "Photos" ] ]
        , div [ class "content-flow" ]
            [ viewDetailedPhoto model
            ]
        ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
