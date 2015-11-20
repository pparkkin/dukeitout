{-# LANGUAGE OverloadedStrings #-}

module Serialize where

import Command
import State

import qualified Data.ByteString.Lazy as B
import Data.Aeson ( encode
                  , eitherDecode )

class Deserializable m where
    deserialize :: B.ByteString -> Either String m

class Serializable o where
    serialize :: o -> Either String String

instance Deserializable InitParams where
    deserialize = eitherDecode

instance Deserializable VoteParams where
    deserialize = eitherDecode


