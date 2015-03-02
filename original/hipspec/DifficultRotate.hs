{-# LANGUAGE DeriveDataTypeable #-}
module Challenges.DifficultRotate where

import Prelude hiding (reverse,(++),(+),(*),(-),(<),(<=),length,drop,take,mod)

import HipSpec

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
{-n `mod` Z = Z
n `mod` m
    | n < m     = n
    | otherwise = (n - m) `mod` m-}
n `mod` m = mod2 n Z m

-- mod2 n k m = (n-k) mod m
mod2 :: Nat -> Nat -> Nat -> Nat
mod2 _ _ Z = Z
mod2 Z Z _ = Z           -- 0 % m = 0
mod2 Z (S n) m = m - S n -- (-S n) % m = m - S n
mod2 (S n) Z (S m) = mod2 n m (S m) -- S n % S m = (S n - S m) % S m = (n - m) % S m
mod2 (S n) (S k) m = mod2 n k m

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

-- From productive use of failure
prop_rot_self :: Nat -> List a -> Prop (List a)
prop_rot_self n xs = rotate n (xs ++ xs) =:= rotate n xs ++ rotate n xs

prop_rot_mod :: Nat -> List a -> Prop (List a)
prop_rot_mod n xs = rotate n xs =:= drop (n `mod` length xs) xs ++ take (n `mod` length xs) xs
{-
sig =
    [ vars ["x", "y", "z"] (undefined :: A)
    , vars ["n", "m", "o"] (undefined :: Nat)
    , vars ["xs", "ys", "zs"] (undefined :: List)
    , fun0 "True"   True
    , fun0 "False"  False
    , fun0 "Z"      Z
    , fun1 "S"      S
    , fun2 "+"      (+)
    , fun2 "*"      (*)
    , fun2 "`mod`"      (`mod`)
    , fun2 "-"      (-)
    , fun2 "<"      (<)
    , fun0 "Nil"    Nil
    , fun2 "Cons"   Cons
    , fun1 "length" length
    , fun2 "++"     (++)
    , fun2 "rotate" rotate
    , fun2 "take"   take
    , fun2 "drop"   drop
    ]
-}
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
