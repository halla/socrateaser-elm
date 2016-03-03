module Questions (get, init, update, Model, Action) where

import Http
import Html exposing (div, text, Html)
import Json.Decode as Json exposing ((:=))
import Task
import Effects exposing (Effects)



get : List QuestionSet -> String -> List String
get questionSet id =
    let
        qs =
            questionSet
                |> List.filter (\q -> q.id == id)
                |> List.head
    in
        case qs of
            Just qs' -> qs'.questions
            Nothing -> ["Sorry, no questions found in this set. :( "]

defaultList =
    { id = "0"
    , title = "Select question set"
    , questions =
        [ "Are you ready to press <enter> to get the next question?"
        , "Have you tried selecting a question set?"
        ]
    }

genericProblem =
    [ "What is the problem that you need a new solution for?",
        "Why is this a problem?",
        "Can you be more specific?",
        "What are some similar problems that you or someone else have?",
        "What is common to all these problems?",
        "What stops you from solving the problem now?",
        "What would you guess that you think about this problem in 10 years?",
        "What could you do to solve the problem?",
        "What is the first thing you are going to do to solve the problem?",
        "Well, done! Now go and do that!"
    ]
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
    , questions = [ "Why?", "Who?"]},
    { id = "generic_problem"
    , title = "Generic Problem"
    , questions = genericProblem }]


-- VIEW --


view : Signal.Address Action -> Model -> Html
view action model =
    div [] [(text "jep")]


-- UPDATE --


type Action
    = NewSet (Maybe (List QuestionSet))

getQuestionSet : Effects Action
getQuestionSet =
  Http.get decodeUrl "questions.json"
    |> Task.toMaybe
    |> Task.map NewSet
    |> Effects.task


update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        NewSet questionSets -> (model ++ Maybe.withDefault [{id = "unknown1", title = "Unknown", questions = ["Sorry, no questions found."]}] questionSets, Effects.none)


decodeQuestionSets =
    Json.list decodeQuestionSet

decodeQuestionSet =
    Json.object3 QuestionSet
        ("id" := Json.string)
        ("title" := Json.string)
        ("questions" := (Json.list Json.string))

decodeUrl : Json.Decoder (List QuestionSet)
decodeUrl =
    Json.at ["data"] decodeQuestionSets
