module Control where

import State
import Command
import Model

import Control.Concurrent
import Control.Concurrent.Chan

loop :: State -> Chan Command -> Chan State -> IO ()
loop s ic oc = do
    cmd <- readChan ic
    let newState = update s cmd
    writeChan oc newState
    loop newState ic oc

start :: State -> Chan State -> IO (Chan Command)
start s oc = do
    ic <- newChan
    forkIO $ loop s ic oc
    return ic

