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

init = [{ user = "Socrateaser", text = "Welcome to Socrateaser! Press <enter> on empty line to get the next question."}]


-- VIEW --

--view : Signal Action -> Model -> Html--
view address model = ul [class "list-unstyled"] (List.map chatLine model)

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

--port requestUser : Signal String
--port requestUser =
--    signalOfUsersWeWantMoreInfoOn
