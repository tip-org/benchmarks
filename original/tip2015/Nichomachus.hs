module Nichomachus where

import Prelude hiding ((+),(*),sum)
import Nat hiding (sig)
import Tip.DSL

sum :: Nat -> Nat
sum Z     = Z
sum (S n) = sum n + S n

cubes :: Nat -> Nat
cubes Z     = Z
cubes (S n) = cubes n + (S n * S n * S n)

prop_theorem :: Nat -> Prop Nat
prop_theorem n = cubes n =:= sum n * sum n

