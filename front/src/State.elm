module State where

import Types exposing (..)
import Api exposing (..)

actions : Signal.Mailbox Action
actions = Signal.mailbox Noop

update : Action -> Model -> Model
update a s =
    case (a, s) of
        (Noop, s) -> s
        (Submit, Editing _) -> Voting "hello" "world"
        (_, s) -> s

