{-# LANGUAGE DeriveGeneric #-}

module State where

import Data.Aeson ( ToJSON )
import GHC.Generics

type Score = Int

data State = Empty
           | Pairs [(String, String)] [(String, Score)]
           | Waiting (String, String) [(String, String)] [(String, Score)]
           | Result [(String, Score)]
           deriving (Show, Generic)

instance ToJSON State



