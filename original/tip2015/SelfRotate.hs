-- | Another simple property about rotate
module SelfRotate where

import Tip
import Rotate

prop_self :: Int -> [a] -> Equality [a]
prop_self n xs = rotate n (xs ++ xs) === rotate n xs ++ rotate n xs
