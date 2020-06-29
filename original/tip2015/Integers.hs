-- The implementation of these integers correspond to those in the
-- Agda standard library, which is proved to be a commutative ring
module Integers where

import Tip hiding (neg)
import Prelude hiding (Integer,neg,(-),toInteger)
import qualified Prelude as P

data Integer = P Int | N Int

-- Natural subtraction
(-) :: Int -> Int -> Integer
0 - 0 = P 0
m - 0 = P m
0 - n = N (pred n)
m - n = pred m - pred n

{-# NOINLINE neg #-}
neg :: Integer -> Integer
neg (P 0) = P 0
neg (P n) = N (pred n)
neg (N n) = P (1+n)

-- Integer addition
{-# NOINLINE plus #-}
plus :: Integer -> Integer -> Integer
N m `plus` N n = N (1 + m + n)
N m `plus` P n = n - (1 + m)
P m `plus` N n = m - (1 + n)
P m `plus` P n = P (m + n)

{-# NOINLINE zero #-}
zero :: Integer
zero = P 0

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
P m -. N n = P (1 + n + m)
P m -. P n = m - n

{-# NOINLINE absVal #-}
absVal :: Integer -> Int
absVal (P n) = n
absVal (N n) = 1+n

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
toInteger :: Sign -> Int -> Integer
Pos `toInteger` n = P n
Neg `toInteger` 0 = P 0
Neg `toInteger` m = N (pred m)

-- Integer multiplication
{-# NOINLINE times #-}
times :: Integer -> Integer -> Integer
i `times` j = (sign i `timesSign` sign j) `toInteger` (absVal i * absVal j)

{-# NOINLINE one #-}
one :: Integer
one = P 1

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

