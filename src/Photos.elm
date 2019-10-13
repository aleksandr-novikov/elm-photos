module Photos exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, disabled, placeholder, src, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)


type Msg
    = ToggleLike
    | UpdateComment String
    | SaveComment


type alias Model =
    { url : String
    , caption : String
    , liked : Bool
    , comments : List String
    , newComment : String
    }


baseUrl : String
baseUrl =
    "https://programming-elm.com/"


initialModel : Model
initialModel =
    { url = baseUrl ++ "1.jpg"
    , caption = "Surfing"
    , liked = False
    , comments = [ "Cowabunga, dude!" ]
    , newComment = ""
    }


saveNewComment : Model -> Model
saveNewComment model =
    let
        comment =
            String.trim model.newComment
    in
    case comment of
        "" ->
            model

        _ ->
            { model
                | comments = model.comments ++ [ comment ]
                , newComment = ""
            }


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToggleLike ->
            { model | liked = not model.liked }

        UpdateComment comment ->
            { model | newComment = comment }

        SaveComment ->
            saveNewComment model


viewDetailedPhoto : Model -> Html Msg
viewDetailedPhoto model =
    div [ class "detailed-photo" ]
        [ img [ src model.url ] []
        , div [ class "photo-info" ]
            [ viewLoveButton model.liked
            , h2 [ class "caption" ] [ text model.caption ]
            , viewComments model
            ]
        ]


viewLoveButton : Bool -> Html Msg
viewLoveButton liked =
    let
        buttonClass =
            if liked then
                "fa"

            else
                "far"
    in
    div [ class "like-button" ]
        [ i
            [ class "fa-heart fa-2x"
            , class buttonClass
            , onClick ToggleLike
            ]
            []
        ]


viewComments : Model -> Html Msg
viewComments model =
    div []
        [ viewCommentList model.comments
        , form [ class "new-comment", onSubmit SaveComment ]
            [ input
                [ type_ "text"
                , placeholder "Add a comment"
                , value model.newComment
                , onInput UpdateComment
                ]
                []
            , button [ disabled (String.isEmpty model.newComment) ] [ text "Save" ]
            ]
        ]


viewCommentList : List String -> Html Msg
viewCommentList comments =
    case comments of
        [] ->
            text ""

        _ ->
            div [ class "comments" ]
                [ ul []
                    (List.map viewComment comments)
                ]


viewComment : String -> Html Msg
viewComment comment =
    li []
        [ strong [] [ text "Comment:" ]
        , text (" " ++ comment)
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
