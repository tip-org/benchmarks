-- Nicomachus' theorem
module Nicomachus where

import Prelude hiding ((+),(*),sum)
import Nat hiding (sig)
import Tip

sum :: Nat -> Nat
sum Z     = Z
sum (S n) = sum n + S n

cubes :: Nat -> Nat
cubes Z     = Z
cubes (S n) = cubes n + (S n * S n * S n)

prop_theorem :: Nat -> Equality Nat
prop_theorem n = cubes n === sum n * sum n

