-- Rotate expressed using a snoc instead of append
module SnocRotate where

import Tip.Prelude
import qualified Prelude as P

rotate :: Nat -> [a] -> [a]
rotate Z     xs     = xs
rotate _     []     = []
rotate (S n) (x:xs) = rotate n (snoc x xs)

snoc :: a -> [a] -> [a]
snoc x []     = [x]
snoc x (y:ys) = y:snoc x ys

prop_snoc :: [a] -> Equality [a]
prop_snoc xs = rotate (length xs) xs === xs

prop_snoc_self :: Nat -> [a] -> Equality [a]
prop_snoc_self n xs = rotate n (xs ++ xs) === rotate n xs ++ rotate n xs

