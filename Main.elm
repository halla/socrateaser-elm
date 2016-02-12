import Html exposing (div, button, text, input, Html, ul, li, Attribute, select, option)
import Html.Events exposing (onClick, on, targetValue, keyCode)
import Html.Attributes exposing (id, value, autofocus, name)
import StartApp.Simple as StartApp
import Json.Decode as Json
import Signal exposing (Address, Signal)
import Questions
import Chat

main =
    StartApp.start { model = init, view = view, update = update }


--model : Signal Model
--model = Signal.foldp update init actions.signal

actions : Signal.Mailbox Action
actions =
    Signal.mailbox NoOp

type alias Model =
    { questions : (List String)
    , question : String
    , answers : List String
    , answer : String
    , chat : Chat.Model
    }


init : Model
init =
    { questions = [ "What if?", "What then?"]
    , question = "Press <enter> on empty line to get the next question1."
    , answers = ["answer1", "answer2" ]
    , answer = ""
    , chat = Chat.init
    }


view : Signal.Address Action -> Model -> Html
view = counter

-- enter handling from todomvc --
onEnter : Address a -> a -> Attribute
onEnter address value =
    on "keydown"
      (Json.customDecoder keyCode is13)
      (\_ -> Signal.message address value)


is13 : Int -> Result String ()
is13 code =
  if code == 13 then Ok () else Err "not the right key code"


questionSetOption questionSet = option [ value questionSet.id] [(text questionSet.title)]

counter address model =
  div [] [ input [ id "question"
            , value model.answer
            , on "input" targetValue (Signal.message address << SetAnswer)
            , autofocus True
            , onEnter address CommitAnswer
            ] []
    , select [ on "change" targetValue (Signal.message address << SetQuestionSet)
        ] (List.map questionSetOption Questions.list)
    , Chat.view (Signal.forwardTo address ChatAction) model.chat
    ]

nextQuestion model =
    let
        q' = List.head model.questions
        qs' = List.tail model.questions
    in
        case (q', qs') of
            (Just q, Just qs) -> { model
                | question = q
                , questions = qs
                , chat = (update (ChatAction (Chat.SendMsg "Socrateaser" q)) model).chat
            }
            (Just q, Nothing) -> { model | question = q }
            (Nothing, Just qs) -> { model | question = "This shouldn't have happened!"  }
            (Nothing, Nothing) -> { model | question = "Yay! We're done!" }

type Action
    = NoOp
    | SetQuestion String
    | SetAnswer String
    | CommitAnswer
    | SetQuestionSet String
    | ChatAction Chat.Action

update : Action -> Model -> Model
update action model =
  case action of
    NoOp -> model
    SetQuestionSet questionSetId ->
        let
            qs = Questions.get questionSetId
        in
            nextQuestion { model | questions = qs }
    SetQuestion question' ->
        { --model | question = question'
         model |chat = (update (ChatAction (Chat.SendMsg "Socrateaser" question')) model).chat
        }
    SetAnswer answer' ->
        { model | answer = answer' }
    CommitAnswer ->
        if model.answer == ""
            then nextQuestion model
            else { model | answers = model.answers ++ [model.answer]
            , answer = ""
            , chat = (update (ChatAction (Chat.SendMsg "Me" model.answer)) model).chat
        }
    ChatAction act ->
        { model | chat = Chat.update act model.chat

        }
