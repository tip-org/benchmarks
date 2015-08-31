-- | Another simple property about rotate
module SelfRotate where

import Tip.Prelude
import Rotate
import Prelude ()

prop_self :: Nat -> [a] -> Equality [a]
prop_self n xs = rotate n (xs ++ xs) === rotate n xs ++ rotate n xs
