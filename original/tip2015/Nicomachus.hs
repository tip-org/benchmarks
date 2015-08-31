-- Nicomachus' theorem
module Nicomachus where

import Tip.Prelude hiding (sum)
import qualified Prelude as P

sum :: Nat -> Nat
sum Z     = Z
sum (S n) = sum n + S n

cubes :: Nat -> Nat
cubes Z     = Z
cubes (S n) = cubes n + (S n * S n * S n)

prop_theorem :: Nat -> Equality Nat
prop_theorem n = cubes n === sum n * sum n

