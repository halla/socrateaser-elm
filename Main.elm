import Html exposing (div, button, text, input, Html, ul, li, Attribute)
import Html.Events exposing (onClick, on, targetValue, keyCode)
import Html.Attributes exposing (id, value)
import StartApp.Simple as StartApp
import Json.Decode as Json
import Signal exposing (Address, Signal)

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
    }


init : Model
init =
    { questions = [ "What if?", "What then?"]
    , question = "Press <enter> on empty line to get the next question."
    , answers = ["answer1", "answer2" ]
    , answer = ""
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


answerLine answer = li [] [ text answer ]

counter address model =
  div []
    [ div [] [ text model.question ]
    , input [ id "question"
            , value model.answer
            , on "input" targetValue (Signal.message address << SetAnswer)
            , onEnter address CommitAnswer
            ] []
    , div [] (List.map answerLine model.answers)
    ]

nextQuestion model =
    let
        q' = List.head model.questions
        qs' = List.tail model.questions
    in
        case (q', qs') of
            (Just q, Just qs) -> { model | question = q , questions = qs }
            (Just q, Nothing) -> { model | question = q }
            (Nothing, Just qs) -> { model | question = "This shouldn't have happened!"  }
            (Nothing, Nothing) -> { model | question = "Yay! We're done!" }

type Action
    = NoOp
    | SetQuestion String
    | SetAnswer String
    | CommitAnswer

update : Action -> Model -> Model
update action model =
  case action of
    NoOp -> model

    SetQuestion question' ->
        { model | question = question' }
    SetAnswer answer' ->
        { model | answer = answer' }
    CommitAnswer ->
        if model.answer == ""
            then nextQuestion model
            else { model | answers = model.answers ++ [model.answer] , answer = "" }
