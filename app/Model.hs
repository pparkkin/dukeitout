module Model where

import State
import Command

import Data.List ( delete )

initialState :: State
initialState = Empty

initPairs :: [String] -> [(String, String)]
initPairs [] = []
initPairs (_:[]) = []
initPairs (s:ss) = pairs ++ initPairs ss
    where
        pairs = map (\t -> (s, t)) ss

initScore :: [String] -> [(String, Score)]
initScore ss = map (\s -> (s, 0)) ss

newPairs :: [String] -> State
newPairs ss = Pairs pairs score
    where
        pairs = initPairs ss
        score = initScore ss

updateScore :: String -> [(String, Score)] -> [(String, Score)]
updateScore _ [] = []
updateScore s (p:ps)
    | s == fst p = (s, snd p + 1) : ps
    | otherwise = p : updateScore s ps

recordVote :: String -> [(String, String)] -> [(String, Score)] -> State
recordVote s [] ss = Result (updateScore s ss)
recordVote s ps ss = Pairs ps (updateScore s ss)

acceptVote :: String -> (String, String) -> Bool
acceptVote s p = s == fst p || s == snd p

update :: State -> Command -> State
update Empty (Init (InitParams ss)) =
    newPairs ss
update (Pairs (p:ps) ss) Next =
    Waiting p ps ss
update (Waiting p ps ss) (Vote (VoteParams s)) =
    if acceptVote s p
        then recordVote s ps ss
        else Waiting p ps ss
update (Result ss) Reset =
    Empty
update s _ = s

