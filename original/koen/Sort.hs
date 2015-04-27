-- Sorting algorithms.

{-# LANGUAGE ScopedTypeVariables #-}
module Sort where

import Tip.DSL
import Prelude hiding (Eq(..), Ord(..), map, all, elem, null, length, even, (++), filter)
import Nat hiding ((+), (*))
import qualified Prelude

type OrdA = Int

(>), (<=), (==) :: Int -> Int -> Bool
(<=) = (Prelude.<=)
(>)  = (Prelude.>)
(==) = (Prelude.==)

delete :: Int -> [Int] -> [Int]
delete x [] = []
delete x (y:ys)
  | x == y = ys
  | otherwise = y:delete x ys

filter p xs = [ x | x <- xs, p x ]
map f xs = [ f x | x <- xs ]
all p [] = True
all p (x:xs) = p x && all p xs
x `elem` [] = False
x `elem` (y:ys) = x == y || x `elem` ys
null [] = True
null _ = False
zlength :: [a] -> Int
zlength [] = 0
zlength (x:xs) = 1+zlength xs
length [] = Z
length (_:xs) = S (length xs)
even Z = True
even (S Z) = False
even (S (S x)) = even x
[] ++ xs = xs
(x:xs) ++ ys = x:(xs ++ ys)

--------------------------------------------------------------------------------

-- ordered :: Ord a => [a] -> Bool
ordered []       = True
ordered [x]      = True
ordered (x:y:xs) = x <= y && ordered (y:xs)

-- count :: Eq a => a -> [a] -> Integer
count x []                 = Z
count x (y:xs) | x == y    = S (count x xs)
               | otherwise = count x xs

-- isPermutation :: Eq a => [a] -> [a] -> Bool
[]     `isPermutation` ys = null ys
(x:xs) `isPermutation` ys = x `elem` ys && xs `isPermutation` delete x ys

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

prop_BubSortSorts (xs :: [OrdA]) =
  ordered (bubsort xs) =:= True

prop_BubSortPermutes x (xs :: [OrdA]) =
  count x (bubsort xs) =:= count x xs

prop_BubSortPermutes' (xs :: [OrdA]) =
  bubsort xs `isPermutation` xs =:= True

prop_BubSortIsSort (xs :: [OrdA]) =
  bubsort xs =:= sort xs

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

prop_HSortSorts (xs :: [OrdA]) =
  ordered (hsort xs) =:= True

prop_HSortPermutes x (xs :: [OrdA]) =
  count x (hsort xs) =:= count x xs

prop_HSortPermutes' (xs :: [OrdA]) =
  hsort xs `isPermutation` xs =:= True

prop_HSortIsSort (xs :: [OrdA]) =
  hsort xs =:= sort xs

--------------------------------------------------------------------------------

sort = isort

-- isort :: Ord a => [a] -> [a]
isort []     = []
isort (x:xs) = insert x (isort xs)

-- insert :: Ord a => a -> [a] -> [a]
insert x []                 = [x]
insert x (y:xs) | x <= y    = x : y : xs
                | otherwise = y : insert x xs

--------------------------------------------------------------------------------

prop_ISortSorts (xs :: [OrdA]) =
  ordered (isort xs) =:= True

prop_ISortPermutes x (xs :: [OrdA]) =
  count x (isort xs) =:= count x xs

prop_ISortPermutes' (xs :: [OrdA]) =
  isort xs `isPermutation` xs =:= True
{-
prop_ISortIsSort (xs :: [OrdA]) =
  isort xs =:= sort xs
-}
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

prop_MSortBU2Sorts (xs :: [OrdA]) =
  ordered (msortbu2 xs) =:= True

prop_MSortBU2Permutes x (xs :: [OrdA]) =
  count x (msortbu2 xs) =:= count x xs

prop_MSortBU2Permutes' (xs :: [OrdA]) =
  msortbu2 xs `isPermutation` xs =:= True

prop_MSortBU2IsSort (xs :: [OrdA]) =
  msortbu2 xs =:= sort xs

--------------------------------------------------------------------------------

-- msortbu :: Ord a => [a] -> [a]
msortbu = mergingbu . map (:[])

-- mergingbu :: Ord a => [[a]] -> [a]
mergingbu []   = []
mergingbu [xs] = xs
mergingbu xss  = mergingbu (pairwise xss)

--------------------------------------------------------------------------------

prop_MSortBUSorts (xs :: [OrdA]) =
  ordered (msortbu xs) =:= True

prop_MSortBUPermutes x (xs :: [OrdA]) =
  count x (msortbu xs) =:= count x xs

prop_MSortBUPermutes' (xs :: [OrdA]) =
  msortbu xs `isPermutation` xs =:= True

prop_MSortBUIsSort (xs :: [OrdA]) =
  msortbu xs =:= sort xs

-- msorttd :: Ord a => [a] -> [a]
msorttd []  = []
msorttd [x] = [x]
msorttd xs  = msorttd (take k xs) `lmerge` msorttd (drop k xs)
 where
  k = zlength xs `div` 2

prop_MSortTDSorts (xs :: [OrdA]) =
  ordered (msorttd xs) =:= True

prop_MSortTDPermutes x (xs :: [OrdA]) =
  count x (msorttd xs) =:= count x xs

prop_MSortTDPermutes' (xs :: [OrdA]) =
  msorttd xs `isPermutation` xs =:= True

prop_MSortTDIsSort (xs :: [OrdA]) =
  msorttd xs =:= sort xs

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

prop_BSortSorts (xs :: [OrdA]) =
  ordered (bsort xs) =:= True

prop_BSortPermutes x (xs :: [OrdA]) =
  count x (bsort xs) =:= count x xs

prop_BSortPermutes' (xs :: [OrdA]) =
  bsort xs `isPermutation` xs =:= True

prop_BSortIsSort (xs :: [OrdA]) =
  bsort xs =:= sort xs

--------------------------------------------------------------------------------

-- qsort :: Ord a => [a] -> [a]
qsort []     = []
qsort (x:xs) = qsort (filter (<=x) xs) ++ [x] ++ qsort (filter (>x) xs)

prop_QSortSorts (xs :: [OrdA]) =
  ordered (qsort xs) =:= True

prop_QSortPermutes x (xs :: [OrdA]) =
  count x (qsort xs) =:= count x xs

prop_QSortPermutes' (xs :: [OrdA]) =
  qsort xs `isPermutation` xs =:= True

prop_QSortIsSort (xs :: [OrdA]) =
  qsort xs =:= sort xs

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

prop_SSortSorts (xs :: [OrdA]) =
  ordered (ssort xs) =:= True

prop_SSortPermutes x (xs :: [OrdA]) =
  count x (ssort xs) =:= count x xs

prop_SSortPermutes' (xs :: [OrdA]) =
  ssort xs `isPermutation` xs =:= True

prop_SSortIsSort (xs :: [OrdA]) =
  ssort xs =:= sort xs

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

prop_TSortSorts (xs :: [OrdA]) =
  ordered (tsort xs) =:= True

prop_TSortPermutes x (xs :: [OrdA]) =
  count x (tsort xs) =:= count x xs

prop_TSortPermutes' (xs :: [OrdA]) =
  tsort xs `isPermutation` xs =:= True

prop_TSortIsSort (xs :: [OrdA]) =
  tsort xs =:= sort xs

--------------------------------------------------------------------------------

stoogesort [] = []
stoogesort [x] = [x]
stoogesort [x, y] = sort2 x y
stoogesort xs = sort2 (sort1 (sort2 xs))
  where
    sort1 xs = ys ++ stoogesort zs
      where
        (ys, zs) = splitAt (zlength xs `div` 3) xs
    sort2 xs = stoogesort zs ++ reverse ys
      where
        (ys, zs) = splitAt (zlength xs `div` 3) (reverse xs)

--------------------------------------------------------------------------------

prop_StoogeSortSorts (xs :: [OrdA]) =
  ordered (stoogesort xs) =:= True

prop_StoogeSortPermutes x (xs :: [OrdA]) =
  count x (stoogesort xs) =:= count x xs

prop_StoogeSortPermutes' (xs :: [OrdA]) =
  stoogesort xs `isPermutation` xs =:= True

prop_StoogeSortIsSort (xs :: [OrdA]) =
  stoogesort xs =:= sort xs

--------------------------------------------------------------------------------

stoogesort2 [] = []
stoogesort2 [x] = [x]
stoogesort2 [x, y] = sort2 x y
stoogesort2 xs = sort2 (sort1 (sort2 xs))
  where
    sort1 xs = ys ++ stoogesort2 zs
      where
        (ys, zs) = splitAt (zlength xs `div` 3) xs
    sort2 xs = stoogesort2 ys ++ zs
      where
        (ys, zs) = splitAt ((2 * zlength xs + 1) `div` 3) xs

----------------------------------------------------------------------------------

prop_StoogeSort2Sorts (xs :: [OrdA]) =
  ordered (stoogesort2 xs) =:= True

prop_StoogeSort2Permutes x (xs :: [OrdA]) =
  count x (stoogesort2 xs) =:= count x xs

prop_StoogeSort2Permutes' (xs :: [OrdA]) =
  stoogesort2 xs `isPermutation` xs =:= True

prop_StoogeSort2IsSort (xs :: [OrdA]) =
  stoogesort2 xs =:= sort xs

