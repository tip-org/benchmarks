module Turing where

import Tip

data A = O | A | B
 deriving (Eq,Ord,Show)

data Action = Lft Nat | Rgt Nat | Stp
 deriving (Eq,Ord,Show)

type Q = [((Nat,A),(A,Action))]

type State = (Nat,[A],[A])

data Nat = Zero | Succ Nat
 deriving (Eq,Ord,Show)

step :: Q -> State -> Either [A] State
step q (s,lft,rgt) = act what lft x' rgt'
 where
  (x,rgt')  = split rgt
  (x',what) = apply q (s,x)

split :: [A] -> (A,[A])
split []     = (O,[])
split (x:xs) = (x,xs)

apply :: Q -> (Nat,A) -> (A,Action)
apply [] _ = (O,Stp)
apply ((sa,rhs):q) sa0 =
  if eqT sa sa0 then
    rhs
   else
    apply q sa0

act Stp     lft x rgt = Left (rev lft (x:rgt))
act (Lft s) lft x rgt = Right (s, lft', y:x:rgt) where (y,lft') = split lft
act (Rgt s) lft x rgt = Right (s, x:lft, rgt)

eqT :: (Nat, A) -> (Nat, A) -> Bool
eqT (Zero, a)   (Zero, b)   = eqA a b
eqT (Succ p, a) (Succ q, b) = eqT (p,a) (q,b)
eqT _           _           = False

eqA :: A -> A -> Bool
eqA O O = True
eqA A A = True
eqA B B = True
eqA _ _ = False

eqL :: [A] -> [A] -> Bool
eqL (x:xs) (y:ys) = eqA x y && eqL xs ys
eqL []     []     = True
eqL _      _      = False

runt :: Q -> [A] -> [A]
runt q tape = steps q (Zero,[],tape)

steps :: Q -> State -> [A]
steps q st =
  case step q st of
    Left tape -> tape
    Right st' -> steps q st'

{-
runtN :: Nat -> Q -> [A] -> Maybe [A]
runtN n q tape = stepsN n q (one,[],tape)

stepsN :: Nat -> Q -> State -> Maybe [A]
stepsN Zero q st = Nothing
stepsN (Succ n) q st =
  case step q st of
    (Zero, tape1, tape2) -> Just (rev tape1 tape2)
    st'                  -> stepsN n q st'
-}

rev :: [A] -> [A] -> [A]
rev []     ys = ys
rev (O:xs) ys = ys
rev (x:xs) ys = rev xs (x:ys)

one   = Succ Zero
two   = Succ one
three = Succ two
four  = Succ three
five  = Succ four
six   = Succ five
seven = Succ six

atMost :: Nat -> Bool
atMost (Succ (Succ (Succ (Succ _)))) = False
atMost _                             = True

--lim :: Q -> Bool
--lim [] = True
--lim (((s1,_),(s2,_),_):q) = if atMost s1 then if atMost s2 then lim q else False else False

prog0 :: Q -> Bool
prog0 q = case runt q [A] of
            [A] ->
              case runt q [B,A,A,A,A,B] of
                 [A,A,A,A,B,B] -> True
                 _ -> False
            _ -> False

{-
prog1 :: Q -> Bool
prog1 q = case runtN seven q [B,A,A,A,A,B,X] of
                 Just (A:A:A:A:B:B:X:_) ->
                   case runtN two q [A,X] of
                     Just (A:X:_) -> True
                     _ -> False
                   --True
                 _ -> False
-}

sat_insert_case q = question (prog0 q )

sat_insert_list q = question (runt q [A] `eqL` [A] .&&. runt q [B,A,A,A,A,B] `eqL` [A,A,A,A,B,B])

