module Turing where

import Tip
-- import Test.LazySmallCheck hiding ((==>))

data A = O | A | B
 deriving (Eq,Ord,Show)

-- instance Serial A where
--   series = cons0 O \/ cons0 A \/ cons0 B

data Action = Lft Nat | Rgt Nat | Stp
 deriving (Eq,Ord,Show)

-- instance Serial Action where
--   series = cons1 Lft \/ cons1 Rgt \/ cons0 Stp

type Q = [((Nat,A),(A,Action))]

type State = (Nat,[A],[A])

data Nat = Zero | Succ Nat
 deriving (Eq,Ord,Show)

-- instance Serial Nat where
--   series = cons0 Zero \/ cons1 Succ

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
  if sa == sa0 then
    rhs
   else
    apply q sa0

act Stp     lft x rgt = Left (rev lft (x:rgt))
act (Lft s) lft x rgt = Right (s, lft', y:x:rgt) where (y,lft') = split lft
act (Rgt s) lft x rgt = Right (s, x:lft, rgt)

runt :: Q -> [A] -> [A]
runt q tape = steps q (Zero,[],tape)

-- FLAGS: csteps
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

2 A -> 2 A, Rgt
2 B -> 1 B, Lft
1 B -> 2 A, Rgt
1 A -> 0 B, -

(Succ (Succ Zero)) A0) (Tup0 (Succ (Succ Zero)) A0) Rgt)
(Succ (Succ Zero)) B) (Tup0 (Succ Zero) B) Lft)
(Succ Zero) B) (Tup0 (Succ (Succ Zero)) A0) Rgt)
(Succ Zero) A0) (Tup0 Zero B) Lft) Nil))),())

5 A -> 5 A, Rgt
1 B -> 5 A, Rgt
5 B -> 2 B, Lft
2 A -> 0 B, -
1 A -> 0 A, -

(Cons (Trip0 (Tup0 (Succ (Succ (Succ (Succ (Succ Zero))))) A0) (Tup0 (Succ (Succ (Succ (Succ (Succ Zero))))) A0) Rgt)
(Cons (Trip0 (Tup0 (Succ Zero) B) (Tup0 (Succ (Succ (Succ (Succ (Succ Zero))))) A0) Rgt)
(Cons (Trip0 (Tup0 (Succ (Succ (Succ (Succ (Succ Zero))))) B) (Tup0 (Succ (Succ Zero)) B) Lft)
(Cons (Trip0 (Tup0 (Succ (Succ Zero)) A0) (Tup0 Zero B) Rgt)
(Cons (Trip0 (Tup0 (Succ Zero) A0) (Tup0 Zero A0) Rgt)
(Cons (Trip0 Thunk_Tup Thunk_Tup Rgt) Thunk_List))))),())

2 A -> A, Rgt 2
1 A -> A, -
1 B -> A, Rgt 2
2 B -> B, Lft 0
0 A -> B, -

(Cons (Tup0 (Tup0 (Succ (Succ Zero)) A0) (Tup0 A0 (Rgt (Succ (Succ Zero)))))
(Cons (Tup0 (Tup0 (Succ Zero) A0) (Tup0 A0 Stp))
(Cons (Tup0 (Tup0 (Succ Zero) B) (Tup0 A0 (Rgt (Succ (Succ Zero)))))
(Cons (Tup0 (Tup0 (Succ (Succ Zero)) B) (Tup0 B (Lft Zero)))
(Cons (Tup0 (Tup0 Zero A0) (Tup0 B Stp)) Nil)))),())

0 A -> A, -
0 B -> A, Rgt 1
1 A -> A, Rgt 1
1 B -> B, Lft 2
2 A -> B, -

(Tup0 A0 Stp,(Tup0 A0 (Rgt (Succ Zero)),(Tup0 A0 (Rgt (Succ Zero)),(Tup0 B (Lft (Succ (Succ Zero))),(Tup0 B Stp,())))))

0 X -> X, Rgt 1
0 A -> B, Rgt 0
1 O -> A, Rgt 0
0 O -> A, -

(Cons (Tup0 (Tup0 Zero X) (Tup0 X (Rgt (Succ Zero))))
(Cons (Tup0 (Tup0 Zero A0) (Tup0 B (Rgt Zero)))
(Cons (Tup0 (Tup0 (Succ Zero) O) (Tup0 A0 (Rgt Zero)))
(Cons (Tup0 (Tup0 Zero O) (Tup0 A0 Stp)) Nil))),())


-}

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

prop q = prog0 q === False

-- prop_prop q = neg (lift (prog0 q))

-- prop_help x y z v w = prog0 [((Zero,A),x),((Zero,B),y),((one,A),z),((one,B),v),((two,A),w){-  ,((two,B),u) -}] === False

--prop_prop_help x y z v w = neg (lift (prog0 [((Zero,A),x),((Zero,B),y),((one,A),z),((one,B),v),((two,A),w){-  ,((two,B),u) -}]))

