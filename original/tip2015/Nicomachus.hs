-- Nicomachus' theorem
module Nicomachus where

import Tip
import Prelude hiding (sum)

sum :: Int -> Int
sum 0 = 0
sum n = sum (n-1) + n

cubes :: Int -> Int
cubes 0 = 0
cubes n = cubes (n-1) + (n*n*n)

prop_theorem :: Int -> Equality Int
prop_theorem n = cubes n === sum n * sum n

