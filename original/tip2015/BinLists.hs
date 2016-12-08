-- Property about natural numbers with binary presentation
module BinLists where

import Tip

data Bin = One | ZeroAnd Bin | OneAnd Bin

toNat :: Bin -> Int
toNat One = 1
toNat (ZeroAnd xs) = toNat xs + toNat xs
toNat (OneAnd xs) = 1 + toNat xs + toNat xs

s :: Bin -> Bin
s One = ZeroAnd One
s (ZeroAnd xs) = OneAnd xs
s (OneAnd xs) = ZeroAnd (s xs)

plus :: Bin -> Bin -> Bin
plus One xs = s xs
plus xs@ZeroAnd{} One = s xs
plus xs@OneAnd{} One = s xs
plus (ZeroAnd xs) (ZeroAnd ys) = ZeroAnd (plus xs ys)
plus (ZeroAnd xs) (OneAnd ys) = OneAnd (plus xs ys)
plus (OneAnd xs) (ZeroAnd ys) = OneAnd (plus xs ys)
plus (OneAnd xs) (OneAnd ys) = ZeroAnd (s (plus xs ys))

times :: Bin -> Bin -> Bin
times One xs = xs
times (ZeroAnd xs) ys = ZeroAnd (times xs ys)
times (OneAnd xs) ys = plus (ZeroAnd (times xs ys)) ys

prop_s :: Bin -> Equality Int
prop_s n = toNat (s n) === 1 + toNat n

prop_plus :: Bin -> Bin -> Equality Int
prop_plus x y = toNat (x `plus` y) === toNat x + toNat y

prop_plus_comm :: Bin -> Bin -> Equality Bin
prop_plus_comm x y = x `plus` y === y `plus` x

prop_plus_assoc :: Bin -> Bin -> Bin -> Equality Bin
prop_plus_assoc x y z = x `plus` (y `plus` z) === (x `plus` y) `plus` z

prop_times :: Bin -> Bin -> Equality Int
prop_times x y = toNat (x `times` y) === toNat x * toNat y

prop_times_comm :: Bin -> Bin -> Equality Bin
prop_times_comm x y = x `times` y === y `times` x

prop_times_assoc :: Bin -> Bin -> Bin -> Equality Bin
prop_times_assoc x y z = x `times` (y `times` z) === (x `times` y) `times` z

prop_distrib :: Bin -> Bin -> Bin -> Equality Bin
prop_distrib x y z = x `times` (y `plus` z) === (x `times` y) `plus` (x `times` z)

