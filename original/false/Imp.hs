module Imp where

import Tip

data P
  = Print E
  | V := E
  | While E [P]
  | If E [P] [P]

type V = Int

data E
  = N Int
  | Add E E
  | Mul E E
  | Eq E E
  | V V

type State = [Int]

fetch :: State -> V -> Int
fetch []     _     = 0
fetch (n:st) 0     = n
fetch (_:st) x = fetch st (pred x)

store :: State -> V -> Int -> State
store []     0     m = [m]
store []     x m = 0 : store [] (pred x) m
store (n:st) 0     m = m : st
store (n:st) x m = n : store st (pred x) m

eval :: State -> E -> V
eval st (N n)     = n
eval st (V x)     = fetch st x
eval st (Add a b) = eval st a + eval st b
eval st (Mul a b) = eval st a * eval st b
eval st (Eq a b)  = if eval st a == eval st b then 1 else 0

run :: State -> [P] -> [Int]
run st []              = []
run st (While e p : r) = run st (If e (p ++ [While e p]) [] : r)
run st (Print e   : r) = eval st e : run st r
run st (If e p q  : r)
  | eval st e == 0     = run st (q ++ r)
  | otherwise          = run st (p ++ r)
run st ((x := e)  : r) = run (store st x (eval st e)) r

opti :: P -> P
opti (While e p) = While e (p ++ p)
opti (If c p q)  = If c q p
--opti (p :>> q)   = opti p :>> opti q
--opti (If e p q)  = If e (opti p) (opti q)
opti p           = p

prop_Apa p = run [] [p] === run [] [opti p] -- === True

--p = While (Eq (V Z) (N Z)) [Z := N (S Z), Print (V Z)]

