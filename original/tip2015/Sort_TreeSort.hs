{-# LANGUAGE ScopedTypeVariables, TemplateHaskell, DeriveDataTypeable #-}
module Sort_TreeSort where

import Test.QuickCheck
import Test.QuickCheck.Poly
import Test.QuickCheck.All

import Nat
import Prelude hiding ((++), (==), (<=), minimum, elem, (+))
import HipSpec

(==), (<=) :: Nat -> Nat -> Bool
Z == Z = True
S x == S y = x == y
_ == _ = False
Z <= _ = True
_ <= Z = False
S x <= S y = x <= y

--------------------------------------------------------------------------------

tsort :: [Nat] -> [Nat]
tsort t = flatten (toTree t) []

data Tree a = Node (Tree a) a (Tree a) | Nil
 deriving ( Eq, Ord, Show, Typeable )

toTree :: [Nat] -> Tree Nat
toTree []     = Nil
toTree (x:xs) = add x (toTree xs)

add :: Nat -> Tree Nat -> Tree Nat
add x Nil                      = Node Nil x Nil
add x (Node p y q) | x <= y    = Node (add x p) y q
                   | otherwise = Node p y (add x q)

flatten :: Tree a -> [a] -> [a]
flatten Nil          ys = ys
flatten (Node p x q) ys = flatten p (x : flatten q ys)

--------------------------------------------------------------------------------

ordered :: [Nat] -> Bool
ordered []       = True
ordered [x]      = True
ordered (x:y:xs) = x <= y && ordered (y:xs)

count :: Nat -> [Nat] -> Nat
count x []                 = Z
count x (y:xs) | x == y    = S (count x xs)
               | otherwise = count x xs

isPermutation :: [Nat] -> [Nat] -> Bool
[]     `isPermutation` ys = null ys
(x:xs) `isPermutation` ys = x `elem` ys && xs `isPermutation` delete x ys

elem :: Nat -> [Nat] -> Bool
elem x [] = False
elem x (y:ys) = x == y || elem x ys

delete :: Nat -> [Nat] -> [Nat]
delete _ [] = []
delete x (y:ys)
  | x == y = ys
  | otherwise = y:delete x ys

--------------------------------------------------------------------------------

prop_SortSorts (xs :: [Nat]) =
  ordered (tsort xs) =:= True

prop_SortPermutes x (xs :: [Nat]) =
  count x (tsort xs) =:= count x xs

prop_SortPermutes' (xs :: [Nat]) =
  tsort xs `isPermutation` xs =:= True

--------------------------------------------------------------------------------

return []
testAll = $(quickCheckAll)

--------------------------------------------------------------------------------

