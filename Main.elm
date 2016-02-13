import Html exposing (div, button, text, input, Html, ul, li, Attribute, select, option)
import Html.Events exposing (onClick, on, targetValue, keyCode)
import Html.Attributes exposing (id, value, autofocus, name)
import StartApp as StartApp
import Json.Decode as Json
import Signal exposing (Address, Signal)
import Questions
import Chat
import Effects exposing (Effects)

app =
    StartApp.start
        { init = init
        , view = view
        , update = update
        , inputs = []
        }


main = app.html

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
    , questionSets : Questions.Model
    }


init : (Model, Effects Action)
init =
    ({ questions = [ "What if?", "What then?"]
    , question = "Press <enter> on empty line to get the next question1."
    , answers = ["answer1", "answer2" ]
    , answer = ""
    , chat = Chat.init
    , questionSets = (fst Questions.init)
    }, Effects.map QuestionsAction (snd Questions.init))



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


view : Signal.Address Action -> Model -> Html
view address model =
  div [] [ select [ on "change" targetValue (Signal.message address << SetQuestionSet)
        ] (List.map questionSetOption model.questionSets)
    , Chat.view (Signal.forwardTo address ChatAction) model.chat
    , input [ id "question"
              , value model.answer
              , on "input" targetValue (Signal.message address << SetAnswer)
              , autofocus True
              , onEnter address CommitAnswer
              ] []
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
                , chat = (fst (update (ChatAction (Chat.SendMsg "Socrateaser" q)) model)).chat
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
    | QuestionsAction Questions.Action

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp -> (model, Effects.none)
    SetQuestionSet questionSetId ->
        let
            qs = Questions.get questionSetId
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
            ({ model | questionSets = modl }, Effects.map QuestionsAction fx)
