-- Sequences with logarithmic-time lookup.
-- An example of non-regular datatypes and polymorphic recursion.

{-# LANGUAGE TypeOperators #-}
module Seq where

import Prelude hiding (lookup)
import Tip

data Seq a = Nil | Cons a (Seq (a, Maybe a))

fromList :: [a] -> Seq a
fromList [] = Nil
fromList (x:xs) = Cons x (fromList (pair xs))

pair :: [a] -> [(a, Maybe a)]
pair [] = []
pair [x] = [(x, Nothing)]
pair (x:y:xs) = (x, Just y):pair xs

(<$$>) :: (a -> b) -> Maybe a -> Maybe b
f <$$> Nothing = Nothing
f <$$> Just x = Just (f x)

(=<<<) :: (a -> Maybe b) -> Maybe a -> Maybe b
f =<<< Nothing = Nothing
f =<<< Just x = f x

index :: Int -> Seq a -> Maybe a
index _ Nil = Nothing
index 0 (Cons x xs) = Just x
index n (Cons x xs)
  | n `mod` 2 == 0 = snd =<<< index ((n-1) `div` 2) xs
  | otherwise = fst <$$> index ((n-1) `div` 2) xs

lookup :: Int -> [a] -> Maybe a
lookup _ [] = Nothing
lookup 0 (x:xs) = Just x
lookup n (x:xs) = lookup (n-1) xs

prop_index :: Int -> [a] -> Bool :=>: Equality (Maybe a)
prop_index n xs =
  n >= 0 ==> lookup n xs === index n (fromList xs)
