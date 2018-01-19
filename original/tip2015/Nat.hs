module Int where

import Tip

-- Property about the power function over naturals.
prop_pow_pow :: Int -> Int -> Int -> Property
prop_pow_pow   x y z = x ^ (y * z) === (x ^ y) ^ z

prop_pow_times :: Int -> Int -> Int -> Property
prop_pow_times x y z = x ^ (y + z) === (x ^ y) * (x ^ z)

prop_pow_one :: Int -> Property
prop_pow_one x = (1 :: Int) ^ x === 1

factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n-1)

-- 2^n < n! for n > 3
prop_pow_le_factorial n = bool (2 ^ (4+n) < factorial (4+n))

alt_mul :: Int -> Int -> Int
alt_mul 0 y = 0
alt_mul x 0 = 0
alt_mul x y = 1 + alt_mul (x-1) (y-1) + (x-1) + (y-1)

acc_plus :: Int -> Int -> Int
acc_plus 0 y = y
acc_plus x y = acc_plus (x-1) (y+1)

acc_alt_mul :: Int -> Int -> Int
acc_alt_mul 0 y = 0
acc_alt_mul x 0 = 0
acc_alt_mul x y = x `acc_plus` ((y-1) `acc_plus` acc_alt_mul (x-1) (y-1))

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

prop_max_idem :: Int -> Property
prop_max_idem  x     = x `max` x === x
prop_max_assoc :: Int -> Int -> Int -> Property
prop_max_assoc x y z = x `max` (y `max` z) === (x `max` y) `max` z
prop_max_comm :: Int -> Int -> Property
prop_max_comm x y    = x `max` y === y `max` x

prop_boring_min_idem :: Int -> Property
prop_boring_min_idem  x     = x `min` x === x
prop_boring_min_assoc :: Int -> Int -> Int -> Property
prop_boring_min_assoc x y z = x `min` (y `min` z) === (x `min` y) `min` z
prop_boring_min_comm :: Int -> Int -> Property
prop_boring_min_comm x y    = x `min` y === y `min` x

prop_min_max_abs :: Int -> Int -> Property
prop_min_max_abs x y = x `min` (x `max` y) === x
prop_boring_max_min_abs :: Int -> Int -> Property
prop_boring_max_min_abs x y = x `max` (x `min` y) === x

prop_min_max_distrib :: Int -> Int -> Int -> Property
prop_min_max_distrib x y z = x `max` (y `min` z) === (x `max` y) `min` (x `max` z)
prop_boring_max_min_distrib :: Int -> Int -> Int -> Property
prop_boring_max_min_distrib x y z = x `min` (y `max` z) === (x `min` y) `max` (x `min` z)

prop_lt_trans :: Int -> Int -> Int -> Property
prop_lt_trans x y z = x < y ==> y < z ==> x < z
prop_lt_asymmetric :: Int -> Int -> Property
prop_lt_asymmetric x y = x < y ==> neg (y < x)
prop_lt_irreflexive :: Int -> Property
prop_lt_irreflexive x = neg (x < x)

prop_boring_gt_trans :: Int -> Int -> Int -> Property
prop_boring_gt_trans x y z = x > y ==> y > z ==> x > z
prop_boring_gt_asymmetric :: Int -> Int -> Property
prop_boring_gt_asymmetric x y = x > y ==> neg (y > x)
prop_boring_gt_irreflexive :: Int -> Property
prop_boring_gt_irreflexive x = neg (x > x)

prop_le_trans :: Int -> Int -> Int -> Property
prop_le_trans x y z = x <= y ==> y <= z ==> x <= z
prop_le_antisym :: Int -> Int -> Property
prop_le_antisym x y = x <= y ==> y <= x ==> x === y
prop_le_reflexive :: Int -> Property
prop_le_reflexive x = x <= x === True

prop_boring_ge_trans :: Int -> Int -> Int -> Property
prop_boring_ge_trans x y z = x >= y ==> y >= z ==> x >= z
prop_boring_ge_antisym :: Int -> Int -> Property
prop_boring_ge_antisym x y = x >= y ==> y >= x ==> x === y
prop_boring_ge_reflexive :: Int -> Property
prop_boring_ge_reflexive x = x >= x === True

prop_le_ge_eq :: Int -> Int -> Property
prop_le_ge_eq x y = x >= y ==> x <= y ==> x == y
prop_le_ne_lt :: Int -> Int -> Property
prop_le_ne_lt x y = x <= y ==> x /= y ==> x < y

prop_lt_ne :: Int -> Int -> Property
prop_lt_ne x y = y < x ==> x /= y

