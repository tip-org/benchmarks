module Calc where

import Tip.Prelude hiding (ordered)
import qualified Prelude

data Expr
  = Var Nat
--   | Plus Expr Expr
--   | Mul  Expr Expr
  | NatRec  Expr Expr
--  | Const Nat
  | Zero
  | Succ Expr

natrec Z     z s = z
natrec (S n) z s = s {- n -} (natrec n z s)

eval :: [Nat] -> Expr -> Maybe Nat
eval env (Var x)      = index env x
-- eval env (Plus p1 p2) = eval env p1 + eval env p2
-- eval env (Mul p1 p2)  = eval env p1 * eval env p2
eval env (NatRec z s) =
  case env of
    S n:g -> case eval (n:g) (NatRec z s) of
               Just v -> eval (v:g) s
               Nothing -> Nothing
    Z:g -> eval g z
    []  -> Nothing
-- eval env (Const b)    = b
eval env Zero = Just Z
eval env (Succ e) =
  case eval env e of
    Just n  -> Just (S n)
    Nothing -> Nothing


{-
sat_not_assoc e x y z =
  question
    (    eval [x,eval [y,z] e] e
     =/= eval [eval [x,y] e,z] e
    .&&. eval [Z,Z] e =/= eval [Z,S Z] e
    .&&. eval [Z,Z] e =/= eval [S Z,Z] e
    .&&. eval [Z,Z] e =/= eval [S Z,S Z] e
    )

sat_not_comm e x y =
  question
    (    eval [x,y] e =/= eval [y,x] e
    .&&. eval [x,y] e =/= x
    .&&. eval [x,y] e =/= y
    .&&. eval [x,Z] e =/= eval [x,S Z] e
    .&&. eval [Z,y] e =/= eval [S Z,y] e
    )
    -}

n0 = Z
n1 = S Z
n2 = S (S Z)
n3 = S (S (S Z))

sat_plus e =
  question
    (
      eval [n0,n0] e === Just (n0 + n0) .&&.
      eval [n1,n0] e === Just (n1 + n0) .&&.
      eval [n0,n1] e === Just (n0 + n1) .&&.
      eval [n1,n1] e === Just (n1 + n1) .&&.
      eval [n1,n2] e === Just (n1 + n2) .&&.
      eval [n2,n1] e === Just (n2 + n1) .&&.
      eval [n2,n2] e === Just (n2 + n2)
    )

sat_mul e =
  question
    (
      eval [n0,n0] e === Just (n0 * n0) .&&.
      eval [n1,n0] e === Just (n1 * n0) .&&.
      eval [n0,n1] e === Just (n0 * n1) .&&.
      eval [n1,n1] e === Just (n1 * n1) .&&.
      eval [n1,n2] e === Just (n1 * n2) .&&.
      eval [n2,n1] e === Just (n2 * n1) .&&.
      eval [n2,n2] e === Just (n2 * n2)
      {-
      eval [n0,n0] e === Just (n0 * n0) .&&.
      eval [n0,n1] e === Just (n0 * n1) .&&.
      eval [n0,n2] e === Just (n0 * n2) .&&.
      eval [n0,n3] e === Just (n0 * n3) .&&.
      eval [n1,n0] e === Just (n1 * n0) .&&.
      eval [n1,n1] e === Just (n1 * n1) .&&.
      eval [n1,n2] e === Just (n1 * n2) .&&.
      eval [n1,n3] e === Just (n1 * n3) .&&.
      eval [n2,n0] e === Just (n2 * n0) .&&.
      eval [n2,n1] e === Just (n2 * n1) .&&.
      eval [n2,n2] e === Just (n2 * n2) .&&.
      eval [n2,n2] e === Just (n2 * n3) .&&.
      eval [n3,n0] e === Just (n3 * n0) .&&.
      eval [n3,n1] e === Just (n3 * n1) .&&.
      eval [n3,n2] e === Just (n3 * n2) .&&.
      eval [n3,n3] e === Just (n3 * n3)
      -}
    )

sat_minus e =
  question
    (
      eval [n0,n0] e === Just (n0 - n0) .&&.
      eval [n0,n1] e === Just (n0 - n1) .&&.
      eval [n0,n2] e === Just (n0 - n2) .&&.
      eval [n1,n0] e === Just (n1 - n0) .&&.
      eval [n1,n1] e === Just (n1 - n1) .&&.
      eval [n1,n2] e === Just (n1 - n2) .&&.
      eval [n2,n0] e === Just (n2 - n0) .&&.
      eval [n2,n1] e === Just (n2 - n1) .&&.
      eval [n2,n2] e === Just (n2 - n2)
    )

{-
x = Var Z
y = Var (S Z)
z = Var (S (S Z))

infixr 3 ***
infixr 2 +++
(+++) = Plus
(***) = Mul

varIn :: Nat -> Expr -> Bool
x `varIn` Var y      = x == y
x `varIn` Plus e1 e2 = x `varIn` e1 || x `varIn` e2
x `varIn` Mul e1 e2  = x `varIn` e1 || x `varIn` e2
x `varIn` Const b    = False
-}


-- sat_xy  env = question (eval env ((x `Or` y) `And` (Not x `Or` Not y)))
-- sat_xyz env =
--   question
--     (    eval env (x `Plus` Const (S (S (S (S (S Z))))))
--      === eval env (Const (S (S Z)) `Mul` x))

{-
sat e x =
  question
    (     Z `varIn` e
     .&&. S Z `varIn` e
     .&&. eval [S Z,S Z] e === x
     .&&. eval [S (S Z),S (S Z)] e === x
     .&&. x =/= Z
    )
    -}
