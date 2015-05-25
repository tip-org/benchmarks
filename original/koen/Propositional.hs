-- Propositional solver
module Propositional where

import Tip
import Prelude hiding (Eq(..), Ord(..), map, all, elem, null, length, even, or, (++), filter)
import Nat
import qualified Prelude

type OrdA = Int

(>), (<=), (==), (/=) :: Int -> Int -> Bool
(<=) = (Prelude.<=)
(>)  = (Prelude.>)
(==) = (Prelude.==)
(/=) = (Prelude./=)

delete :: Int -> [Int] -> [Int]
delete x [] = []
delete x (y:ys)
  | x == y = ys
  | otherwise = y:delete x ys

[] ++ xs = xs
(x:xs) ++ ys = x:(xs ++ ys)
filter p xs = [ x | x <- xs, p x ]
map f xs = [ f x | x <- xs ]
all p [] = True
all p (x:xs) = p x && all p xs
or [] = False
or (x:xs) = x || or xs
x `elem` [] = False
x `elem` (y:ys) = x == y || x `elem` ys
null [] = True
null _ = False
length [] = Z
length (_:xs) = S (length xs)
even Z = True
even (S Z) = False
even (S (S x)) = even x

--------------------------------------------------------------------------------

type Name = Int -- can be whatever

data Form
  = Form :&: Form
  | Not Form
  | Var Name

type Val = [(Name,Bool)]

models :: Form -> Val -> [Val]
models (p :&: q) m =
  [ m2
  | m1 <- models p m
  , m2 <- models q m1
  ]

models (Not (p :&: q)) m =
  models (Not p) m ++ models (p :&: Not q) m

models (Not (Not p)) m =
  models p m

models (Var x) m =
  [ (x,True) : filter ((x/=).fst) m
  | not (or [x == y | (y, False) <- m])
  ]

models (Not (Var x)) m =
  [ (x,False) : filter ((x/=).fst) m
  | not (or [x == y | (y, True) <- m])
  ]

valid :: Form -> Bool
valid p = null (models (Not p) [])

--------------------------------------------------------------------------------

prop_AndCommutative p q =
  valid (p :&: q) === valid (q :&: p)

prop_AndIdempotent p =
  valid (p :&: p) === valid p

prop_AndImplication p q =
  valid (p :&: q) === True ==> valid q === True

--------------------------------------------------------------------------------

okay :: Val -> Bool
okay []        = True
okay ((x,b):m) = not (x `elem` map fst m) && okay m

prop_Okay p =
  all okay (models p []) === True

(|=) :: Val -> Form -> Bool
m |= Var x     = or [ x == y | (y, True) <- m ]
m |= Not p     = not (m |= p)
m |= (p :&: q) = m |= p && m |= q

prop_Sound p =
  all (|= p) (models p []) === True
