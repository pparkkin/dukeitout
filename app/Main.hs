module Main where

import Model
import Control
import API

import Control.Concurrent.Chan

import Web.Scotty

main :: IO ()
main = do
    uc <- newChan
    c <- start initialState uc
    scotty 3000 $ scottyAPI c uc
