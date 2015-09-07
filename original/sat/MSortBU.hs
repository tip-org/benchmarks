# 1 "Sort.hs"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "Sort.hs"
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
bubsort xs | b = bubsort ys
           | otherwise = xs
 where
  (b,ys) = bubble xs

-- bubble :: Ord a => [a] -> (Bool,[a])
bubble (x:y:xs) = (not c||b, x':ys)
 where
  c = x <= y
  x'     = if c then x else y
  y'     = if c then y else x
  (b,ys) = bubble (y':xs)
bubble xs = (False,xs)

--------------------------------------------------------------------------------

-- Bubble sort

--------------------------------------------------------------------------------

-- hsort :: Ord a => [a] -> [a]
hsort = toList . toHeap

data Heap a = Node (Heap a) a (Heap a) | Nil

-- hmerge :: Ord a => Heap a -> Heap a -> Heap a
Nil `hmerge` q = q
p `hmerge` Nil = p
Node p x q `hmerge` Node r y s
  | x <= y = Node (q `hmerge` Node r y s) x p
  | otherwise = Node (Node p x q `hmerge` s) y r

-- toHeap :: Ord a => [a] -> Heap a
toHeap xs = hmerging [ Node Nil x Nil | x <- xs ]

-- hmerging :: Ord a => [Heap a] -> Heap a
hmerging [] = Nil
hmerging [p] = p
hmerging ps = hmerging (hpairwise ps)

-- hpairwise :: Ord a => [Heap a] -> [Heap a]
hpairwise (p:q:qs) = (p `hmerge` q) : hpairwise qs
hpairwise ps = ps

-- toList :: Ord a => Heap a -> [a]
toList Nil = []
toList (Node p x q) = x : toList (p `hmerge` q)

--------------------------------------------------------------------------------

-- Heap sort (using skew heaps)

--------------------------------------------------------------------------------

sort :: [Nat] -> [Nat]
sort = isort

-- isort :: Ord a => [a] -> [a]
isort [] = []
isort (x:xs) = insert x (isort xs)

-- insert :: Ord a => a -> [a] -> [a]
insert x [] = [x]
insert x (y:xs) | x <= y = x : y : xs
                | otherwise = y : insert x xs

--------------------------------------------------------------------------------

-- Insertion sort

--------------------------------------------------------------------------------

-- msortbu2 :: Ord a => [a] -> [a]
msortbu2 = mergingbu2 . risers

{-
risers :: Ord a => [a] -> [[a]]
risers [] = []
risers [x] = [[x]]
risers (x:xs) = case risers xs of
                  (y:ys):yss | x <= y -> (x:y:ys):yss
                  yss -> [x]:yss
-}

-- risers :: Ord a => [a] -> [[a]]
risers [] = []
risers [x] = [[x]]
risers (x:y:xs)
  | x <= y = case risers (y:xs) of
                    -- TODO remove default case
                    ys:yss -> (x:ys):yss
                    _ -> []
  | otherwise = [x] : risers (y:xs)

-- mergingbu2 :: Ord a => [[a]] -> [a]
mergingbu2 [] = []
mergingbu2 [xs] = xs
mergingbu2 xss = mergingbu2 (pairwise xss)

pairwise (xs:ys:xss) = xs `lmerge` ys : pairwise xss
pairwise xss = xss

-- lmerge :: Ord a => [a] -> [a] -> [a]
[] `lmerge` ys = ys
xs `lmerge` [] = xs
(x:xs) `lmerge` (y:ys)
  | x <= y = x : xs `lmerge` (y:ys)
  | otherwise = y : (x:xs) `lmerge` ys

--------------------------------------------------------------------------------

-- Bottom-up merge sort, using a total risers function

--------------------------------------------------------------------------------

singletons [] = []
singletons (x:xs) = [x]:singletons xs

-- msortbu :: Ord a => [a] -> [a]
msortbu = mergingbu . singletons

-- mergingbu :: Ord a => [[a]] -> [a]
mergingbu [] = []
mergingbu [xs] = xs
mergingbu xss = mergingbu (pairwise xss)

--------------------------------------------------------------------------------

-- Bottom-up merge sort

-- msorttd :: Ord a => [a] -> [a]
msorttd [] = []
msorttd [x] = [x]
msorttd xs = msorttd (take k xs) `lmerge` msorttd (drop k xs)
 where
  k = half (length xs)

-- Top-down merge sort

--------------------------------------------------------------------------------

eomsorttd [] = []
eomsorttd [x] = [x]
eomsorttd xs = eomsorttd (evens xs) `lmerge` eomsorttd (odds xs)

-- Top-down merge sort, using the even and odd elements of the list

--------------------------------------------------------------------------------

-- bsort :: Ord a => [a] -> [a]
bsort [] = []
bsort [x] = [x]
bsort xs = bmerge (bsort (evens xs)) (bsort (odds xs))

{-# NOINLINE evens #-}
evens :: [a] -> [a]
evens (x:xs) = x : odds xs
evens [] = []

{-# NOINLINE odds #-}
odds :: [a] -> [a]
odds (x:xs) = evens xs
odds [] = []

-- bmerge :: Ord a => [a] -> [a] -> [a]
bmerge [] bs = []
bmerge as [] = as
bmerge [a] [b] = sort2 a b
bmerge as bs = stitch cs0 cs1
 where
  as0 = evens as
  as1 = odds as
  bs0 = evens bs
  bs1 = odds bs
  cs0 = bmerge as0 bs0
  cs1 = bmerge as1 bs1

-- stitch :: Ord a => [a] -> [a] -> [a]
stitch [] ys = ys
stitch (x:xs) ys = x : pairs xs ys

-- pairs :: Ord a => [a] -> [a] -> [a]
pairs [] ys = ys
pairs xs [] = xs
pairs (x:xs) (y:ys) = sort2 x y ++ pairs xs ys

-- sort2 :: Ord a => a -> a -> [a]
sort2 x y | x <= y = [x,y]
          | otherwise = [y,x]

--------------------------------------------------------------------------------

-- Bitonic sort

--------------------------------------------------------------------------------

-- qsort :: Ord a => [a] -> [a]
qsort [] = []
qsort (x:xs) = qsort (filter_le x xs) ++ [x] ++ qsort (filter_gt x xs)

filter_le x (y:ys)
  | y <= x = y:filter_le x ys
  | otherwise = filter_le x ys
filter_le _ [] = []

filter_gt x (y:ys)
  | y > x = y:filter_gt x ys
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
toTree [] = TNil
toTree (x:xs) = add x (toTree xs)

-- add :: Ord a => a -> Tree a -> Tree a
add x TNil = TNode TNil x TNil
add x (TNode p y q) | x <= y = TNode (add x p) y q
                    | otherwise = TNode p y (add x q)

-- flatten :: Tree a -> [a] -> [a]
flatten TNil ys = ys
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
# 370 "Sort.hs"
sat_inj_n02 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S Z)))
sat_inj_n03 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S Z))))
sat_inj_n04 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S Z)))))
sat_inj_n05 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S Z))))))
sat_inj_n06 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S Z)))))))
sat_inj_n07 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S Z))))))))
sat_inj_n08 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S Z)))))))))
sat_inj_n09 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S Z))))))))))
sat_inj_n10 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S Z)))))))))))
sat_inj_n11 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))
sat_inj_n12 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))
sat_inj_n13 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))
sat_inj_n14 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))
sat_inj_n15 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))
sat_inj_n16 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))
sat_inj_n17 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))
sat_inj_n18 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))
sat_inj_n19 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))
sat_inj_n20 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))))
sat_inj_n21 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))))
sat_inj_n22 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))))))
sat_inj_n23 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))))))
sat_inj_n24 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))))))))
sat_inj_n25 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))))))))
sat_inj_n26 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))))))))))
sat_inj_n27 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))))))))))
sat_inj_n28 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))))))))))))
sat_inj_n29 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))))))))))))

sat_nub_n02 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S Z)))
sat_nub_n03 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S Z))))
sat_nub_n04 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S Z)))))
sat_nub_n05 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S Z))))))
sat_nub_n06 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S (S Z)))))))
sat_nub_n07 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S (S (S Z))))))))
sat_nub_n08 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S (S (S (S Z)))))))))
sat_nub_n09 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S (S (S (S (S Z))))))))))
sat_nub_n10 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S Z)))))))))))
sat_nub_n11 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))
sat_nub_n12 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))
sat_nub_n13 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))
sat_nub_n14 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))

sat_unq_n02 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S Z)))
sat_unq_n03 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S Z))))
sat_unq_n04 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S Z)))))
sat_unq_n05 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S Z))))))
sat_unq_n06 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S (S Z)))))))
sat_unq_n07 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S (S (S Z))))))))
sat_unq_n08 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S (S (S (S Z)))))))))
sat_unq_n09 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S (S (S (S (S Z))))))))))
sat_unq_n10 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S Z)))))))))))
sat_unq_n11 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))
sat_unq_n12 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))
sat_unq_n13 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))
sat_unq_n14 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))

sat_inj_len_both_n02 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S Z)) .&&. length ys === (S (S Z)))
sat_inj_len_both_n03 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S Z))) .&&. length ys === (S (S (S Z))))
sat_inj_len_both_n04 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S Z)))) .&&. length ys === (S (S (S (S Z)))))
sat_inj_len_both_n05 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S Z))))) .&&. length ys === (S (S (S (S (S Z))))))
sat_inj_len_both_n06 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S Z)))))) .&&. length ys === (S (S (S (S (S (S Z)))))))
sat_inj_len_both_n07 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S Z))))))) .&&. length ys === (S (S (S (S (S (S (S Z))))))))
sat_inj_len_both_n08 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S Z)))))))) .&&. length ys === (S (S (S (S (S (S (S (S Z)))))))))
sat_inj_len_both_n09 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S Z))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S Z))))))))))
sat_inj_len_both_n10 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S Z)))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S Z)))))))))))
sat_inj_len_both_n11 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S Z))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))
sat_inj_len_both_n12 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))
sat_inj_len_both_n13 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))
sat_inj_len_both_n14 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))
sat_inj_len_both_n15 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))
sat_inj_len_both_n16 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))
sat_inj_len_both_n17 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))
sat_inj_len_both_n18 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))
sat_inj_len_both_n19 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))
sat_inj_len_both_n20 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))))
sat_inj_len_both_n21 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))))
sat_inj_len_both_n22 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))))))
sat_inj_len_both_n23 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))))))
sat_inj_len_both_n24 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))))))))
sat_inj_len_both_n25 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))))))))
sat_inj_len_both_n26 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))))))))))
sat_inj_len_both_n27 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))))))))))
sat_inj_len_both_n28 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))))))))))))))))
sat_inj_len_both_n29 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))))))))))))))))))

sat_nub_len_both_n02 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S Z)) .&&. length ys === (S (S Z)))
sat_nub_len_both_n03 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S Z))) .&&. length ys === (S (S (S Z))))
sat_nub_len_both_n04 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S Z)))) .&&. length ys === (S (S (S (S Z)))))
sat_nub_len_both_n05 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S Z))))) .&&. length ys === (S (S (S (S (S Z))))))
sat_nub_len_both_n06 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S (S Z)))))) .&&. length ys === (S (S (S (S (S (S Z)))))))
sat_nub_len_both_n07 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S (S (S Z))))))) .&&. length ys === (S (S (S (S (S (S (S Z))))))))
sat_nub_len_both_n08 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S (S (S (S Z)))))))) .&&. length ys === (S (S (S (S (S (S (S (S Z)))))))))
sat_nub_len_both_n09 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S (S (S (S (S Z))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S Z))))))))))
sat_nub_len_both_n10 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S Z)))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S Z)))))))))))
sat_nub_len_both_n11 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S Z))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))
sat_nub_len_both_n12 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))
sat_nub_len_both_n13 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))
sat_nub_len_both_n14 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. nub xs === xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))

sat_unq_len_both_n02 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S Z)) .&&. length ys === (S (S Z)))
sat_unq_len_both_n03 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S Z))) .&&. length ys === (S (S (S Z))))
sat_unq_len_both_n04 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S Z)))) .&&. length ys === (S (S (S (S Z)))))
sat_unq_len_both_n05 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S Z))))) .&&. length ys === (S (S (S (S (S Z))))))
sat_unq_len_both_n06 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S (S Z)))))) .&&. length ys === (S (S (S (S (S (S Z)))))))
sat_unq_len_both_n07 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S (S (S Z))))))) .&&. length ys === (S (S (S (S (S (S (S Z))))))))
sat_unq_len_both_n08 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S (S (S (S Z)))))))) .&&. length ys === (S (S (S (S (S (S (S (S Z)))))))))
sat_unq_len_both_n09 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S (S (S (S (S Z))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S Z))))))))))
sat_unq_len_both_n10 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S Z)))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S Z)))))))))))
sat_unq_len_both_n11 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S Z))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))
sat_unq_len_both_n12 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))
sat_unq_len_both_n13 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S Z))))))))))))))
sat_unq_len_both_n14 xs ys = question (msortbu xs === msortbu ys .&&. xs =/= ys .&&. unique xs .&&. length xs === (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))) .&&. length ys === (S (S (S (S (S (S (S (S (S (S (S (S (S (S Z)))))))))))))))
