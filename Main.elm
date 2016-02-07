import Html exposing (div, button, text, input, Html)
import Html.Events exposing (onClick, on, targetValue)
import Html.Attributes exposing (id)
import StartApp.Simple as StartApp


main =
    StartApp.start { model = init, view = view, update = update }


--model : Signal Model
--model = Signal.foldp update init actions.signal

actions : Signal.Mailbox Action
actions =
    Signal.mailbox NoOp

type alias Model =
    { question : String
    , answer : String
    }

init : Model
init =
    { question = "What if?"
    , answer = "ans"
    }

view : Signal.Address Action -> Model -> Html
view = counter


counter address model =
  div []
    [ div [] [ text model.question ]
    , input [ id "question"
            , on "input" targetValue (Signal.message address << SetAnswer)] []
    , div [] [ text model.answer ]
    ]


type Action
    = NoOp
    | SetQuestion String
    | SetAnswer String

update : Action -> Model -> Model
update action model =
  case action of
    NoOp -> model

    SetQuestion question' ->
        { model | question = question' }
    SetAnswer answer' ->
        { model | answer = answer' }
