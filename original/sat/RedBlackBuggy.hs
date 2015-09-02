-- Red-Black trees in a functional setting, by Okasaki.
-- (With invariants coded, and a fault injected to `balance`.)
--
-- tip currently creates a very big expression for `balance`
--
-- From the Reach article.
module RedBlackBuggy where

import Tip.Prelude hiding (insert)
import qualified Prelude

data Colour = R | B

data Tree a = E | T Colour (Tree a) a (Tree a)

-- Methods

member x E = False
member x (T _ a y b)
  | x < y = member x a
  | x > y = member x b
  | otherwise = True

makeBlack E           = E
makeBlack (T _ a y b) = T B a y b

insert x s = makeBlack (ins x s)

ins x E = T R E x E
ins x (T col a y b)
  | x < y = balance col (ins x a) y b
  | x > y = balance col a y (ins x b)
  | otherwise = T col a y b

-- Mistake on 4th line, 3rd line is correct
balance B (T R (T R a x b) y c) z d = T R (T B a x b) y (T B c z d)
balance B (T R a x (T R b y c)) z d = T R (T B a x b) y (T B c z d)
--balance B a x (T R (T R b y c) z d) = T R (T B a x b) y (T B c z d)
balance B a x (T R (T R c y b) z d) = T R (T B a x b) y (T B c z d)
balance B a x (T R b y (T R c z d)) = T R (T B a x b) y (T B c z d)
balance col a x b = T col a x b

-- Helpers

isRed R = True
isRed B = False

blackRoot E = True
blackRoot (T col a x b) = not (isRed col)

-- INVARIANT 1. No red node has a red parent.

red E = True
red (T col a x b) =
  (if isRed col then blackRoot a && blackRoot b else True) && red a && red b

-- INVARIANT 2. Every path from the root to an empty node contains the
-- same number of black nodes.

black t = fst (black' t)

black' E = (True, S Z)
black' (T col a x b) = (b0 && b1 && n == m, n + if isRed col then Z else S Z)
  where (b0, n) = black' a
        (b1, m) = black' b

-- INVARIANT 3. Trees are ordered.

allLe x E = True
allLe x (T _ t0 a t1) = a <= x && allLe x t0 && allLe x t1

allGe x E = True
allGe x (T _ t0 a t1) = a >= x && allGe x t0 && allGe x t1

ord E = True
ord (T _ t0 a t1) = allLe a t0 && allGe a t1 && ord t0 && ord t1

-- Properties

redBlack t = red t && black t && ord t

sat_insert x t = redBlack t ==> redBlack (insert x t)

