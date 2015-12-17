{-# LANGUAGE CPP #-}
#define n00 Z
#define n01 (S n00)
#define n02 (S n01)
#define n03 (S n02)
#define n04 (S n03)
#define n05 (S n04)
#define n06 (S n05)
#define n07 (S n06)
#define n08 (S n07)
#define n09 (S n08)
#define n10 (S n09)
#define n11 (S n10)
#define n12 (S n11)
#define n13 (S n12)
#define n14 (S n13)
#define n15 (S n14)
#define n16 (S n15)
#define n17 (S n16)
#define n18 (S n17)
#define n19 (S n18)
#define n20 (S n19)
#define n21 (S n20)
#define n22 (S n21)
#define n23 (S n22)
#define n24 (S n23)
#define n25 (S n24)
#define n26 (S n25)
#define n27 (S n26)
#define n28 (S n27)
#define n29 (S n28)
module NQueens where

import qualified Prelude
import Tip.Prelude hiding (reverse,count)

transpose               :: [[a]] -> [[a]]
transpose []             = []
transpose ([]   : xss)   = transpose xss
transpose ((x:xs) : xss) = (x : [h | (h:_) <- xss]) : transpose (xs : [ t | (_:t) <- xss])

reverse xs = go xs []
  where
  go [] acc     = acc
  go (y:ys) acc = go ys (y:acc)

bothdiags :: [[a]] -> [[a]]
bothdiags xss = diags xss ++ diags [ reverse xs | xs <- xss ]

diags :: [[a]] -> [[a]]
diags xss = lowerdiags xss ++ dropH (lowerdiags (transpose xss))

lowerdiags :: [[a]] -> [[a]]
lowerdiags xss@(_:r) = diag xss:lowerdiags r
lowerdiags _         = []

diag :: [[a]] -> [a]
diag ((x:_):xss) = x:diag (drop1 xss)
diag _           = []

dropH (_:xs) = xs
dropH []     = []

drop1 :: [[a]] -> [[a]]
drop1 xss = [ t | _:t <- xss ]

ok (True:xs)  = empty xs
ok (False:xs) = ok xs
ok []         = True     -- an empty row is also ok

empty (False:xs) = empty xs
empty (True:xs)  = False
empty []         = True

isMatrix :: Nat -> [[a]] -> Bool
isMatrix n xss = length xss == n && and [ length xs == n | xs <- xss ]

nq :: [[Bool]] -> Bool
nq xss = and [ ok xs | xs <- xss ]
      && and [ ok xs | xs <- transpose xss ]
      && and [ ok xs | xs <- bothdiags xss ]

count (True:xs)  = S (count xs)
count (False:xs) = count xs
count []         = Z

sat_4 xs = question (isMatrix n04 xs .&&. nq xs .&&. count (concat xs) == n04)
sat_5 xs = question (isMatrix n05 xs .&&. nq xs .&&. count (concat xs) == n05)
sat_6 xs = question (isMatrix n06 xs .&&. nq xs .&&. count (concat xs) == n06)
sat_7 xs = question (isMatrix n07 xs .&&. nq xs .&&. count (concat xs) == n07)
sat_8 xs = question (isMatrix n08 xs .&&. nq xs .&&. count (concat xs) == n08)
sat_9 xs = question (isMatrix n09 xs .&&. nq xs .&&. count (concat xs) == n09)

sat_10 xs = question (isMatrix n10 xs .&&. nq xs .&&. count (concat xs) == n10)
sat_11 xs = question (isMatrix n11 xs .&&. nq xs .&&. count (concat xs) == n11)
sat_12 xs = question (isMatrix n12 xs .&&. nq xs .&&. count (concat xs) == n12)
sat_13 xs = question (isMatrix n13 xs .&&. nq xs .&&. count (concat xs) == n13)
sat_14 xs = question (isMatrix n14 xs .&&. nq xs .&&. count (concat xs) == n14)
sat_15 xs = question (isMatrix n15 xs .&&. nq xs .&&. count (concat xs) == n15)
sat_16 xs = question (isMatrix n16 xs .&&. nq xs .&&. count (concat xs) == n16)

