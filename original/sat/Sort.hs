{-# LANGUAGE ScopedTypeVariables #-}
module Sort where

import Tip.Prelude hiding (isort,insert)
import qualified Prelude as P

third :: Nat -> Nat
third Z = Z
third (S Z) = Z
third (S (S Z)) = Z
third (S (S (S n))) = S (third n)

twoThirds :: Nat -> Nat
twoThirds Z = Z
twoThirds (S Z) = S Z
twoThirds (S (S Z)) = S Z
twoThirds (S (S (S n))) = S (S (twoThirds n))


--------------------------------------------------------------------------------

-- bubsort :: Ord a => [a] -> [a]
bubsort xs | b         = bubsort ys
           | otherwise = xs
 where
  (b,ys) = bubble xs

-- bubble :: Ord a => [a] -> (Bool,[a])
bubble (x:y:xs) = (not c||b, x':ys)
 where
  c      = x <= y
  x'     = if c then x else y
  y'     = if c then y else x
  (b,ys) = bubble (y':xs)
bubble xs       = (False,xs)

--------------------------------------------------------------------------------

-- Bubble sort

--------------------------------------------------------------------------------

-- hsort :: Ord a => [a] -> [a]
hsort = toList . toHeap

data Heap a = Node (Heap a) a (Heap a) | Nil

-- hmerge :: Ord a => Heap a -> Heap a -> Heap a
Nil        `hmerge` q          = q
p          `hmerge` Nil        = p
Node p x q `hmerge` Node r y s
  | x <= y                    = Node (q `hmerge` Node r y s) x p
  | otherwise                 = Node (Node p x q `hmerge` s) y r

-- toHeap :: Ord a => [a] -> Heap a
toHeap xs = hmerging [ Node Nil x Nil | x <- xs ]

-- hmerging :: Ord a => [Heap a] -> Heap a
hmerging []  = Nil
hmerging [p] = p
hmerging ps  = hmerging (hpairwise ps)

-- hpairwise :: Ord a => [Heap a] -> [Heap a]
hpairwise (p:q:qs) = (p `hmerge` q) : hpairwise qs
hpairwise ps       = ps

-- toList :: Ord a => Heap a -> [a]
toList Nil          = []
toList (Node p x q) = x : toList (p `hmerge` q)

--------------------------------------------------------------------------------

-- Heap sort (using skew heaps)

--------------------------------------------------------------------------------

sort :: [Nat] -> [Nat]
sort = isort

-- isort :: Ord a => [a] -> [a]
isort []     = []
isort (x:xs) = insert x (isort xs)

-- insert :: Ord a => a -> [a] -> [a]
insert x []                 = [x]
insert x (y:xs) | x <= y    = x : y : xs
                | otherwise = y : insert x xs

--------------------------------------------------------------------------------

-- Insertion sort

--------------------------------------------------------------------------------

-- msortbu2 :: Ord a => [a] -> [a]
msortbu2 = mergingbu2 . risers

{-
risers :: Ord a => [a] -> [[a]]
risers []     = []
risers [x]    = [[x]]
risers (x:xs) = case risers xs of
                  (y:ys):yss | x <= y -> (x:y:ys):yss
                  yss                 -> [x]:yss
-}

-- risers :: Ord a => [a] -> [[a]]
risers []       = []
risers [x]      = [[x]]
risers (x:y:xs)
  | x <= y      = case risers (y:xs) of
                    -- TODO remove default case
                    ys:yss -> (x:ys):yss
                    _ -> []
  | otherwise   = [x] : risers (y:xs)

-- mergingbu2 :: Ord a => [[a]] -> [a]
mergingbu2 []   = []
mergingbu2 [xs] = xs
mergingbu2 xss  = mergingbu2 (pairwise xss)

pairwise (xs:ys:xss) = xs `lmerge` ys : pairwise xss
pairwise xss         = xss

-- lmerge :: Ord a => [a] -> [a] -> [a]
[]     `lmerge` ys = ys
xs     `lmerge` [] = xs
(x:xs) `lmerge` (y:ys)
  | x <= y        = x : xs `lmerge` (y:ys)
  | otherwise     = y : (x:xs) `lmerge` ys

--------------------------------------------------------------------------------

-- Bottom-up merge sort, using a total risers function

--------------------------------------------------------------------------------

singletons []     = []
singletons (x:xs) = [x]:singletons xs

-- msortbu :: Ord a => [a] -> [a]
msortbu = mergingbu . singletons

-- mergingbu :: Ord a => [[a]] -> [a]
mergingbu []   = []
mergingbu [xs] = xs
mergingbu xss  = mergingbu (pairwise xss)

--------------------------------------------------------------------------------

-- Bottom-up merge sort

-- msorttd :: Ord a => [a] -> [a]
msorttd []  = []
msorttd [x] = [x]
msorttd xs  = msorttd (take k xs) `lmerge` msorttd (drop k xs)
 where
  k = half (length xs)

-- Top-down merge sort

--------------------------------------------------------------------------------

eomsorttd []  = []
eomsorttd [x] = [x]
eomsorttd xs  = eomsorttd (evens xs) `lmerge` eomsorttd (odds xs)

-- Top-down merge sort, using the even and odd elements of the list

--------------------------------------------------------------------------------

-- bsort :: Ord a => [a] -> [a]
bsort []  = []
bsort [x] = [x]
bsort xs  = bmerge (bsort (evens xs)) (bsort (odds xs))

{-# NOINLINE evens #-}
evens :: [a] -> [a]
evens (x:xs) = x : odds xs
evens []     = []

{-# NOINLINE odds #-}
odds :: [a] -> [a]
odds (x:xs) = evens xs
odds []     = []

-- bmerge :: Ord a => [a] -> [a] -> [a]
bmerge []  bs  = []
bmerge as  []  = as
bmerge [a] [b] = sort2 a b
bmerge as  bs  = stitch cs0 cs1
 where
  as0 = evens as
  as1 = odds as
  bs0 = evens bs
  bs1 = odds bs
  cs0 = bmerge as0 bs0
  cs1 = bmerge as1 bs1

-- stitch :: Ord a => [a] -> [a] -> [a]
stitch []     ys = ys
stitch (x:xs) ys = x : pairs xs ys

-- pairs :: Ord a => [a] -> [a] -> [a]
pairs []     ys     = ys
pairs xs     []     = xs
pairs (x:xs) (y:ys) = sort2 x y ++ pairs xs ys

-- sort2 :: Ord a => a -> a -> [a]
sort2 x y | x <= y    = [x,y]
          | otherwise = [y,x]

--------------------------------------------------------------------------------

-- Bitonic sort

--------------------------------------------------------------------------------

-- qsort :: Ord a => [a] -> [a]
qsort []     = []
qsort (x:xs) = qsort (filter_le x xs) ++ [x] ++ qsort (filter_gt x xs)

filter_le x (y:ys)
  | y <= x    = y:filter_le x ys
  | otherwise = filter_le x ys
filter_le _ [] = []

filter_gt x (y:ys)
  | y > x     = y:filter_gt x ys
  | otherwise = filter_gt x ys
filter_gt _ [] = []

-- QuickSort

--------------------------------------------------------------------------------

-- ssort :: Ord a => [a] -> [a]
ssort [] = []
ssort xs@(y:ys) = m : ssort (delete m xs)
 where
  m = minimum y ys
  minimum x [] = x
  -- TODO add another version with normal minimum
  minimum x (y:ys)
    | y <= x = minimum y ys
    | otherwise = minimum x ys

--------------------------------------------------------------------------------

-- Selection sort, using a total minimum function

--------------------------------------------------------------------------------

-- tsort :: Ord a => [a] -> [a]
tsort = ($[]) . flatten . toTree

data Tree a = TNode (Tree a) a (Tree a) | TNil

-- toTree :: Ord a => [a] -> Tree a
toTree []     = TNil
toTree (x:xs) = add x (toTree xs)

-- add :: Ord a => a -> Tree a -> Tree a
add x TNil                      = TNode TNil x TNil
add x (TNode p y q) | x <= y    = TNode (add x p) y q
                    | otherwise = TNode p y (add x q)

-- flatten :: Tree a -> [a] -> [a]
flatten TNil          ys = ys
flatten (TNode p x q) ys = flatten p (x : flatten q ys)

--------------------------------------------------------------------------------

-- Tree sort

----------------------------------------------------------------------------------

-- Stooge sort

--------------------------------------------------------------------------------

{-# NOINLINE stoogesort #-}
stoogesort :: [Nat] -> [Nat]
stoogesort [] = []
stoogesort [x] = [x]
stoogesort [x, y] = sort2 x y
stoogesort xs = stooge1sort2 (stooge1sort1 (stooge1sort2 xs))

{-# NOINLINE stooge1sort1 #-}
stooge1sort1 :: [Nat] -> [Nat]
stooge1sort1 xs = ys ++ stoogesort zs
  where
    (ys, zs) = splitAt (third (length xs)) xs

{-# NOINLINE stooge1sort2 #-}
stooge1sort2 :: [Nat] -> [Nat]
stooge1sort2 xs = stoogesort zs ++ reverse ys
  where
    (ys, zs) = splitAt (third (length xs)) (reverse xs)

--------------------------------------------------------------------------------

-- Stooge sort defined using reverse and thirds on natural numbers

--------------------------------------------------------------------------------

{-# NOINLINE stoogesort2 #-}
stoogesort2, stooge2sort1, stooge2sort2 :: [Nat] -> [Nat]
stoogesort2 [] = []
stoogesort2 [x] = [x]
stoogesort2 [x, y] = sort2 x y
stoogesort2 xs = stooge2sort2 (stooge2sort1 (stooge2sort2 xs))

{-# NOINLINE stooge2sort1 #-}
stooge2sort1 xs = ys ++ stoogesort2 zs
  where
    (ys, zs) = splitAt (third (length xs)) xs

{-# NOINLINE stooge2sort2 #-}
stooge2sort2 xs = stoogesort2 ys ++ zs
  where
    (ys, zs) = splitAt (twoThirds (length xs)) xs

----------------------------------------------------------------------------------

-- Stooge sort, using thirds on natural numbers

--------------------------------------------------------------------------------


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

#define INJ_len_both(num) sat_inj_len_both_##num xs ys = question (SORT xs === SORT ys .&&. xs =/= ys                    .&&. length xs === num .&&. length ys === num)
#define NUB_len_both(num) sat_nub_len_both_##num xs ys = question (SORT xs === SORT ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === num .&&. length ys === num)
#define UNQ_len_both(num) sat_unq_len_both_##num xs ys = question (SORT xs === SORT ys .&&. xs =/= ys .&&. unique xs     .&&. length xs === num .&&. length ys === num)

#define INJ(num) sat_inj_##num xs ys = question (SORT xs === SORT ys .&&. xs =/= ys                    .&&. length xs === num)
#define NUB(num) sat_nub_##num xs ys = question (SORT xs === SORT ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === num)
#define UNQ(num) sat_unq_##num xs ys = question (SORT xs === SORT ys .&&. xs =/= ys .&&. unique xs     .&&. length xs === num)

INJ(n02)
INJ(n03)
INJ(n04)
INJ(n05)
INJ(n06)
INJ(n07)
INJ(n08)
INJ(n09)
INJ(n10)
INJ(n11)
INJ(n12)
INJ(n13)
INJ(n14)
INJ(n15)
INJ(n16)
INJ(n17)
INJ(n18)
INJ(n19)
INJ(n20)
INJ(n21)
INJ(n22)
INJ(n23)
INJ(n24)
INJ(n25)
INJ(n26)
INJ(n27)
INJ(n28)
INJ(n29)

NUB(n02)
NUB(n03)
NUB(n04)
NUB(n05)
NUB(n06)
NUB(n07)
NUB(n08)
NUB(n09)
NUB(n10)
NUB(n11)
NUB(n12)
NUB(n13)
NUB(n14)

UNQ(n02)
UNQ(n03)
UNQ(n04)
UNQ(n05)
UNQ(n06)
UNQ(n07)
UNQ(n08)
UNQ(n09)
UNQ(n10)
UNQ(n11)
UNQ(n12)
UNQ(n13)
UNQ(n14)

INJ_len_both(n02)
INJ_len_both(n03)
INJ_len_both(n04)
INJ_len_both(n05)
INJ_len_both(n06)
INJ_len_both(n07)
INJ_len_both(n08)
INJ_len_both(n09)
INJ_len_both(n10)
INJ_len_both(n11)
INJ_len_both(n12)
INJ_len_both(n13)
INJ_len_both(n14)
INJ_len_both(n15)
INJ_len_both(n16)
INJ_len_both(n17)
INJ_len_both(n18)
INJ_len_both(n19)
INJ_len_both(n20)
INJ_len_both(n21)
INJ_len_both(n22)
INJ_len_both(n23)
INJ_len_both(n24)
INJ_len_both(n25)
INJ_len_both(n26)
INJ_len_both(n27)
INJ_len_both(n28)
INJ_len_both(n29)

NUB_len_both(n02)
NUB_len_both(n03)
NUB_len_both(n04)
NUB_len_both(n05)
NUB_len_both(n06)
NUB_len_both(n07)
NUB_len_both(n08)
NUB_len_both(n09)
NUB_len_both(n10)
NUB_len_both(n11)
NUB_len_both(n12)
NUB_len_both(n13)
NUB_len_both(n14)

UNQ_len_both(n02)
UNQ_len_both(n03)
UNQ_len_both(n04)
UNQ_len_both(n05)
UNQ_len_both(n06)
UNQ_len_both(n07)
UNQ_len_both(n08)
UNQ_len_both(n09)
UNQ_len_both(n10)
UNQ_len_both(n11)
UNQ_len_both(n12)
UNQ_len_both(n13)
UNQ_len_both(n14)
