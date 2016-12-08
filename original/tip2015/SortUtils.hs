module SortUtils where

import Data.List

isPermutation :: Ord a => [a] -> [a] -> Bool
[]     `isPermutation` ys = null ys
(x:xs) `isPermutation` ys = x `elem` ys && xs `isPermutation` delete x ys

ordered []       = True
ordered [x]      = True
ordered (x:y:xs) = x <= y && ordered (y:xs)

uniqsorted []       = True
uniqsorted [x]      = True
uniqsorted (x:y:xs) = x < y && uniqsorted (y:xs)

count :: Ord a => a -> [a] -> Int
count x [] = 0
count x (y:ys)
  | x == y = 1 + count x ys
  | otherwise = count x ys
