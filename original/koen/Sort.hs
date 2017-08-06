{-# LANGUAGE ScopedTypeVariables #-}
module Sort where

import Tip
import Data.List hiding (sort, insert)
import SortUtils

third :: Int -> Int
third 0 = 0
third 1 = 0
third 2 = 0
third n = 1+third (n-3)

twoThirds :: Int -> Int
twoThirds 0 = 0
twoThirds 1 = 1
twoThirds 2 = 1
twoThirds n = 2+twoThirds (n-3)


--------------------------------------------------------------------------------

bubsort :: [Int] -> [Int]
bubsort xs | b         = bubsort ys
           | otherwise = xs
 where
  (b,ys) = bubble xs

bubble :: [Int] -> (Bool,[Int])
bubble (x:y:xs) = (not c||b, x':ys)
 where
  c      = x <= y
  x'     = if c then x else y
  y'     = if c then y else x
  (b,ys) = bubble (y':xs)
bubble xs       = (False,xs)

--------------------------------------------------------------------------------

-- Bubble sort
prop_BubSortSorts xs = ordered (bubsort xs) === True
prop_BubSortCount x xs = count x (bubsort xs) === count x xs
prop_BubSortPermutes xs = bubsort xs `isPermutation` xs === True
prop_BubSortIsSort xs = bubsort xs === sort xs

--------------------------------------------------------------------------------

hsort :: [Int] -> [Int]
hsort = toList . toHeap

data Heap = Node Heap Int Heap | Nil

hmerge :: Heap -> Heap -> Heap
Nil        `hmerge` q          = q
p          `hmerge` Nil        = p
Node p x q `hmerge` Node r y s
  | x <= y                    = Node (q `hmerge` Node r y s) x p
  | otherwise                 = Node (Node p x q `hmerge` s) y r

toHeap :: [Int] -> Heap
toHeap xs = hmerging [ Node Nil x Nil | x <- xs ]

hmerging :: [Heap] -> Heap
hmerging []  = Nil
hmerging [p] = p
hmerging ps  = hmerging (hpairwise ps)

hpairwise :: [Heap] -> [Heap]
hpairwise (p:q:qs) = (p `hmerge` q) : hpairwise qs
hpairwise ps       = ps

toList :: Heap -> [Int]
toList Nil          = []
toList (Node p x q) = x : toList (p `hmerge` q)

--------------------------------------------------------------------------------

-- Heap sort (using skew heaps)
prop_HSortSorts xs = ordered (hsort xs) === True
prop_HSortCount x xs = count x (hsort xs) === count x xs
prop_HSortPermutes xs = hsort xs `isPermutation` xs === True
prop_HSortIsSort xs = hsort xs === sort xs

--------------------------------------------------------------------------------

sort :: [Int] -> [Int]
sort = isort

isort :: [Int] -> [Int]
isort []     = []
isort (x:xs) = insert x (isort xs)

insert :: Int -> [Int] -> [Int]
insert x []                 = [x]
insert x (y:xs) | x <= y    = x : y : xs
                | otherwise = y : insert x xs

--------------------------------------------------------------------------------

-- Insertion sort
prop_ISortSorts xs = ordered (isort xs) === True
prop_ISortCount x xs = count x (isort xs) === count x xs
prop_ISortPermutes xs = isort xs `isPermutation` xs === True

--------------------------------------------------------------------------------

msortbu2 :: [Int] -> [Int]
msortbu2 = mergingbu2 . risers

{-
risers :: Ord a => [a] -> [[a]]
risers []     = []
risers [x]    = [[x]]
risers (x:xs) = case risers xs of
                  (y:ys):yss | x <= y -> (x:y:ys):yss
                  yss                 -> [x]:yss
-}

risers :: [Int] -> [[Int]]
risers []       = []
risers [x]      = [[x]]
risers (x:y:xs)
  | x <= y      = case risers (y:xs) of
                    -- TODO remove default case
                    ys:yss -> (x:ys):yss
                    _ -> []
  | otherwise   = [x] : risers (y:xs)

mergingbu2 :: [[Int]] -> [Int]
mergingbu2 []   = []
mergingbu2 [xs] = xs
mergingbu2 xss  = mergingbu2 (pairwise xss)

pairwise (xs:ys:xss) = xs `lmerge` ys : pairwise xss
pairwise xss         = xss

lmerge :: [Int] -> [Int] -> [Int]
[]     `lmerge` ys = ys
xs     `lmerge` [] = xs
(x:xs) `lmerge` (y:ys)
  | x <= y        = x : xs `lmerge` (y:ys)
  | otherwise     = y : (x:xs) `lmerge` ys

--------------------------------------------------------------------------------

-- Bottom-up merge sort, using a total risers function
prop_MSortBU2Sorts xs = ordered (msortbu2 xs) === True
prop_MSortBU2Count x xs = count x (msortbu2 xs) === count x xs
prop_MSortBU2Permutes xs = msortbu2 xs `isPermutation` xs === True
prop_MSortBU2IsSort xs = msortbu2 xs === sort xs

--------------------------------------------------------------------------------

msortbu :: [Int] -> [Int]
msortbu = mergingbu . map (:[])

mergingbu :: [[Int]] -> [Int]
mergingbu []   = []
mergingbu [xs] = xs
mergingbu xss  = mergingbu (pairwise xss)

--------------------------------------------------------------------------------

-- Bottom-up merge sort
prop_MSortBUSorts xs = ordered (msortbu xs) === True
prop_MSortBUCount x xs = count x (msortbu xs) === count x xs
prop_MSortBUPermutes xs = msortbu xs `isPermutation` xs === True
prop_MSortBUIsSort xs = msortbu xs === sort xs

msorttd :: [Int] -> [Int]
msorttd []  = []
msorttd [x] = [x]
msorttd xs  = msorttd (take k xs) `lmerge` msorttd (drop k xs)
 where
  k = length xs `div` 2

-- Top-down merge sort
prop_MSortTDSorts xs = ordered (msorttd xs) === True
prop_MSortTDCount x xs = count x (msorttd xs) === count x xs
prop_MSortTDPermutes xs = msorttd xs `isPermutation` xs === True
prop_MSortTDIsSort xs = msorttd xs === sort xs

--------------------------------------------------------------------------------

nmsorttd :: [Int] -> [Int]
nmsorttd []  = []
nmsorttd [x] = [x]
nmsorttd xs  = nmsorttd (take k xs) `lmerge` nmsorttd (drop k xs)
 where
  k = half (length xs)
  half 0 = 0
  half 1 = 0
  half n = 1 + half (n-2)

-- Top-down merge sort, using division by two on natural numbers
prop_NMSortTDSorts xs = ordered (nmsorttd xs) === True
prop_NMSortTDCount x xs = count x (nmsorttd xs) === count x xs
prop_NMSortTDPermutes xs = nmsorttd xs `isPermutation` xs === True
prop_NMSortTDIsSort xs = nmsorttd xs === sort xs

--------------------------------------------------------------------------------

bsort :: [Int] -> [Int]
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

bmerge :: [Int] -> [Int] -> [Int]
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

stitch :: [Int] -> [Int] -> [Int]
stitch []     ys = ys
stitch (x:xs) ys = x : pairs xs ys

pairs :: [Int] -> [Int] -> [Int]
pairs []     ys     = ys
pairs xs     []     = xs
pairs (x:xs) (y:ys) = sort2 x y ++ pairs xs ys

sort2 :: Int -> Int -> [Int]
sort2 x y | x <= y    = [x,y]
          | otherwise = [y,x]

--------------------------------------------------------------------------------

-- Bitonic sort
prop_BSortSorts xs = ordered (bsort xs) === True
prop_BSortCount x xs = count x (bsort xs) === count x xs
prop_BSortPermutes xs = bsort xs `isPermutation` xs === True
prop_BSortIsSort xs = bsort xs === sort xs

--------------------------------------------------------------------------------

qsort :: [Int] -> [Int]
qsort []     = []
qsort (x:xs) = qsort (filter (<=x) xs) ++ [x] ++ qsort (filter (>x) xs)

-- QuickSort
prop_QSortSorts xs = ordered (qsort xs) === True
prop_QSortCount x xs = count x (qsort xs) === count x xs
prop_QSortPermutes xs = qsort xs `isPermutation` xs === True
prop_QSortIsSort xs = qsort xs === sort xs

--------------------------------------------------------------------------------

ssort :: [Int] -> [Int]
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
prop_SSortSorts xs = ordered (ssort xs) === True
prop_SSortCount x xs = count x (ssort xs) === count x xs
prop_SSortPermutes xs = ssort xs `isPermutation` xs === True
prop_SSortIsSort xs = ssort xs === sort xs

--------------------------------------------------------------------------------

tsort :: [Int] -> [Int]
tsort = ($[]) . flatten . toTree

data Tree = TNode Tree Int Tree | TNil

toTree :: [Int] -> Tree
toTree []     = TNil
toTree (x:xs) = add x (toTree xs)

add :: Int -> Tree -> Tree
add x TNil                      = TNode TNil x TNil
add x (TNode p y q) | x <= y    = TNode (add x p) y q
                    | otherwise = TNode p y (add x q)

flatten :: Tree -> [Int] -> [Int]
flatten TNil          ys = ys
flatten (TNode p x q) ys = flatten p (x : flatten q ys)

--------------------------------------------------------------------------------

-- Tree sort
prop_TSortSorts xs = ordered (tsort xs) === True
prop_TSortCount x xs = count x (tsort xs) === count x xs
prop_TSortPermutes xs = tsort xs `isPermutation` xs === True
prop_TSortIsSort xs = tsort xs === sort xs

--------------------------------------------------------------------------------

{-# NOINLINE stoogesort #-}
stoogesort :: [Int] -> [Int]
stoogesort [] = []
stoogesort [x] = [x]
stoogesort [x, y] = sort2 x y
stoogesort xs = stooge1sort2 (stooge1sort1 (stooge1sort2 xs))

{-# NOINLINE stooge1sort1 #-}
stooge1sort1 :: [Int] -> [Int]
stooge1sort1 xs = ys ++ stoogesort zs
  where
    (ys, zs) = splitAt (length xs `div` 3) xs

{-# NOINLINE stooge1sort2 #-}
stooge1sort2 :: [Int] -> [Int]
stooge1sort2 xs = stoogesort zs ++ reverse ys
  where
    (ys, zs) = splitAt (length xs `div` 3) (reverse xs)

--------------------------------------------------------------------------------

-- Stooge sort defined using reverse
prop_StoogeSortSorts xs = ordered (stoogesort xs) === True
prop_StoogeSortCount x xs = count x (stoogesort xs) === count x xs
prop_StoogeSortPermutes xs = stoogesort xs `isPermutation` xs === True
prop_StoogeSortIsSort xs = stoogesort xs === sort xs

--------------------------------------------------------------------------------

{-# NOINLINE stoogesort2 #-}
stoogesort2, stooge2sort1, stooge2sort2 :: [Int] -> [Int]
stoogesort2 [] = []
stoogesort2 [x] = [x]
stoogesort2 [x, y] = sort2 x y
stoogesort2 xs = stooge2sort2 (stooge2sort1 (stooge2sort2 xs))

{-# NOINLINE stooge2sort1 #-}
stooge2sort1 xs = ys ++ stoogesort2 zs
  where
    (ys, zs) = splitAt (length xs `div` 3) xs

{-# NOINLINE stooge2sort2 #-}
stooge2sort2 xs = stoogesort2 ys ++ zs
  where
    (ys, zs) = splitAt ((2 * length xs + 1) `div` 3) xs

----------------------------------------------------------------------------------

-- Stooge sort
prop_StoogeSort2Sorts xs = ordered (stoogesort2 xs) === True
prop_StoogeSort2Count x xs = count x (stoogesort2 xs) === count x xs
prop_StoogeSort2Permutes xs = stoogesort2 xs `isPermutation` xs === True
prop_StoogeSort2IsSort xs = stoogesort2 xs === sort xs

--------------------------------------------------------------------------------

{-# NOINLINE nstoogesort #-}
nstoogesort :: [Int] -> [Int]
nstoogesort [] = []
nstoogesort [x] = [x]
nstoogesort [x, y] = sort2 x y
nstoogesort xs = nstooge1sort2 (nstooge1sort1 (nstooge1sort2 xs))

{-# NOINLINE nstooge1sort1 #-}
nstooge1sort1 :: [Int] -> [Int]
nstooge1sort1 xs = ys ++ nstoogesort zs
  where
    (ys, zs) = splitAt (third (length xs)) xs

{-# NOINLINE nstooge1sort2 #-}
nstooge1sort2 :: [Int] -> [Int]
nstooge1sort2 xs = nstoogesort zs ++ reverse ys
  where
    (ys, zs) = splitAt (third (length xs)) (reverse xs)

--------------------------------------------------------------------------------

-- Stooge sort defined using reverse and thirds on natural numbers
prop_NStoogeSortSorts xs = ordered (nstoogesort xs) === True
prop_NStoogeSortCount x xs = count x (nstoogesort xs) === count x xs
prop_NStoogeSortPermutes xs = nstoogesort xs `isPermutation` xs === True
prop_NStoogeSortIsSort xs = nstoogesort xs === sort xs

--------------------------------------------------------------------------------

{-# NOINLINE nstoogesort2 #-}
nstoogesort2, nstooge2sort1, nstooge2sort2 :: [Int] -> [Int]
nstoogesort2 [] = []
nstoogesort2 [x] = [x]
nstoogesort2 [x, y] = sort2 x y
nstoogesort2 xs = nstooge2sort2 (nstooge2sort1 (nstooge2sort2 xs))

{-# NOINLINE nstooge2sort1 #-}
nstooge2sort1 xs = ys ++ nstoogesort2 zs
  where
    (ys, zs) = splitAt (third (length xs)) xs

{-# NOINLINE nstooge2sort2 #-}
nstooge2sort2 xs = nstoogesort2 ys ++ zs
  where
    (ys, zs) = splitAt (twoThirds (length xs)) xs

----------------------------------------------------------------------------------

-- Stooge sort, using thirds on natural numbers
prop_NStoogeSort2Sorts xs = ordered (nstoogesort2 xs) === True
prop_NStoogeSort2Count x xs = count x (nstoogesort2 xs) === count x xs
prop_NStoogeSort2Permutes xs = nstoogesort2 xs `isPermutation` xs === True
prop_NStoogeSort2IsSort xs = nstoogesort2 xs === sort xs

--------------------------------------------------------------------------------

