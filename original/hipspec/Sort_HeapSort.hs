{-# LANGUAGE ScopedTypeVariables, TemplateHaskell, DeriveDataTypeable #-}
module Sort_QuickSort where

import Test.QuickCheck
import Test.QuickCheck.Poly
import Test.QuickCheck.All
import Nat
import Prelude hiding ((++), (==), (<=), minimum, elem, (+))
import HipSpec
import Data.Maybe hiding (maybeToList)

--------------------------------------------------------------------------------

(==), (<=) :: Nat -> Nat -> Bool
Z == Z = True
S x == S y = x == y
_ == _ = False
Z <= _ = True
_ <= Z = False
S x <= S y = x <= y

hsort :: [Nat] -> [Nat]
hsort = toList . toHeap

data Heap = Node (Heap) Nat (Heap) | Nil
 deriving ( Eq, Ord, Show, Typeable )

merge :: Heap -> Heap -> Heap
Nil        `merge` q          = q
p          `merge` Nil        = p
Node p x q `merge` Node r y s
  | x <= y                    = Node (q `merge` Node r y s) x p
  | otherwise                 = Node (Node p x q `merge` s) y r

mergeLists :: [Nat] -> [Nat] -> [Nat]
mergeLists [] xs = xs
mergeLists xs [] = xs
mergeLists (x:xs) (y:ys)
  | x <= y = x:mergeLists xs (y:ys)
  | otherwise = y:mergeLists (x:xs) ys

prop_merge :: Heap -> Heap -> Prop [Nat]
prop_merge x y = toList (merge x y) =:= toList x `mergeLists` toList y

insert :: Nat -> Heap -> Heap
insert x h = merge (Node Nil x Nil) h

prop_insert :: Nat -> Heap -> Prop [Nat]
prop_insert x h = toList (insert x h) =:= listInsert x (toList h)

prop_minimum :: Heap -> Prop (Maybe Nat)
prop_minimum h = listMinimum (toList h) =:= minimum h

prop_deleteMinimum :: Heap -> Prop (Maybe [Nat])
prop_deleteMinimum h = listDeleteMinimum (toList h) =:= maybeToList (deleteMinimum h)

maybeToList :: Maybe Heap -> Maybe [Nat]
maybeToList Nothing = Nothing
maybeToList (Just x) = Just (toList x)

minimum :: Heap -> Maybe Nat
minimum Nil = Nothing
minimum (Node _ x _) = Just x

deleteMinimum :: Heap -> Maybe Heap
deleteMinimum Nil = Nothing
deleteMinimum (Node l _ r) = Just (merge l r)

toHeap :: [Nat] -> Heap
toHeap [] = Nil
toHeap (x:xs) = insert x (toHeap xs)

listInsert :: Nat -> [Nat] -> [Nat]
listInsert x [] = [x]
listInsert x (y:ys)
  | x <= y = x:y:ys
  | otherwise = y:listInsert x ys

listMinimum :: [Nat] -> Maybe Nat
listMinimum [] = Nothing
listMinimum (x:_) = Just x

listDeleteMinimum :: [Nat] -> Maybe [Nat]
listDeleteMinimum [] = Nothing
listDeleteMinimum (_:xs) = Just xs

-- toHeap xs = merging [ Node Nil x Nil | x <- xs ]
{-
merging :: [Heap] -> Heap
merging []  = Nil
merging [p] = p
merging ps  = merging (pairwise ps)

pairwise :: [Heap] -> [Heap]
pairwise (p:q:qs) = (p `merge` q) : pairwise qs
pairwise ps       = ps
-}
toList :: Heap -> [Nat]
toList h = toList' (heapSize h) h

toList' :: Nat -> Heap -> [Nat]
toList' Z _ = []
toList' _ Nil = []
toList' (S n) (Node p x q) = x : toList' n (p `merge` q)

heapSize :: Heap -> Nat
heapSize Nil = Z
heapSize (Node l _ r) = heapSize l + heapSize r

--------------------------------------------------------------------------------

ordered :: [Nat] -> Bool
ordered []       = True
ordered [x]      = True
ordered (x:y:xs) = x <= y && ordered (y:xs)

count :: Nat -> [Nat] -> Nat
count x []                 = Z
count x (y:xs) | x == y    = S (count x xs)
               | otherwise = count x xs

isPermutation :: [Nat] -> [Nat] -> Bool
[]     `isPermutation` ys = null ys
(x:xs) `isPermutation` ys = x `elem` ys && xs `isPermutation` delete x ys

elem :: Nat -> [Nat] -> Bool
elem x [] = False
elem x (y:ys) = x == y || elem x ys

delete :: Nat -> [Nat] -> [Nat]
delete _ [] = []
delete x (y:ys)
  | x == y = ys
  | otherwise = y:delete x ys

--------------------------------------------------------------------------------

prop_SortSorts (xs :: [Nat]) =
  ordered (hsort xs) =:= True

prop_SortPermutes x (xs :: [Nat]) =
  count x (hsort xs) =:= count x xs

prop_SortPermutes' (xs :: [Nat]) =
  hsort xs `isPermutation` xs =:= True

--------------------------------------------------------------------------------

return []
testAll = $(quickCheckAll)

--------------------------------------------------------------------------------

instance Arbitrary Heap where
  arbitrary = fmap toHeap arbitrary
