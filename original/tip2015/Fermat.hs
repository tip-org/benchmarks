module Fermat where

import Tip.Prelude
import qualified Prelude as P

prop_last n x y z = S x ^ S (S (S n)) + S y ^ S (S (S n)) =/= S z ^ S (S (S n))
