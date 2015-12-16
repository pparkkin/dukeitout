module View where

import Html exposing ( div
                     , text
                     )
import Html.Events

import Types exposing (..)
import State exposing (..)
import Api exposing (..)

makeButton : String
          -> Signal.Mailbox a
          -> a
          -> Html.Html
makeButton s m a = Html.button [ Html.Events.onClick m.address a ]
                               [ Html.text s ]

makeInput : String
         -> Signal.Mailbox a
         -> (String -> a)
         -> Html.Html
makeInput s m af = Html.textarea
    [ Html.Events.on "input"
        Html.Events.targetValue
        (\c -> Signal.message m.address (af c)) ]
    [ Html.text s ]

view : Model -> Html.Html
view s =
    case s of
        Editing b -> viewInit b
        Voting a b -> viewChoose a b

viewInit : String -> Html.Html
viewInit s =
    let
        textInput = makeInput s actions (\b -> Edit b)
        initBtn = makeButton "Init" apiActions ApiInit
    in
        div []
            [ textInput
            , initBtn
            ]

viewChoose : String -> String -> Html.Html
viewChoose a b =
    div []
        [ div [] [ text a ]
        , div [] [ text b ]
        ]

