-- Propositional solver
module Propositional where

import Tip.Prelude
import qualified Prelude as P

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
  [ (x,True) : filter ((x P./=).fst) m
  | not (or [x P.== y | (y, False) <- m])
  ]

models (Not (Var x)) m =
  [ (x,False) : filter ((x P./=).fst) m
  | not (or [x P.== y | (y, True) <- m])
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
okay ((x,b):m) = not (x `zelem` map fst m) && okay m

prop_Okay p =
  all okay (models p []) === True

(|=) :: Val -> Form -> Bool
m |= Var x     = or [ x P.== y | (y, True) <- m ]
m |= Not p     = not (m |= p)
m |= (p :&: q) = m |= p && m |= q

prop_Sound p =
  all (|= p) (models p []) === True
