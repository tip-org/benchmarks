module Fermat where

import Prelude (Bool(..))
import Tip
import Nat

prop_last n x y z = S x ^ S (S (S n)) + S y ^ S (S (S n)) =/= S z ^ S (S (S n))
