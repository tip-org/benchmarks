-- The implementation of these integers correspond to those in the
-- Agda standard library, which is proved to be a commutative ring
module Integers where

import Prelude (Bool(..))
import Tip hiding (neg)

data Nat = Zero | Succ Nat

infixl 6 -
infixl 6 +
infixl 7 *

(+) :: Nat -> Nat -> Nat
Succ n + m = Succ (n + m)
Zero   + m = m

(*) :: Nat -> Nat -> Nat
Succ n * m = m + (n * m)
Zero   * m = Zero

(<) :: Nat -> Nat -> Bool
Zero   < _      = True
_      < Zero   = False
Succ n < Succ m = n < m

data Z = P Nat | N Nat

-- Natural subtraction
(-) :: Nat -> Nat -> Z
Zero   - Zero     = P Zero
Succ m - Zero     = P (Succ m)
Zero   - Succ n   = N n
Succ m - Succ n   = m - n

{-# NOINLINE neg #-}
neg :: Z -> Z
neg (P (Succ n)) = N n
neg (P Zero)     = P Zero
neg (N n)     = P (Succ n)

-- Integer addition
{-# NOINLINE plus #-}
plus :: Z -> Z -> Z
N m `plus` N n = N (Succ (m + n))
N m `plus` P n = n - Succ m
P m `plus` N n = m - Succ n
P m `plus` P n = P (m + n)

{-# NOINLINE zero #-}
zero :: Z
zero = P Zero

prop_add_ident_left :: Z -> Equality Z
prop_add_ident_left x = x === zero `plus` x

prop_add_ident_right :: Z -> Equality Z
prop_add_ident_right x = x === x `plus` zero

prop_add_assoc :: Z -> Z -> Z -> Equality Z
prop_add_assoc x y z = (x `plus` (y `plus` z)) === ((x `plus` y) `plus` z)

prop_add_comm :: Z -> Z -> Equality Z
prop_add_comm x y = (x `plus` y) === (y `plus` x)

prop_add_inv_left :: Z -> Equality Z
prop_add_inv_left x = neg x `plus` x === zero

prop_add_inv_right :: Z -> Equality Z
prop_add_inv_right x = x `plus` neg x === zero

-- Integer subtraction
{-# NOINLINE (-.) #-}
(-.) :: Z -> Z -> Z
N m -. N n = n - m
N m -. P n = N (n + m)
P m -. N n = P (Succ (n + m))
P m -. P n = m - n

{-# NOINLINE absVal #-}
absVal :: Z -> Nat
absVal (P n) = n
absVal (N n) = Succ n

data Sign = Pos | Neg

{-# NOINLINE opposite #-}
opposite :: Sign -> Sign
opposite Pos = Neg
opposite Neg = Pos

{-# NOINLINE timesSign #-}
timesSign :: Sign -> Sign -> Sign
Pos `timesSign` x = x
Neg `timesSign` x = opposite x

{-# NOINLINE sign #-}
sign :: Z -> Sign
sign (P _) = Pos
sign (N _) = Neg

{-# NOINLINE toInteger #-}
toInteger :: Sign -> Nat -> Z
Pos `toInteger` n        = P n
Neg `toInteger` Zero     = P Zero
Neg `toInteger` (Succ m) = N m

-- Integer multiplication
{-# NOINLINE times #-}
times :: Z -> Z -> Z
i `times` j = (sign i `timesSign` sign j) `toInteger` (absVal i * absVal j)

{-# NOINLINE one #-}
one :: Z
one = P (Succ Zero)

prop_mul_ident_left :: Z -> Equality Z
prop_mul_ident_left x = x === one `times` x

prop_mul_ident_right :: Z -> Equality Z
prop_mul_ident_right x = x === x `times` one

prop_mul_assoc :: Z -> Z -> Z -> Equality Z
prop_mul_assoc x y z = (x `times` (y `times` z)) === ((x `times` y) `times` z)

prop_mul_comm :: Z -> Z -> Equality Z
prop_mul_comm x y = (x `times` y) === (y `times` x)

prop_left_distrib :: Z -> Z -> Z -> Equality Z
prop_left_distrib x y z = x `times` (y `plus` z) === (x `times` y) `plus` (x `times` z)

prop_right_distrib :: Z -> Z -> Z -> Equality Z
prop_right_distrib x y z = (x `plus` y) `times` z === (x `times` z) `plus` (y `times` z)

