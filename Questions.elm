module Questions (list, get, init, update, Model, Action) where

import Http
import Json.Decode as Json exposing ((:=))
import Task
import Effects exposing (Effects)

get : String -> List String
get id =
    let
        qs = (List.head (List.filter (\q -> q.id == id) list))
    in
        case qs of
            Just qs' -> qs'.questions
            Nothing -> []

defaultList =
    { id = "0"
    , title = "Select question set"
    , questions =
        [ "Are you ready to press <enter> to get the next question?"
        , "Have you tried selecting a question set?"
        ]
    }

type alias QuestionSet =
    { id : String
    , title : String
    , questions : List String
    }

type alias Model = List QuestionSet

init : (Model, Effects Action)
init =
    ( list
    , getQuestionSet
    )

list = [
    defaultList,
    { id = "1"
    , title = "Planning 1"
    , questions =
    [ "What is our timespan? (Year, month, week, day, other?)"
    , "What are all the things you should do? List all that's on your mind."
    , "What is special about this time period?"
    , "What special things could you do in this period?"
    , "What are you going to do for the first time?"
    , "What recurring tasks could you do differently this time?"
    , "What else is going on at the same time?"
    , "Which of your tasks would be better done later?"
    , "What are your three most important tasks?"
    , "What is the most important task? There is only one."
    , "Which of the things are you actually going to have done?"
    ]},
    { id = "2"
    , title = "Reflection 1"
    , questions = [ "Why?", "Who?"]}]



getQuestionSet :  Effects Action
getQuestionSet =
  Http.get decodeUrl "questions.json"
    |> Task.toMaybe
    |> Task.map NewSet
    |> Effects.task


type Action
    = NewSet (Maybe QuestionSet)

update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        NewSet questionSet ->  (model ++ [ Maybe.withDefault {id = "dasf", title = "Uknkow", questions = []} questionSet], Effects.none)

decodeUrl : Json.Decoder QuestionSet
decodeUrl =
    Json.object3 QuestionSet
    ("id" := Json.string)
    ("title" := Json.string)
    ("questions" := Json.list Json.string)
