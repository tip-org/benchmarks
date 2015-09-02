module Tree where

import Tip.Prelude
import qualified Prelude as P

data Tree a = Node (Tree a) a (Tree a) | Nil

--------------------------------------------------------------------------------

flatten0 :: Tree a -> [a]
flatten0 Nil          = []
flatten0 (Node p x q) = flatten0 p ++ [x] ++ flatten0 q

flatten1 :: [Tree a] -> [a]
flatten1 []                  = []
flatten1 (Nil          : ps) = flatten1 ps
flatten1 (Node Nil x q : ps) = x : flatten1 (q : ps)
flatten1 (Node p x q   : ps) = flatten1 (p : Node Nil x q : ps)

flatten2 :: Tree a -> [a] -> [a]
flatten2 Nil          ys = ys
flatten2 (Node p x q) ys = flatten2 p (x : flatten2 q ys)

flatten3 :: Tree a -> [a]
flatten3 Nil                     = []
flatten3 (Node (Node p x q) y r) = flatten3 (Node p x (Node q y r))
flatten3 (Node Nil x q)          = x : flatten3 q

--------------------------------------------------------------------------------

prop_Flatten1 p =
  flatten1 [p] === flatten0 p

prop_Flatten1List ps =
  flatten1 ps === concatMap flatten0 ps

prop_Flatten2 p =
  flatten2 p [] === flatten0 p

prop_Flatten3 p =
  flatten3 p === flatten0 p

--------------------------------------------------------------------------------

-- swap :: Int -> Int -> Tree Int -> Tree Int
swap a b Nil          = Nil
swap a b (Node p x q) = Node (swap a b p) x' (swap a b q)
 where
  x' | x == a  = b
     | x == b  = a
     | otherwise = x

prop_SwapAB p a b =
  a `elem` flatten0 p ==>
--  b `elem` flatten0 p ==>
  a `elem` flatten0 (swap a b p) .&&.
  b `elem` flatten0 (swap a b p)

