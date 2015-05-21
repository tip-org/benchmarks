-- Property about rotate and mod
{-# LANGUAGE DeriveDataTypeable #-}
module ModRotate where

import Prelude hiding (reverse,(++),(+),(*),(-),(<),(<=),length,drop,take,mod)

import Tip
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

take :: Nat -> List a -> List a
take Z     xs          = Nil
take _     Nil         = Nil
take (S n) (Cons x xs) = Cons x (take n xs)

drop :: Nat -> List a -> List a
drop Z     xs          = xs
drop _     Nil         = Nil
drop (S n) (Cons x xs) = drop n xs

prop_mod :: Nat -> List a -> Equality (List a)
prop_mod n xs = rotate n xs === drop (n `mod` length xs) xs ++ take (n `mod` length xs) xs

instance Enum Nat where
  toEnum 0 = Z
  toEnum n = S (toEnum (pred n))
  fromEnum Z = 0
  fromEnum (S n) = succ (fromEnum n)

instance Arbitrary Nat where
  arbitrary = sized arbSized

arbSized s = do
  x <- choose (0,round (sqrt (toEnum s)))
  return (toEnum x)

instance Arbitrary a => Arbitrary (List a) where
    arbitrary = toList `fmap` arbitrary

fromList :: List a -> [a]
fromList (Cons x xs) = x : fromList xs
fromList Nil         = []

toList :: [a] -> List a
toList (x:xs) = Cons x (toList xs)
toList []     = Nil
