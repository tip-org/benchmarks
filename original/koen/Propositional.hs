-- Propositional solver
module Propositional where

import Tip hiding (Not)

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
  [ (x,True) : inline filter ((x /=).fst) m
  | not (or [x == y | (y, False) <- m])
  ]

models (Not (Var x)) m =
  [ (x,False) : inline filter ((x /=).fst) m
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
  valid (p :&: q) ==> valid q

--------------------------------------------------------------------------------

okay :: Val -> Bool
okay []        = True
okay ((x,b):m) = not (x `elem` inline map fst m) && okay m

prop_Okay p =
  inline all okay (models p []) === True

(|=) :: Val -> Form -> Bool
m |= Var x     = or [ x == y | (y, True) <- m ]
m |= Not p     = not (m |= p)
m |= (p :&: q) = m |= p && m |= q

prop_Sound p =
  inline all (|= p) (models p []) === True
