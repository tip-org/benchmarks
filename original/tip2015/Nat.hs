module Nat where

import Tip.Prelude
import qualified Prelude as P

-- Property about the power function over naturals.
prop_pow_pow   x y z = x ^ (y * z) === (x ^ y) ^ z
prop_pow_times x y z = x ^ (y + z) === (x ^ y) * (x ^ z)
prop_pow_one x = S Z ^ x === S Z

factorial :: Nat -> Nat
factorial Z     = S Z
factorial (S n) = S n * factorial n

-- 2^n < n! for n > 3
prop_pow_le_factorial n = bool (S (S Z) ^ S (S (S (S n))) < factorial (S (S (S (S n)))))

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
prop_acc_plus_same = (+) === acc_plus
prop_acc_plus_comm x y = x `acc_plus` y === y `acc_plus` x
prop_acc_plus_assoc x y z = x `acc_plus` (y `acc_plus` z) === (x `acc_plus` y) `acc_plus` z

-- Property about an alternative multiplication function which exhibits an
-- interesting recursion structure.
prop_alt_mul_same = alt_mul === (*)
prop_alt_mul_comm x y = x `alt_mul` y === y `alt_mul` x
prop_alt_mul_assoc x y z = x `alt_mul` (y `alt_mul` z) === (x `alt_mul` y) `alt_mul` z

-- Property about an alternative multiplication function with an
-- interesting recursion structure that also calls an addition
-- function with an accumulating parameter.
prop_acc_alt_mul_comm x y = x `acc_alt_mul` y === y `acc_alt_mul` x
prop_acc_alt_mul_same = acc_alt_mul === (*)
prop_acc_alt_mul_assoc x y z = x `acc_alt_mul` (y `acc_alt_mul` z) === (x `acc_alt_mul` y) `acc_alt_mul` z

prop_max_idem  x     = x `max` x === x
prop_max_assoc x y z = x `max` (y `max` z) === (x `max` y) `max` z
prop_max_comm x y    = x `max` y === y `max` x

prop_boring_min_idem  x     = x `min` x === x
prop_boring_min_assoc x y z = x `min` (y `min` z) === (x `min` y) `min` z
prop_boring_min_comm x y    = x `min` y === y `min` x

prop_min_max_abs x y = x `min` (x `max` y) === x
prop_boring_max_min_abs x y = x `max` (x `min` y) === x

prop_min_max_distrib x y z = x `max` (y `min` z) === (x `max` y) `min` (x `max` z)
prop_boring_max_min_distrib x y z = x `min` (y `max` z) === (x `min` y) `max` (x `min` z)

prop_lt_trans x y z = x < y ==> y < z ==> x < z
prop_lt_asymmetric x y = x < y ==> neg (y < x)
prop_lt_irreflexive x = neg (x < x)

prop_boring_gt_trans x y z = x > y ==> y > z ==> x > z
prop_boring_gt_asymmetric x y = x > y ==> neg (y > x)
prop_boring_gt_irreflexive x = neg (x > x)

prop_le_trans x y z = x <= y ==> y <= z ==> x <= z
prop_le_antisym x y = x <= y ==> y <= x ==> x === y
prop_le_reflexive x = x <= x === True

prop_boring_ge_trans x y z = x >= y ==> y >= z ==> x >= z
prop_boring_ge_antisym x y = x >= y ==> y >= x ==> x === y
prop_boring_ge_reflexive x = x >= x === True

prop_le_ge_eq x y = x >= y ==> x <= y ==> x == y
prop_le_ne_lt x y = x <= y ==> x /= y ==> x < y

prop_eq_trans x y z = x == y ==> y == z ==> x == z
prop_eq_sym x y = x == y ==> y == x
prop_eq_refl x = x == x === True

prop_lt_ne x y = y < x ==> x /= y

-- | Very simple questions about natural numbers
sat_minus_comm x y        = x - y === y - x
sat_minus_assoc x y z     = (x - y) - z === x - (y - z)
sat_plus_idem x           = x + x === x
sat_plus_idem_somewhere x = question (x + x === x)
sat_pow_le_factorial n    = question ((S (S Z) ^ n) < factorial n)

