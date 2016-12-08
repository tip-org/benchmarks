module Rotate where

rotate :: Int -> [a] -> [a]
rotate 0 xs     = xs
rotate _ []     = []
rotate n (x:xs) = rotate (n-1) (xs ++ [x])

