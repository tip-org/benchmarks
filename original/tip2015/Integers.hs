-- The implementation of these integers correspond to those in the
-- Agda standard library, which is proved to be a commutative ring
module Integers where

import Tip.Prelude hiding (neg,(-))
import qualified Prelude as P

data Integer = P Nat | N Nat

-- Natural subtraction
(-) :: Nat -> Nat -> Integer
Z   - Z     = P Z
S m - Z     = P (S m)
Z   - S n   = N n
S m - S n   = m - n

{-# NOINLINE neg #-}
neg :: Integer -> Integer
neg (P (S n)) = N n
neg (P Z)     = P Z
neg (N n)     = P (S n)

-- Integer addition
{-# NOINLINE plus #-}
plus :: Integer -> Integer -> Integer
N m `plus` N n = N (S (m + n))
N m `plus` P n = n - S m
P m `plus` N n = m - S n
P m `plus` P n = P (m + n)

{-# NOINLINE zero #-}
zero :: Integer
zero = P Z

prop_add_ident_left :: Integer -> Equality Integer
prop_add_ident_left x = x === zero `plus` x

prop_add_ident_right :: Integer -> Equality Integer
prop_add_ident_right x = x === x `plus` zero

prop_add_assoc :: Integer -> Integer -> Integer -> Equality Integer
prop_add_assoc x y z = (x `plus` (y `plus` z)) === ((x `plus` y) `plus` z)

prop_add_comm :: Integer -> Integer -> Equality Integer
prop_add_comm x y = (x `plus` y) === (y `plus` x)

prop_add_inv_left :: Integer -> Equality Integer
prop_add_inv_left x = neg x `plus` x === zero

prop_add_inv_right :: Integer -> Equality Integer
prop_add_inv_right x = x `plus` neg x === zero

-- Integer subtraction
{-# NOINLINE (-.) #-}
(-.) :: Integer -> Integer -> Integer
N m -. N n = n - m
N m -. P n = N (n + m)
P m -. N n = P (S (n + m))
P m -. P n = m - n

{-# NOINLINE absVal #-}
absVal :: Integer -> Nat
absVal (P n) = n
absVal (N n) = S n

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
sign :: Integer -> Sign
sign (P _) = Pos
sign (N _) = Neg

{-# NOINLINE toInteger #-}
toInteger :: Sign -> Nat -> Integer
Pos `toInteger` n     = P n
Neg `toInteger` Z     = P Z
Neg `toInteger` (S m) = N m

-- Integer multiplication
{-# NOINLINE times #-}
times :: Integer -> Integer -> Integer
i `times` j = (sign i `timesSign` sign j) `toInteger` (absVal i * absVal j)

{-# NOINLINE one #-}
one :: Integer
one = P (S Z)

prop_mul_ident_left :: Integer -> Equality Integer
prop_mul_ident_left x = x === one `times` x

prop_mul_ident_right :: Integer -> Equality Integer
prop_mul_ident_right x = x === x `times` one

prop_mul_assoc :: Integer -> Integer -> Integer -> Equality Integer
prop_mul_assoc x y z = (x `times` (y `times` z)) === ((x `times` y) `times` z)

prop_mul_comm :: Integer -> Integer -> Equality Integer
prop_mul_comm x y = (x `times` y) === (y `times` x)

prop_left_distrib :: Integer -> Integer -> Integer -> Equality Integer
prop_left_distrib x y z = x `times` (y `plus` z) === (x `times` y) `plus` (x `times` z)

prop_right_distrib :: Integer -> Integer -> Integer -> Equality Integer
prop_right_distrib x y z = (x `plus` y) `times` z === (x `times` z) `plus` (y `times` z)

