module Fermat where

import Tip

prop_last :: Int -> Int -> Int -> Int -> Equality Int
prop_last n x y z =
  (1+x) ^ (3+n) + (1+y) ^ (3+n) =/= (1+z) ^ (3+n)
