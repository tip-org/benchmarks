{-# LANGUAGE DeriveDataTypeable #-}
module List where

import Prelude hiding (reverse,(++),length,map,filter,(.),(+),const)
import qualified Prelude
import Tip
import Data.Typeable
import Nat

length :: [a] -> Nat
length []     = Z
length (_:xs) = S (length xs)

(++) :: [a] -> [a] -> [a]
(x:xs) ++ ys = x:(xs ++ ys)
[]     ++ ys = ys

map :: (a -> b) -> [a] -> [b]
map f (x:xs) = f x:map f xs
map f []     = []

filter :: (a -> Bool) -> [a] -> [a]
filter p (x:xs) | p x       = x:filter p xs
                | otherwise = filter p xs
filter p [] = []

f . g = \ x -> f (g x)

