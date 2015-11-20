{-# LANGUAGE OverloadedStrings #-}

module API where

import Model
import State
import Command
import Serialize

import Control.Concurrent.Chan
import Control.Monad.IO.Class
import qualified Data.ByteString.Lazy.Char8 as C8
import qualified Data.Text.Lazy as T

import Web.Scotty

handleCommand :: Command -> Chan Command -> Chan State -> IO (String)
handleCommand cmd ic oc = do
    writeChan ic cmd
    ns <- readChan oc
    return $ show ns

handleInit :: Chan Command -> Chan State -> Either String InitParams -> IO String
handleInit _ _ (Left err) = return err
handleInit ic oc (Right ip) = handleCommand (Init ip) ic oc

handleVote :: Chan Command -> Chan State -> Either String VoteParams -> IO String
handleVote _ _ (Left err) = return err
handleVote ic oc (Right vp) = handleCommand (Vote vp) ic oc

handleNext :: Chan Command -> Chan State -> IO String
handleNext = handleCommand Next

handleReset :: Chan Command -> Chan State -> IO String
handleReset = handleCommand Reset

handleBodyAPI :: (Deserializable p) => (Either String p -> IO String) -> ActionM ()
handleBodyAPI handler = do
    i <- body
    liftIO $ putStrLn (show i)
    t <- liftIO $ handler (deserialize i)
    text $ T.pack t

handleNoBodyAPI :: (IO String) -> ActionM ()
handleNoBodyAPI handler = do
    t <- liftIO handler
    text $ T.pack t

scottyAPI :: Chan Command -> Chan State -> ScottyM ()
scottyAPI c uc = do
    post "/init" $ do
        handleBodyAPI $ handleInit c uc
    post "/next" $ do
        handleNoBodyAPI $ handleNext c uc
    post "/vote" $ do
        handleBodyAPI $ handleVote c uc
    post "/reset" $ do
        handleNoBodyAPI $ handleReset c uc


