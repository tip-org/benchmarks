{-# LANGUAGE DeriveDataTypeable #-}
module Nat where

import Prelude hiding ((+),(*),(-),(<),(^))
import Tip.DSL
import Test.QuickCheck hiding ((==>))
import Data.Typeable

data Nat = Z | S Nat deriving (Eq,Ord,Show,Typeable)

infixl 6 -
infixl 6 +
infixl 7 *
infixl 8 ^

(+) :: Nat -> Nat -> Nat
S n + m = S (n + m)
Z   + m = m

(*) :: Nat -> Nat -> Nat
S n * m = m + (n * m)
Z   * m = Z

(^) :: Nat -> Nat -> Nat
n ^ (S m) = n * n ^ m
n ^ Z     = S Z

-- Property about the power function over naturals.
prop_pow_pow   x y z = x ^ (y * z) =:= (x ^ y) ^ z
prop_pow_times x y z = x ^ (y + z) =:= (x ^ y) * (x ^ z)
prop_pow_one x = S Z ^ x =:= S Z

-- | Truncated subtraction
(-) :: Nat -> Nat -> Nat
S n - S m = n - m
m   - Z   = m
Z   - _   = Z

(<) :: Nat -> Nat -> Bool
Z < _     = True
_ < Z     = False
S n < S m = n < m

infix 3 <

factorial :: Nat -> Nat
factorial Z     = S Z
factorial (S n) = S n * factorial n

-- 2^n < n! for n > 3
prop_pow_le_factorial n = S (S Z) ^ S (S (S (S n))) < factorial (S (S (S (S n)))) =:= True

instance Enum Nat where
  toEnum 0 = Z
  toEnum n = S (toEnum (pred n))
  fromEnum Z = 0
  fromEnum (S n) = succ (fromEnum n)

instance Arbitrary Nat where
  arbitrary = sized $ \ s -> do
    x <- choose (0,round (sqrt (toEnum s)))
    return (toEnum x)

alt_mul :: Nat -> Nat -> Nat
alt_mul Z     y     = Z
alt_mul x     Z     = Z
alt_mul (S x) (S y) = S (alt_mul x y + x + y)

acc_plus (S x) y = acc_plus x (S y)
acc_plus Z     y = y

acc_alt_mul :: Nat -> Nat -> Nat
acc_alt_mul Z     y     = Z
acc_alt_mul x     Z     = Z
acc_alt_mul (S x) (S y) = S (x `acc_plus` (y `acc_plus` acc_alt_mul x y))

-- Property about accumulative addition function.
prop_acc_plus_same = (+) =:= acc_plus
prop_acc_plus_comm x y = x `acc_plus` y =:= y `acc_plus` x
prop_acc_plus_assoc x y z = x `acc_plus` (y `acc_plus` z) =:= (x `acc_plus` y) `acc_plus` z




-- Property about an alternative multiplication function which exhibits an
-- interesting recursion structure.
prop_alt_mul_same = alt_mul =:= (*)
prop_alt_mul_comm x y = x `alt_mul` y =:= y `alt_mul` x
prop_alt_mul_assoc x y z = x `alt_mul` (y `alt_mul` z) =:= (x `alt_mul` y) `alt_mul` z

-- Property about an alternative multiplication function with an
-- interesting recursion structure that also calls an addition
-- function with an accumulating parameter.
prop_acc_alt_mul_comm x y = x `acc_alt_mul` y =:= y `acc_alt_mul` x
prop_acc_alt_mul_same = acc_alt_mul =:= (*)
prop_acc_alt_mul_assoc x y z = x `acc_alt_mul` (y `acc_alt_mul` z) =:= (x `acc_alt_mul` y) `acc_alt_mul` z

