module Types where

type Model = Editing String
           | Voting String String
type Action = Noop
            | Edit String
            | Submit
type ApiAction = NoCall
               | ApiInit

