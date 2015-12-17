-- From the reach article
module TreeDel where

import qualified Prelude
import Tip.Prelude

data Tree a = Empty
            | Node a (Tree a) (Tree a)

ins v Empty = Node v Empty Empty
ins v (Node w t0 t1)
  | v < w     = Node w (ins v t0) t1
  | otherwise = Node w t0 (ins v t1)

del a Empty   = Empty
del a (Node b t0 t1)
  | a < b     = Node b (del a t0) t1
  | a > b     = Node b t0 (del a t1)
  | otherwise = ext t0 t1

ext Empty t = t
ext (Node a t0 t1) t = Node a t0 (ext t1 t)

allLe x Empty = True
allLe x (Node a t0 t1) = a <= x && allLe x t0 && allLe x t1

allGe x Empty = True
allGe x (Node a t0 t1) = a >= x && allGe x t0 && allGe x t1

ordWrong Empty = True
ordWrong (Node a t0 t1) = allLe a t0 && allGe a t1 -- && ord t0 && ord t1

ord Empty = True
ord (Node a t0 t1) = allLe a t0 && allGe a t1 && ord t0 && ord t1

flatten (Node a l r) = flatten l ++ [a] ++ flatten r
flatten Empty        = []

prop_ord_del a t = ord t ==> ord (del a t)
prop_del_comm a b t = ord t ==> flatten (del a (del b t)) === flatten (del b (del a t))

-- ordWrong does not recurse into its subtrees
sat_ord_del a t = ordWrong t ==> ordWrong (del a t)
sat_del_comm a b t = ordWrong t ==> flatten (del a (del b t)) === flatten (del b (del a t))

