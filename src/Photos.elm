module Photos exposing (view)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, disabled, placeholder, src, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Http
import Json.Decode exposing (Decoder, bool, int, list, string, succeed)
import Json.Decode.Pipeline exposing (hardcoded, required)


type Msg
    = ToggleLike Id
    | UpdateComment Id String
    | SaveComment Id
    | LoadFeed (Result Http.Error Feed)


type alias Id =
    Int

type alias Feed =
    List Photo

type alias Photo =
    { id : Id
    , url : String
    , caption : String
    , liked : Bool
    , comments : List String
    , newComment : String
    }


photoDecoder : Decoder Photo
photoDecoder =
    succeed Photo
        |> required "id" int
        |> required "url" string
        |> required "caption" string
        |> required "liked" bool
        |> required "comments" (list string)
        |> hardcoded ""


type alias Model =
    { feed : Maybe Feed
    }


baseUrl : String
baseUrl =
    "https://programming-elm.com/"


initialModel : Model
initialModel =
    { feed =
        Nothing
    }


fetchFeed : Cmd Msg
fetchFeed =
    Http.get
        { url = baseUrl ++ "feed"
        , expect = Http.expectJson LoadFeed (list photoDecoder)
        }


saveNewComment : Photo -> Photo
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


toggleLike : Photo -> Photo
toggleLike photo =
    { photo | liked = not photo.liked }


updateComment : String -> Photo -> Photo
updateComment comment photo =
    { photo | newComment = comment }

updatePhotoById: (Photo -> Photo) -> Id -> Feed -> Feed
updatePhotoById updatePhoto id feed =
    List.map
        (\photo ->
            if photo.id==id then
                updatePhoto photo
            else
                photo
            )
            feed

updateFeed : (Photo -> Photo) -> Id -> Maybe Feed -> Maybe Feed
updateFeed updatePhoto id maybeFeed =
    Maybe.map (updatePhotoById updatePhoto id) maybeFeed


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleLike id ->
            ( { model | feed = updateFeed toggleLike id model.feed }
            , Cmd.none
            )

        UpdateComment id comment ->
            ( { model | feed = updateFeed (updateComment comment) id model.feed }
            , Cmd.none
            )

        SaveComment id ->
            ( { model | feed = updateFeed saveNewComment id model.feed }
            , Cmd.none
            )

        LoadFeed (Ok feed) ->
            ( { model | feed = Just feed }
            , Cmd.none
            )

        LoadFeed (Err _) ->
            ( model
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


viewDetailedPhoto : Photo -> Html Msg
viewDetailedPhoto photo =
    div [ class "detailed-photo" ]
        [ img [ src photo.url ] []
        , div [ class "photo-info" ]
            [ viewLoveButton photo.liked photo.id
            , h2 [ class "caption" ] [ text photo.caption ]
            , viewComments photo
            ]
        ]


viewLoveButton : Bool -> Int -> Html Msg
viewLoveButton liked id =
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
            , onClick (ToggleLike id)
            ]
            []
        ]


viewComments : Photo -> Html Msg
viewComments photo =
    div []
        [ viewCommentList photo.comments
        , form [ class "new-comment", onSubmit (SaveComment photo.id) ]
            [ input
                [ type_ "text"
                , placeholder "Add a comment"
                , value photo.newComment
                , onInput (UpdateComment photo.id)
                ]
                []
            , button [ disabled (String.isEmpty photo.newComment) ] [ text "Save" ]
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


viewFeed : Maybe Feed -> Html Msg
viewFeed maybeFeed =
    case maybeFeed of
        Just feed ->
            div [] (List.map viewDetailedPhoto feed)

        Nothing ->
            div [ class "loading-feed" ]
                [ text "Loading Feed..." ]


view : Model -> Html Msg
view model =
    div []
        [ div [ class "header" ]
            [ h1 [] [ text "Photos" ] ]
        , div [ class "content-flow" ]
            [ viewFeed model.feed
            ]
        ]


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, fetchFeed )


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
