module SimplerCalc2 where

import Tip.Prelude hiding (ordered)
import qualified Prelude

data Expr
  = Var Nat
  | Plus Expr Expr
  | Const Nat

eval :: [Nat] -> Expr -> Nat
eval env (Var x)      = case index env x of Just y  -> y
                                            Nothing -> S Z
eval env (Plus p1 p2) = eval env p1 + eval env p2
eval env (Const b)    = S b

x `varIn` Var y    = x == y
x `varIn` Plus a b = x `varIn` a || x `varIn` b
x `varIn` Const _  = False

sat_not_assoc e x y z =
  question
    (    eval [x,eval [y,z] e] e
     =/= eval [eval [x,y] e,z] e
     .&&. Z   `varIn` e
     .&&. S Z `varIn` e
    )

sat_not_comm e x y =
  question
    (    eval [x,y] e =/= eval [y,x] e
    .&&. Z   `varIn` e
    .&&. S Z `varIn` e
    )

