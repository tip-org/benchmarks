module SortUtils where

import Data.List

isPermutation :: Eq a => [a] -> [a] -> Bool
[]     `isPermutation` ys = null ys
(x:xs) `isPermutation` ys = x `elem` ys && xs `isPermutation` delete x ys

ordered :: [Int] -> Bool
ordered []       = True
ordered [x]      = True
ordered (x:y:xs) = x <= y && ordered (y:xs)

uniqsorted :: [Int] -> Bool
uniqsorted []       = True
uniqsorted [x]      = True
uniqsorted (x:y:xs) = x < y && uniqsorted (y:xs)

count :: Eq a => a -> [a] -> Int
count x [] = 0
count x (y:ys)
  | x == y = 1 + count x ys
  | otherwise = count x ys

deleteAll :: Eq a => a -> [a] -> [a]
deleteAll _ [] = []
deleteAll x (y:ys)
  | x == y = deleteAll x ys
  | otherwise = y:deleteAll x ys
