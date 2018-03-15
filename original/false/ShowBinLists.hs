module ShowBinLists where

import Tip

data B = I | O

shw 0             = []
shw x | even x    = O : shw (half x)
      | otherwise = I : shw (half x)

rd (I : xs) = succ (double (rd xs))
rd (O : xs) = double (rd xs)
rd []       = 0

half, double :: Int -> Int
half x = x `div` 2
double x = x + x

(#) :: Int -> Int -> Int
x # y = rd (shw x ++ shw y)

prop_assoc x y z = x#(y#z) === (x#y)#z
sat_comm   x y   = x#y === y#x


