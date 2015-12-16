module Main where

import Html exposing ( Html
                     , Attribute
                     , div
                     , textarea
                     , text
                     , button )
import Html.Attributes exposing ( class )
import Html.Events exposing ( on 
                            , targetValue
                            , onClick )

import Debug exposing ( crash )
import Task exposing (..)

import Types exposing (..)
import Api exposing (..)
import View exposing (..)
import State exposing (..)

main = Signal.map view state

initialState : Model
initialState = Editing ""

state : Signal Model
state = Signal.foldp update initialState (Signal.merge actions.signal apiToActions)

port requests : Signal (Task x ())
port requests =
    Signal.map callApi apiActions.signal
        |> Signal.map (toResultAndSend results)

