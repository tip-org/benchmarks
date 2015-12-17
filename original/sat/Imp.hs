module Imp where

import Tip.Prelude
import qualified Prelude as P

data P
  = Print E
  | V := E
  | While E [P]
  | If E [P] [P]
 deriving ( P.Show )

type V = Nat

data E
  = N Nat
  | Add E E
  | Mul E E
  | Eq E E
  | V V
 deriving ( P.Show )

type State = [Nat]

fetch :: State -> V -> Nat
fetch []     _     = Z
fetch (n:st) Z     = n
fetch (_:st) (S x) = fetch st x

store :: State -> V -> Nat -> State
store []     Z     m = [m]
store []     (S x) m = Z : store [] x m
store (n:st) Z     m = m : st
store (n:st) (S x) m = n : store st x m

eval :: State -> E -> V
eval st (N n)     = n
eval st (V x)     = fetch st x
eval st (Add a b) = eval st a + eval st b
eval st (Mul a b) = eval st a * eval st b
eval st (Eq a b)  = if eval st a == eval st b then S Z else Z

run :: State -> [P] -> [Nat]
run st []              = []
run st (While e p : r) = run st (If e (p ++ [While e p]) [] : r)
run st (Print e   : r) = eval st e : run st r
run st (If e p q  : r)
  | eval st e == Z     = run st (q ++ r)
  | otherwise          = run st (p ++ r)
run st ((x := e)  : r) = run (store st x (eval st e)) r

opti :: P -> P
opti (While e p) = While e (p ++ p)
opti (If c p q)  = If c q p
--opti (p :>> q)   = opti p :>> opti q
--opti (If e p q)  = If e (opti p) (opti q)
opti p           = p

eqTrace []     []     = True
eqTrace (x:xs) (y:ys) = x == y && xs `eqTrace` ys
eqTrace _      _      = False

prop_opti p = run [] [p] === run [] [opti p] -- === True

--p = While (Eq (V Z) (N Z)) [Z := N (S Z), Print (V Z)]

