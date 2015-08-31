-- Tree sort
{-# LANGUAGE ScopedTypeVariables #-}
module Sort_TreeSort where

import Tip.Prelude
import qualified Prelude as P

--------------------------------------------------------------------------------

tsort :: [Nat] -> [Nat]
tsort t = flatten (toTree t) []

data Tree a = Node (Tree a) a (Tree a) | Nil

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

-- The sort function returns a sorted list.
prop_SortSorts (xs :: [Nat]) =
  ordered (tsort xs) === True

-- The sort function permutes the input list.
prop_SortPermutes x (xs :: [Nat]) =
  count x (tsort xs) === count x xs

-- The sort function permutes the input list, version 2.
prop_SortPermutes' (xs :: [Nat]) =
  tsort xs `isPermutation` xs === True

-- Inserting an element adds one to the count of that element.
prop_AddSame x t = count x (flatten (add x t) []) === S (count x (flatten t []))

-- Inserting an element preserves the counts of different elements.
prop_AddDifferent x y t = x == y === False ==> count y (flatten (add x t) []) === count y (flatten t [])

