module Api where

import Types exposing (..)
import Task exposing (..)

apiActions : Signal.Mailbox ApiAction
apiActions = Signal.mailbox NoCall

resultToAction : Result String String -> Action
resultToAction r =
    case r of
        Err _ -> Noop
        Ok _ -> Submit

apiToActions : Signal Action
apiToActions = Signal.map resultToAction results.signal

results : Signal.Mailbox (Result String String)
results = Signal.mailbox (Ok "")

toResultAndSend : Signal.Mailbox (Result String String) -> Task String String -> Task x ()
toResultAndSend m task =
    Task.toResult task `andThen` Signal.send m.address

callApi : ApiAction -> Task String String
callApi a =
    case a of
        NoCall -> Task.fail "No call"
        _ -> Task.succeed "Done"


