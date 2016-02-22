module Socrateaser (init, view, update) where

import Questions
import Chat
import Json.Decode as Json
import Signal exposing (Address, Signal)
import Effects exposing (Effects)
import Html exposing (div, button, text, input, Html, ul, li, Attribute, select, option)
import Html.Events exposing (onClick, on, targetValue, keyCode)
import Html.Attributes exposing (id, value, autofocus, name, class)


-- MODEL --

type alias Model =
    { questions : (List String)
    , question : String
    , answers : List String
    , answer : String
    , chat : Chat.Model
    , questionSets : Questions.Model
    }


init : (Model, Effects Action)
init =
    ({ questions =  Questions.genericProblem
    , question = "Press <enter> on empty line to get the next question1."
    , answers = ["answer1", "answer2" ]
    , answer = ""
    , chat = Chat.init
    , questionSets = (fst Questions.init)
    }, Effects.batch
    [ Effects.map QuestionsAction (snd Questions.init)
    ]
    )




-- VIEW --

questionSetOption questionSet = option [ value questionSet.id] [(text questionSet.title)]


-- enter handling from todomvc --
onEnter : Address a -> a -> Attribute
onEnter address value =
    on "keydown"
      (Json.customDecoder keyCode is13)
      (\_ -> Signal.message address value)


is13 : Int -> Result String ()
is13 code =
  if code == 13 then Ok () else Err "not the right key code"



userInputText address model =
    input [ id "question"
            , class "form-control"
            , value model.answer
            , on "input" targetValue (Signal.message address << SetAnswer)
            , autofocus True
            , onEnter address CommitAnswer
            ] []

questionSetSelector address options =
    select [ on "change" targetValue (Signal.message address << SetQuestionSet)
             , class "questionset form-control"
    ] options

view : Signal.Address Action -> Model -> Html
view address model =
  div [ class "app"]
    [ Chat.view (Signal.forwardTo address ChatAction) model.chat
    , userInputText address model
    , questionSetSelector address (List.map questionSetOption model.questionSets)
    ]


--  UPDATE --

nextQuestion model =
    let
        q' = List.head model.questions
        qs' = List.tail model.questions
    in
        case (q', qs') of
            (Just q, Just qs) -> { model
                | question = q
                , questions = qs
                , chat = (fst (update (ChatAction (Chat.SendMsg "Socrateaser" q)) model)).chat
            }
            (Just q, Nothing) -> { model | question = "" }
            (Nothing, Just qs) -> { model
                | question = "This shouldn't have happened!"
                , chat = (fst (update (ChatAction (Chat.SendMsg "Socrateaser" "sdf")) model)).chat
            }
            (Nothing, Nothing) -> { model | question = "Yay! We're done!" }

type Action
    = NoOp
    | SetQuestion String
    | SetAnswer String
    | CommitAnswer
    | SetQuestionSet String
    | ChatAction Chat.Action
    | QuestionsAction Questions.Action

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp -> (model, Effects.none)
    SetQuestionSet questionSetId ->
        let
            qs = Questions.get model.questionSets questionSetId
        in
            (nextQuestion { model | questions = qs }, Effects.none)
    SetQuestion question' ->
        ({ --model | question = question'
         model |chat = (fst (update (ChatAction (Chat.SendMsg "Socrateaser" question')) model)).chat
        }, Effects.none)
    SetAnswer answer' ->
        ({ model | answer = answer' }, Effects.none)
    CommitAnswer ->
        if model.answer == ""
            then (nextQuestion model, Effects.none)
            else ({ model | answers = model.answers ++ [model.answer]
            , answer = ""
            , chat = (fst (update (ChatAction (Chat.SendMsg "You" model.answer)) model)).chat
        }, Effects.none)
    ChatAction act ->
        ({ model | chat = Chat.update act model.chat

        }, Effects.none)
    QuestionsAction act ->
        let
            (modl, fx) = Questions.update act model.questionSets
        in
            --Debug.watchSummary modl
            ({ model | questionSets = modl }, Effects.map QuestionsAction fx)
