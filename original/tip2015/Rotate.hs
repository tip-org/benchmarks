{-# LANGUAGE DeriveDataTypeable #-}
module Rotate where

import Prelude hiding (reverse,(++),(+),(*),(-),(<),(<=),length,drop,take,mod)

import Tip.DSL
import Test.QuickCheck hiding ((==>))
import Data.Typeable

data List a = Cons a (List a) | Nil
  deriving (Eq,Typeable,Ord)

data Nat = S Nat | Z
  deriving (Eq,Show,Typeable,Ord)

(+) :: Nat -> Nat -> Nat
S n + m = S (n + m)
Z   + m = m

(*) :: Nat -> Nat -> Nat
S n * m = m + (n * m)
_   * m = Z

(<=) :: Nat -> Nat -> Bool
Z   <= _   = True
_   <= Z   = False
S x <= S y = x <= y

(<) :: Nat -> Nat -> Bool
_   < Z   = False
Z   < _   = True
S x < S y = x < y

(-) :: Nat -> Nat -> Nat
Z   - _   = Z
x   - Z   = x
S x - S y = x - y

mod :: Nat -> Nat -> Nat
n `mod` Z = Z
n `mod` m
    | n < m     = n
    | otherwise = (n - m) `mod` m

length :: List a -> Nat
length Nil         = Z
length (Cons _ xs) = S (length xs)

(++) :: List a  -> List a -> List a
Cons x xs ++ ys = Cons x (xs ++ ys)
Nil       ++ ys = ys

rotate :: Nat -> List a -> List a
rotate Z     xs          = xs
rotate _     Nil         = Nil
rotate (S n) (Cons x xs) = rotate n (xs ++ Cons x Nil)

-- A happy little property about rotate
prop_self :: Nat -> List a -> Prop (List a)
prop_self n xs = rotate n (xs ++ xs) =:= rotate n xs ++ rotate n xs

