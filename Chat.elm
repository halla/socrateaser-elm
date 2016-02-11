module Chat (sendMsg, getMsgs, Model, init, Action(SendMsg), update, view ) where

import Html exposing (Html, text, ul, li)

type alias User = String

type alias Msg = String

sendMsg : User -> Msg -> String
sendMsg user msg = ""


getMsgs : List Msg
getMsgs = [ ""]


-- Model --

type alias Model = List String

init = ["Welcome to Socrateaser! Press <enter> on empty line to get the next question."]


-- View --

--view : Signal Action -> Model -> Html--
view address model = ul [] (List.map chatLine model)

chatLine line = li [] [text line]


-- Update --

type Action =
    SendMsg User String


update : Action -> Model -> Model
update action model =
    case action of
        SendMsg user msg ->
             model ++ [ user ++ ": " ++ msg ]
