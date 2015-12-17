module Prop where

import Tip.Prelude hiding (ordered)
import qualified Prelude

data Prop
  = Not Prop
  | Var Nat
  | And Prop Prop
  | Or Prop Prop
  | Const Bool

eval :: [Bool] -> Prop -> Bool
eval env (Not p)     = not (eval env p)
eval env (Var x)     = case index env x of
                         Just y  -> y
                         Nothing -> False
eval env (And p1 p2) = eval env p1 && eval env p2
eval env (Or p1 p2)  = eval env p1 || eval env p2
eval env (Const b)   = b

sat_cnf_not_assoc e x y z =
  question
    (    eval [x,eval [y,z] e] e
     =/= eval [eval [x,y] e,z] e
     .&&. eval [x,False] e =/= eval [x,True] e
     .&&. eval [False,y] e =/= eval [True,y] e
    )

sat_cnf_not_comm e x y =
  question
    (    eval [x,y] e =/= eval [y,x] e
    .&&. eval [x,False] e =/= eval [x,True] e
    .&&. eval [False,y] e =/= eval [True,y] e
    )

tt = True
__ = False

cn__(And x y) = disj x && cn__y
cn__x         = disj x

disj (Or x y) = atom x && disj y
disj x        = atom x

atom (Not x) = var x
atom x       = var x

var (Var _) = True
var _       = False

sat_cnf_one_two e =
  question
    (    cn__e
    .&&. not (eval [tt,tt] e)
    .&&.     (eval [__,tt] e)
    .&&.     (eval [tt,__] e)
    .&&. not (eval [__,__] e))

sat_cnf_one_three e =
  question
    (    cn__e
    .&&. not (eval [tt,tt,tt] e)
    .&&. not (eval [tt,tt,__] e)
    .&&. not (eval [tt,__,tt] e)
    .&&.     (eval [tt,__,__] e)
    .&&. not (eval [__,tt,tt] e)
    .&&.     (eval [__,tt,__] e)
    .&&.     (eval [__,__,tt] e)
    .&&. not (eval [__,__,__] e))

sat_cnf_xor_three e =
  question
    (    cn__e
    .&&.     (eval [tt,tt,tt] e)
    .&&. not (eval [tt,tt,__] e)
    .&&. not (eval [tt,__,tt] e)
    .&&.     (eval [tt,__,__] e)
    .&&. not (eval [__,tt,tt] e)
    .&&.     (eval [__,tt,__] e)
    .&&.     (eval [__,__,tt] e)
    .&&. not (eval [__,__,__] e))

sat_cnf_one_four e =
  question
    (    cn__e
    .&&. not (eval [tt,tt,tt,tt] e)
    .&&. not (eval [tt,tt,tt,__] e)
    .&&. not (eval [tt,tt,__,tt] e)
    .&&. not (eval [tt,tt,__,__] e)
    .&&. not (eval [tt,__,tt,tt] e)
    .&&. not (eval [tt,__,tt,__] e)
    .&&. not (eval [tt,__,__,tt] e)
    .&&.     (eval [tt,__,__,__] e)
    .&&. not (eval [__,tt,tt,tt] e)
    .&&. not (eval [__,tt,tt,__] e)
    .&&. not (eval [__,tt,__,tt] e)
    .&&.     (eval [__,tt,__,__] e)
    .&&. not (eval [__,__,tt,tt] e)
    .&&.     (eval [__,__,tt,__] e)
    .&&.     (eval [__,__,__,tt] e)
    .&&. not (eval [__,__,__,__] e))

sat_cnf_two_four e =
  question
    (    cn__e
    .&&. not (eval [tt,tt,tt,tt] e)
    .&&. not (eval [tt,tt,tt,__] e)
    .&&. not (eval [tt,tt,__,tt] e)
    .&&.     (eval [tt,tt,__,__] e)
    .&&. not (eval [tt,__,tt,tt] e)
    .&&.     (eval [tt,__,tt,__] e)
    .&&.     (eval [tt,__,__,tt] e)
    .&&. not (eval [tt,__,__,__] e)
    .&&. not (eval [__,tt,tt,tt] e)
    .&&.     (eval [__,tt,tt,__] e)
    .&&.     (eval [__,tt,__,tt] e)
    .&&. not (eval [__,tt,__,__] e)
    .&&.     (eval [__,__,tt,tt] e)
    .&&. not (eval [__,__,tt,__] e)
    .&&. not (eval [__,__,__,tt] e)
    .&&. not (eval [__,__,__,__] e))

sat_one_two e =
  question
    (    not (eval [tt,tt] e)
    .&&.     (eval [__,tt] e)
    .&&.     (eval [tt,__] e)
    .&&. not (eval [__,__] e))

sat_one_three e =
  question
    (    not (eval [tt,tt,tt] e)
    .&&. not (eval [tt,tt,__] e)
    .&&. not (eval [tt,__,tt] e)
    .&&.     (eval [tt,__,__] e)
    .&&. not (eval [__,tt,tt] e)
    .&&.     (eval [__,tt,__] e)
    .&&.     (eval [__,__,tt] e)
    .&&. not (eval [__,__,__] e))

sat_xor_three e =
  question
    (        (eval [tt,tt,tt] e)
    .&&. not (eval [tt,tt,__] e)
    .&&. not (eval [tt,__,tt] e)
    .&&.     (eval [tt,__,__] e)
    .&&. not (eval [__,tt,tt] e)
    .&&.     (eval [__,tt,__] e)
    .&&.     (eval [__,__,tt] e)
    .&&. not (eval [__,__,__] e))

sat_one_four e =
  question
    (    not (eval [tt,tt,tt,tt] e)
    .&&. not (eval [tt,tt,tt,__] e)
    .&&. not (eval [tt,tt,__,tt] e)
    .&&. not (eval [tt,tt,__,__] e)
    .&&. not (eval [tt,__,tt,tt] e)
    .&&. not (eval [tt,__,tt,__] e)
    .&&. not (eval [tt,__,__,tt] e)
    .&&.     (eval [tt,__,__,__] e)
    .&&. not (eval [__,tt,tt,tt] e)
    .&&. not (eval [__,tt,tt,__] e)
    .&&. not (eval [__,tt,__,tt] e)
    .&&.     (eval [__,tt,__,__] e)
    .&&. not (eval [__,__,tt,tt] e)
    .&&.     (eval [__,__,tt,__] e)
    .&&.     (eval [__,__,__,tt] e)
    .&&. not (eval [__,__,__,__] e))

sat_two_four e =
  question
    (    not (eval [tt,tt,tt,tt] e)
    .&&. not (eval [tt,tt,tt,__] e)
    .&&. not (eval [tt,tt,__,tt] e)
    .&&.     (eval [tt,tt,__,__] e)
    .&&. not (eval [tt,__,tt,tt] e)
    .&&.     (eval [tt,__,tt,__] e)
    .&&.     (eval [tt,__,__,tt] e)
    .&&. not (eval [tt,__,__,__] e)
    .&&. not (eval [__,tt,tt,tt] e)
    .&&.     (eval [__,tt,tt,__] e)
    .&&.     (eval [__,tt,__,tt] e)
    .&&. not (eval [__,tt,__,__] e)
    .&&.     (eval [__,__,tt,tt] e)
    .&&. not (eval [__,__,tt,__] e)
    .&&. not (eval [__,__,__,tt] e)
    .&&. not (eval [__,__,__,__] e))

