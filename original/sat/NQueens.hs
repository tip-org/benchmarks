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

sat_4 xs = question (isMatrix n xs .&&. nq xs .&&. count (concat xs) == n)
  where n = n4

sat_5 xs = question (isMatrix n xs .&&. nq xs .&&. count (concat xs) == n)
  where n = n5

sat_6 xs = question (isMatrix n xs .&&. nq xs .&&. count (concat xs) == n)
  where n = n6

sat_7 xs = question (isMatrix n xs .&&. nq xs .&&. count (concat xs) == n)
  where n = n7

sat_8 xs = question (isMatrix n xs .&&. nq xs .&&. count (concat xs) == n)
  where n = n8

sat_9 xs = question (isMatrix n xs .&&. nq xs .&&. count (concat xs) == n)
  where n = n9

sat_12 xs = question (isMatrix n xs .&&. nq xs .&&. count (concat xs) == n)
  where n = n12

sat_14 xs = question (isMatrix n xs .&&. nq xs .&&. count (concat xs) == n)
  where n = n14

sat_15 xs = question (isMatrix n xs .&&. nq xs .&&. count (concat xs) == n)
  where n = n15

sat_16 xs = question (isMatrix n xs .&&. nq xs .&&. count (concat xs) == n)
  where n = n16

n3 :: Nat
n3 = S (S (S Z))

n4 :: Nat
n4 = S (S (S (S Z)))

n5 :: Nat
n5 = S (S (S (S (S Z))))

n6 :: Nat
n6 = S (S (S (S (S (S Z)))))

n7 :: Nat
n7 = S (S (S (S (S (S (S Z))))))

n8 :: Nat
n8 = S (S (S (S (S (S (S (S Z)))))))

n9 :: Nat
n9 = S (S (S (S (S (S (S (S (S Z))))))))

n12 :: Nat
n12 = S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))

n14 :: Nat
n14 = S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))

n15 :: Nat
n15 = S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))

n16 :: Nat
n16 = S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))

