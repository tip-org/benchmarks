-- Rotate expressed using a snoc instead of append
module SnocRotate where

import Prelude hiding (length, (++))

import Tip.DSL
import Test.QuickCheck hiding ((==>))
import Data.Typeable

import Nat (Nat(..))
import List (length)

rotate :: Nat -> [a] -> [a]
rotate Z     xs     = xs
rotate _     []     = []
rotate (S n) (x:xs) = rotate n (snoc x xs)

snoc :: a -> [a] -> [a]
snoc x []     = [x]
snoc x (y:ys) = y:snoc x ys

prop_snoc :: [a] -> Prop [a]
prop_snoc xs = rotate (length xs) xs =:= xs

(++) :: [a] -> [a] -> [a]
[]     ++ ys = ys
(x:xs) ++ ys = x : (xs ++ ys)

prop_snoc_self :: Nat -> [a] -> Prop [a]
prop_snoc_self n xs = rotate n (xs ++ xs) =:= rotate n xs ++ rotate n xs

