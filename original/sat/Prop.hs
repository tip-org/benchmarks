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
f  = False

cnf (And x y) = disj x && cnf y
cnf x         = disj x

disj (Or x y) = atom x && disj y
disj x        = atom x

atom (Not x) = var x
atom x       = var x

var (Var _) = True
var _       = False

sat_cnf_one_two e =
  question
    (    cnf e
    .&&. not (eval [tt,tt] e)
    .&&.     (eval [f ,tt] e)
    .&&.     (eval [tt,f ] e)
    .&&. not (eval [f ,f ] e))

sat_cnf_one_three e =
  question
    (    cnf e
    .&&. not (eval [tt,tt,tt] e)
    .&&. not (eval [tt,tt,f ] e)
    .&&. not (eval [tt,f ,tt] e)
    .&&.     (eval [tt,f ,f ] e)
    .&&. not (eval [f ,tt,tt] e)
    .&&.     (eval [f ,tt,f ] e)
    .&&.     (eval [f ,f ,tt] e)
    .&&. not (eval [f ,f ,f ] e))

sat_cnf_xor_three e =
  question
    (    cnf e
    .&&.     (eval [tt,tt,tt] e)
    .&&. not (eval [tt,tt,f ] e)
    .&&. not (eval [tt,f ,tt] e)
    .&&.     (eval [tt,f ,f ] e)
    .&&. not (eval [f ,tt,tt] e)
    .&&.     (eval [f ,tt,f ] e)
    .&&.     (eval [f ,f ,tt] e)
    .&&. not (eval [f ,f ,f ] e))

sat_cnf_one_four e =
  question
    (    cnf e
    .&&. not (eval [tt,tt,tt,tt] e)
    .&&. not (eval [tt,tt,tt,f ] e)
    .&&. not (eval [tt,tt,f ,tt] e)
    .&&. not (eval [tt,tt,f ,f ] e)
    .&&. not (eval [tt,f ,tt,tt] e)
    .&&. not (eval [tt,f ,tt,f ] e)
    .&&. not (eval [tt,f ,f ,tt] e)
    .&&.     (eval [tt,f ,f ,f ] e)
    .&&. not (eval [f ,tt,tt,tt] e)
    .&&. not (eval [f ,tt,tt,f ] e)
    .&&. not (eval [f ,tt,f ,tt] e)
    .&&.     (eval [f ,tt,f ,f ] e)
    .&&. not (eval [f ,f ,tt,tt] e)
    .&&.     (eval [f ,f ,tt,f ] e)
    .&&.     (eval [f ,f ,f ,tt] e)
    .&&. not (eval [f ,f ,f ,f ] e))

sat_cnf_two_four e =
  question
    (    cnf e
    .&&. not (eval [tt,tt,tt,tt] e)
    .&&. not (eval [tt,tt,tt,f ] e)
    .&&. not (eval [tt,tt,f ,tt] e)
    .&&.     (eval [tt,tt,f ,f ] e)
    .&&. not (eval [tt,f ,tt,tt] e)
    .&&.     (eval [tt,f ,tt,f ] e)
    .&&.     (eval [tt,f ,f ,tt] e)
    .&&. not (eval [tt,f ,f ,f ] e)
    .&&. not (eval [f ,tt,tt,tt] e)
    .&&.     (eval [f ,tt,tt,f ] e)
    .&&.     (eval [f ,tt,f ,tt] e)
    .&&. not (eval [f ,tt,f ,f ] e)
    .&&.     (eval [f ,f ,tt,tt] e)
    .&&. not (eval [f ,f ,tt,f ] e)
    .&&. not (eval [f ,f ,f ,tt] e)
    .&&. not (eval [f ,f ,f ,f ] e))

sat_one_two e =
  question
    (    not (eval [tt,tt] e)
    .&&.     (eval [f ,tt] e)
    .&&.     (eval [tt,f ] e)
    .&&. not (eval [f ,f ] e))

sat_one_three e =
  question
    (    not (eval [tt,tt,tt] e)
    .&&. not (eval [tt,tt,f ] e)
    .&&. not (eval [tt,f ,tt] e)
    .&&.     (eval [tt,f ,f ] e)
    .&&. not (eval [f ,tt,tt] e)
    .&&.     (eval [f ,tt,f ] e)
    .&&.     (eval [f ,f ,tt] e)
    .&&. not (eval [f ,f ,f ] e))

sat_xor_three e =
  question
    (        (eval [tt,tt,tt] e)
    .&&. not (eval [tt,tt,f ] e)
    .&&. not (eval [tt,f ,tt] e)
    .&&.     (eval [tt,f ,f ] e)
    .&&. not (eval [f ,tt,tt] e)
    .&&.     (eval [f ,tt,f ] e)
    .&&.     (eval [f ,f ,tt] e)
    .&&. not (eval [f ,f ,f ] e))

sat_one_four e =
  question
    (    not (eval [tt,tt,tt,tt] e)
    .&&. not (eval [tt,tt,tt,f ] e)
    .&&. not (eval [tt,tt,f ,tt] e)
    .&&. not (eval [tt,tt,f ,f ] e)
    .&&. not (eval [tt,f ,tt,tt] e)
    .&&. not (eval [tt,f ,tt,f ] e)
    .&&. not (eval [tt,f ,f ,tt] e)
    .&&.     (eval [tt,f ,f ,f ] e)
    .&&. not (eval [f ,tt,tt,tt] e)
    .&&. not (eval [f ,tt,tt,f ] e)
    .&&. not (eval [f ,tt,f ,tt] e)
    .&&.     (eval [f ,tt,f ,f ] e)
    .&&. not (eval [f ,f ,tt,tt] e)
    .&&.     (eval [f ,f ,tt,f ] e)
    .&&.     (eval [f ,f ,f ,tt] e)
    .&&. not (eval [f ,f ,f ,f ] e))

sat_two_four e =
  question
    (    not (eval [tt,tt,tt,tt] e)
    .&&. not (eval [tt,tt,tt,f ] e)
    .&&. not (eval [tt,tt,f ,tt] e)
    .&&.     (eval [tt,tt,f ,f ] e)
    .&&. not (eval [tt,f ,tt,tt] e)
    .&&.     (eval [tt,f ,tt,f ] e)
    .&&.     (eval [tt,f ,f ,tt] e)
    .&&. not (eval [tt,f ,f ,f ] e)
    .&&. not (eval [f ,tt,tt,tt] e)
    .&&.     (eval [f ,tt,tt,f ] e)
    .&&.     (eval [f ,tt,f ,tt] e)
    .&&. not (eval [f ,tt,f ,f ] e)
    .&&.     (eval [f ,f ,tt,tt] e)
    .&&. not (eval [f ,f ,tt,f ] e)
    .&&. not (eval [f ,f ,f ,tt] e)
    .&&. not (eval [f ,f ,f ,f ] e))

