module Chat (sendMsg, getMsgs, Model, init, Action(SendMsg), update, view ) where

import Html exposing (Html, text, ul, li, div)
import Html.Attributes exposing (id, value, autofocus, name, class)
import String

type alias User = String

type alias Msg =
    { user: String
    , text: String
    }


sendMsg : User -> Msg -> String
sendMsg user msg = ""


getMsgs : List Msg
getMsgs = []


-- MODEL --

type alias Model = List Msg

init =
    [ { user = "Socrateaser" , text = "Welcome!" }
    , { user = "Socrateaser" , text = "---" }
    , { user = "Socrateaser" , text = "I'm Socrateaser, and I will guide you through a generic problem solving process by asking you a series of questions." }
    , { user = "Socrateaser" , text = "Answer each question by typing into the text box below and pressing <enter>" }
    , { user = "Socrateaser" , text = "You can give multiple answers to every question. " }
    , { user = "Socrateaser" , text = "When you are ready to move on to the next question, just press <enter> one extra time (without an answer)." }
    , { user = "Socrateaser" , text = "Ready? Let's start!" }
    , { user = "Socrateaser" , text = "---" }
    ]


-- VIEW --

view : Signal.Address Action -> Model -> Html
view address model = ul [class "list-unstyled chat-msgs"] (List.map chatLine model)

chatLine msg =
    li [ class (String.toLower msg.user) ]
        [ div [class ("username " ++ msg.user) ] [text msg.user]
        , div [class "text"] [text msg.text]
        ]



-- UPDATE --

type Action =
    SendMsg User String


update : Action -> Model -> Model
update action model =
    case action of
        SendMsg user' text' ->
             model ++ [ { user = user', text = text' } ]
