{-# LANGUAGE CPP #-}
module Calc where

import Tip.Prelude hiding (ordered)
import qualified Prelude

data Expr
  = Var Nat
  | Plus Expr Expr
  | Mul  Expr Expr
  | Const Nat

eval :: [Nat] -> Expr -> Nat
eval env (Var x)      = case index env x of Just y  -> y
                                            Nothing -> S Z
eval env (Plus p1 p2) = eval env p1 + eval env p2
eval env (Mul p1 p2)  = eval env p1 * eval env p2
eval env (Const b)    = S b

x `varIn` Var y    = x == y
x `varIn` Plus a b = x `varIn` a || x `varIn` b
x `varIn` Mul  a b = x `varIn` a || x `varIn` b
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

sat_polynomial_a e =
  question
    (
#define x Z
         eval [x] e === S x * S x
#undef x
#define x (S Z)
    .&&. eval [x] e === S x * S x
#undef x
#define x (S (S Z))
    .&&. eval [x] e === S x * S x
#undef x
#define x (S (S (S Z)))
    .&&. eval [x] e === S x * S x
#undef x
    )

sat_polynomial_b e =
  question
    (
#define x Z
         eval [x] e === S x * S x + S x
#undef x
#define x (S Z)
    .&&. eval [x] e === S x * S x + S x
#undef x
#define x (S (S Z))
    .&&. eval [x] e === S x * S x + S x
#undef x
#define x (S (S (S Z)))
    .&&. eval [x] e === S x * S x + S x
#undef x
    )

sat_polynomial_c e =
  question
    (
#define x Z
         eval [x] e === S x * S (S x)
#undef x
#define x (S Z)
    .&&. eval [x] e === S x * S (S x)
#undef x
#define x (S (S Z))
    .&&. eval [x] e === S x * S (S x)
#undef x
#define x (S (S (S Z)))
    .&&. eval [x] e === S x * S (S x)
#undef x
    )

sat_polynomial_d e =
  question
    (
#define x Z
         eval [x] e === S x * S x * S x
#undef x
#define x (S Z)
    .&&. eval [x] e === S x * S x * S x
#undef x
#define x (S (S Z))
    .&&. eval [x] e === S x * S x * S x
#undef x
#define x (S (S (S Z)))
    .&&. eval [x] e === S x * S x * S x
#undef x
    )

sat_polynomial_e e =
  question
    (
#define x Z
         eval [x] e === S x * S x * S (S x)
#undef x
#define x (S Z)
    .&&. eval [x] e === S x * S x * S (S x)
#undef x
#define x (S (S Z))
    .&&. eval [x] e === S x * S x * S (S x)
#undef x
#define x (S (S (S Z)))
    .&&. eval [x] e === S x * S x * S (S x)
#undef x
    )

sat_polynomial_f e =
  question
    (
#define x Z
         eval [x] e === S x * S x + x * x
#undef x
#define x (S Z)
    .&&. eval [x] e === S x * S x + x * x
#undef x
#define x (S (S Z))
    .&&. eval [x] e === S x * S x + x * x
#undef x
#define x (S (S (S Z)))
    .&&. eval [x] e === S x * S x + x * x
#undef x
    )

