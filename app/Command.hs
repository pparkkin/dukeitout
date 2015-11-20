{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Command where

import Data.Aeson ( FromJSON
                  , ToJSON )

newtype InitParams = InitParams [String]
    deriving ( Show
             , ToJSON
             , FromJSON )
newtype VoteParams = VoteParams String
    deriving ( Show
             , ToJSON
             , FromJSON )

data Command = Init InitParams
             | Next
             | Vote VoteParams
             | Reset
             deriving (Show)


