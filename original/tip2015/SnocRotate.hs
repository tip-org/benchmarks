-- Rotate expressed using a snoc instead of append
module SnocRotate where

import Tip

rotate :: Int -> [a] -> [a]
rotate 0 xs     = xs
rotate _ []     = []
rotate n (x:xs) = rotate (n-1) (snoc x xs)

snoc :: a -> [a] -> [a]
snoc x []     = [x]
snoc x (y:ys) = y:snoc x ys

prop_snoc :: [a] -> Equality [a]
prop_snoc xs = rotate (length xs) xs === xs

prop_snoc_self :: Int -> [a] -> Equality [a]
prop_snoc_self n xs = rotate n (xs ++ xs) === rotate n xs ++ rotate n xs

