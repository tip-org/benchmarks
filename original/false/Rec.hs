module Rec where

import Tip

f :: [Bool] -> Bool
f [] = True
f xs = g (f (h xs))

h :: [Bool] -> [Bool]
h [] = []
h (x:xs) = xs

g :: Bool -> Bool
g False = True
g True = False

prop xs = f xs === False

