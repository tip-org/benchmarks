{-# LANGUAGE ScopedTypeVariables #-}
module Sort where

import Tip
import Data.List hiding (sort, insert)
import SortUtils

type OrdA = Int

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

bubsort :: Ord a => [a] -> [a]
bubsort xs | b         = bubsort ys
           | otherwise = xs
 where
  (b,ys) = bubble xs

bubble :: Ord a => [a] -> (Bool,[a])
bubble (x:y:xs) = (not c||b, x':ys)
 where
  c      = x <= y
  x'     = if c then x else y
  y'     = if c then y else x
  (b,ys) = bubble (y':xs)
bubble xs       = (False,xs)

--------------------------------------------------------------------------------

-- Bubble sort
prop_BubSortSorts (xs :: [OrdA]) = ordered (bubsort xs) === True
prop_BubSortCount x (xs :: [OrdA]) = count x (bubsort xs) === count x xs
prop_BubSortPermutes (xs :: [OrdA]) = bubsort xs `isPermutation` xs === True
prop_BubSortIsSort (xs :: [OrdA]) = bubsort xs === sort xs

--------------------------------------------------------------------------------

hsort :: Ord a => [a] -> [a]
hsort = toList . toHeap

data Heap a = Node (Heap a) a (Heap a) | Nil

hmerge :: Ord a => Heap a -> Heap a -> Heap a
Nil        `hmerge` q          = q
p          `hmerge` Nil        = p
Node p x q `hmerge` Node r y s
  | x <= y                    = Node (q `hmerge` Node r y s) x p
  | otherwise                 = Node (Node p x q `hmerge` s) y r

toHeap :: Ord a => [a] -> Heap a
toHeap xs = hmerging [ Node Nil x Nil | x <- xs ]

hmerging :: Ord a => [Heap a] -> Heap a
hmerging []  = Nil
hmerging [p] = p
hmerging ps  = hmerging (hpairwise ps)

hpairwise :: Ord a => [Heap a] -> [Heap a]
hpairwise (p:q:qs) = (p `hmerge` q) : hpairwise qs
hpairwise ps       = ps

toList :: Ord a => Heap a -> [a]
toList Nil          = []
toList (Node p x q) = x : toList (p `hmerge` q)

--------------------------------------------------------------------------------

-- Heap sort (using skew heaps)
prop_HSortSorts (xs :: [OrdA]) = ordered (hsort xs) === True
prop_HSortCount x (xs :: [OrdA]) = count x (hsort xs) === count x xs
prop_HSortPermutes (xs :: [OrdA]) = hsort xs `isPermutation` xs === True
prop_HSortIsSort (xs :: [OrdA]) = hsort xs === sort xs

--------------------------------------------------------------------------------

sort :: [OrdA] -> [OrdA]
sort = isort

isort :: Ord a => [a] -> [a]
isort []     = []
isort (x:xs) = insert x (isort xs)

insert :: Ord a => a -> [a] -> [a]
insert x []                 = [x]
insert x (y:xs) | x <= y    = x : y : xs
                | otherwise = y : insert x xs

--------------------------------------------------------------------------------

-- Insertion sort
prop_ISortSorts (xs :: [OrdA]) = ordered (isort xs) === True
prop_ISortCount x (xs :: [OrdA]) = count x (isort xs) === count x xs
prop_ISortPermutes (xs :: [OrdA]) = isort xs `isPermutation` xs === True

--------------------------------------------------------------------------------

msortbu2 :: Ord a => [a] -> [a]
msortbu2 = mergingbu2 . risers

{-
risers :: Ord a => [a] -> [[a]]
risers []     = []
risers [x]    = [[x]]
risers (x:xs) = case risers xs of
                  (y:ys):yss | x <= y -> (x:y:ys):yss
                  yss                 -> [x]:yss
-}

risers :: Ord a => [a] -> [[a]]
risers []       = []
risers [x]      = [[x]]
risers (x:y:xs)
  | x <= y      = case risers (y:xs) of
                    -- TODO remove default case
                    ys:yss -> (x:ys):yss
                    _ -> []
  | otherwise   = [x] : risers (y:xs)

mergingbu2 :: Ord a => [[a]] -> [a]
mergingbu2 []   = []
mergingbu2 [xs] = xs
mergingbu2 xss  = mergingbu2 (pairwise xss)

pairwise (xs:ys:xss) = xs `lmerge` ys : pairwise xss
pairwise xss         = xss

lmerge :: Ord a => [a] -> [a] -> [a]
[]     `lmerge` ys = ys
xs     `lmerge` [] = xs
(x:xs) `lmerge` (y:ys)
  | x <= y        = x : xs `lmerge` (y:ys)
  | otherwise     = y : (x:xs) `lmerge` ys

--------------------------------------------------------------------------------

-- Bottom-up merge sort, using a total risers function
prop_MSortBU2Sorts (xs :: [OrdA]) = ordered (msortbu2 xs) === True
prop_MSortBU2Count x (xs :: [OrdA]) = count x (msortbu2 xs) === count x xs
prop_MSortBU2Permutes (xs :: [OrdA]) = msortbu2 xs `isPermutation` xs === True
prop_MSortBU2IsSort (xs :: [OrdA]) = msortbu2 xs === sort xs

--------------------------------------------------------------------------------

msortbu :: Ord a => [a] -> [a]
msortbu = mergingbu . map (:[])

mergingbu :: Ord a => [[a]] -> [a]
mergingbu []   = []
mergingbu [xs] = xs
mergingbu xss  = mergingbu (pairwise xss)

--------------------------------------------------------------------------------

-- Bottom-up merge sort
prop_MSortBUSorts (xs :: [OrdA]) = ordered (msortbu xs) === True
prop_MSortBUCount x (xs :: [OrdA]) = count x (msortbu xs) === count x xs
prop_MSortBUPermutes (xs :: [OrdA]) = msortbu xs `isPermutation` xs === True
prop_MSortBUIsSort (xs :: [OrdA]) = msortbu xs === sort xs

msorttd :: Ord a => [a] -> [a]
msorttd []  = []
msorttd [x] = [x]
msorttd xs  = msorttd (take k xs) `lmerge` msorttd (drop k xs)
 where
  k = length xs `div` 2

-- Top-down merge sort
prop_MSortTDSorts (xs :: [OrdA]) = ordered (msorttd xs) === True
prop_MSortTDCount x (xs :: [OrdA]) = count x (msorttd xs) === count x xs
prop_MSortTDPermutes (xs :: [OrdA]) = msorttd xs `isPermutation` xs === True
prop_MSortTDIsSort (xs :: [OrdA]) = msorttd xs === sort xs

--------------------------------------------------------------------------------

nmsorttd :: Ord a => [a] -> [a]
nmsorttd []  = []
nmsorttd [x] = [x]
nmsorttd xs  = nmsorttd (take k xs) `lmerge` nmsorttd (drop k xs)
 where
  k = half (length xs)
  half 0 = 0
  half 1 = 0
  half n = 1 + half (n-2)

-- Top-down merge sort, using division by two on natural numbers
prop_NMSortTDSorts (xs :: [OrdA]) = ordered (nmsorttd xs) === True
prop_NMSortTDCount x (xs :: [OrdA]) = count x (nmsorttd xs) === count x xs
prop_NMSortTDPermutes (xs :: [OrdA]) = nmsorttd xs `isPermutation` xs === True
prop_NMSortTDIsSort (xs :: [OrdA]) = nmsorttd xs === sort xs

--------------------------------------------------------------------------------

bsort :: Ord a => [a] -> [a]
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

bmerge :: Ord a => [a] -> [a] -> [a]
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

stitch :: Ord a => [a] -> [a] -> [a]
stitch []     ys = ys
stitch (x:xs) ys = x : pairs xs ys

pairs :: Ord a => [a] -> [a] -> [a]
pairs []     ys     = ys
pairs xs     []     = xs
pairs (x:xs) (y:ys) = sort2 x y ++ pairs xs ys

sort2 :: Ord a => a -> a -> [a]
sort2 x y | x <= y    = [x,y]
          | otherwise = [y,x]

--------------------------------------------------------------------------------

-- Bitonic sort
prop_BSortSorts (xs :: [OrdA]) = ordered (bsort xs) === True
prop_BSortCount x (xs :: [OrdA]) = count x (bsort xs) === count x xs
prop_BSortPermutes (xs :: [OrdA]) = bsort xs `isPermutation` xs === True
prop_BSortIsSort (xs :: [OrdA]) = bsort xs === sort xs

--------------------------------------------------------------------------------

qsort :: Ord a => [a] -> [a]
qsort []     = []
qsort (x:xs) = qsort (filter (<=x) xs) ++ [x] ++ qsort (filter (>x) xs)

-- QuickSort
prop_QSortSorts (xs :: [OrdA]) = ordered (qsort xs) === True
prop_QSortCount x (xs :: [OrdA]) = count x (qsort xs) === count x xs
prop_QSortPermutes (xs :: [OrdA]) = qsort xs `isPermutation` xs === True
prop_QSortIsSort (xs :: [OrdA]) = qsort xs === sort xs

--------------------------------------------------------------------------------

ssort :: Ord a => [a] -> [a]
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
prop_SSortSorts (xs :: [OrdA]) = ordered (ssort xs) === True
prop_SSortCount x (xs :: [OrdA]) = count x (ssort xs) === count x xs
prop_SSortPermutes (xs :: [OrdA]) = ssort xs `isPermutation` xs === True
prop_SSortIsSort (xs :: [OrdA]) = ssort xs === sort xs

--------------------------------------------------------------------------------

tsort :: Ord a => [a] -> [a]
tsort = ($[]) . flatten . toTree

data Tree a = TNode (Tree a) a (Tree a) | TNil

toTree :: Ord a => [a] -> Tree a
toTree []     = TNil
toTree (x:xs) = add x (toTree xs)

add :: Ord a => a -> Tree a -> Tree a
add x TNil                      = TNode TNil x TNil
add x (TNode p y q) | x <= y    = TNode (add x p) y q
                    | otherwise = TNode p y (add x q)

flatten :: Tree a -> [a] -> [a]
flatten TNil          ys = ys
flatten (TNode p x q) ys = flatten p (x : flatten q ys)

--------------------------------------------------------------------------------

-- Tree sort
prop_TSortSorts (xs :: [OrdA]) = ordered (tsort xs) === True
prop_TSortCount x (xs :: [OrdA]) = count x (tsort xs) === count x xs
prop_TSortPermutes (xs :: [OrdA]) = tsort xs `isPermutation` xs === True
prop_TSortIsSort (xs :: [OrdA]) = tsort xs === sort xs

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
prop_StoogeSortSorts (xs :: [OrdA]) = ordered (stoogesort xs) === True
prop_StoogeSortCount x (xs :: [OrdA]) = count x (stoogesort xs) === count x xs
prop_StoogeSortPermutes (xs :: [OrdA]) = stoogesort xs `isPermutation` xs === True
prop_StoogeSortIsSort (xs :: [OrdA]) = stoogesort xs === sort xs

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
prop_StoogeSort2Sorts (xs :: [OrdA]) = ordered (stoogesort2 xs) === True
prop_StoogeSort2Count x (xs :: [OrdA]) = count x (stoogesort2 xs) === count x xs
prop_StoogeSort2Permutes (xs :: [OrdA]) = stoogesort2 xs `isPermutation` xs === True
prop_StoogeSort2IsSort (xs :: [OrdA]) = stoogesort2 xs === sort xs

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
prop_NStoogeSortSorts (xs :: [OrdA]) = ordered (nstoogesort xs) === True
prop_NStoogeSortCount x (xs :: [OrdA]) = count x (nstoogesort xs) === count x xs
prop_NStoogeSortPermutes (xs :: [OrdA]) = nstoogesort xs `isPermutation` xs === True
prop_NStoogeSortIsSort (xs :: [OrdA]) = nstoogesort xs === sort xs

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
prop_NStoogeSort2Sorts (xs :: [OrdA]) = ordered (nstoogesort2 xs) === True
prop_NStoogeSort2Count x (xs :: [OrdA]) = count x (nstoogesort2 xs) === count x xs
prop_NStoogeSort2Permutes (xs :: [OrdA]) = nstoogesort2 xs `isPermutation` xs === True
prop_NStoogeSort2IsSort (xs :: [OrdA]) = nstoogesort2 xs === sort xs

--------------------------------------------------------------------------------

