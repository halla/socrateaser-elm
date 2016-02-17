import Html exposing (div, button, text, input, Html, ul, li, Attribute, select, option)
import Html.Events exposing (onClick, on, targetValue, keyCode)
import Html.Attributes exposing (id, value, autofocus, name)
import StartApp as StartApp
import Json.Decode as Json
import Signal exposing (Address, Signal)
import Questions
import Chat
import Effects exposing (Effects, Never)
import Task

import Socrateaser exposing (init, view, update)
app =
    StartApp.start
        { init = init
        , view = view
        , update = update
        , inputs = []
        }

main = app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks
