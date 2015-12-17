module Factoring where

import Tip.Prelude
import qualified Prelude

data Bin = One | ZeroAnd Bin | OneAnd Bin

toNat :: Bin -> Nat
toNat One = S Z
toNat (ZeroAnd xs) = toNat xs + toNat xs
toNat (OneAnd xs) = S (toNat xs + toNat xs)

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

pred (S x) = x
pred Z     = Z

six    = s (s (s (s (s One))))
twenty = s (s (s (s (s (s (s (s (s (s (s (s (s (s (s (s (s (s (s One))))))))))))))))))
twelve = six `plus` six
eight  = s (s (s (s (s (s (s One))))))
nine   = s (s (s (s (s (s (s (s One)))))))
four   = s (s (s One))
ten    = s nine

factors_35 x y = question (s (s x) `times` s (s y) === s (s (s (twenty `times` twenty `times` twenty))))

-- simple x = question (x * x =/= x)
