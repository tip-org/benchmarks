-- Skew heaps
{-# LANGUAGE ScopedTypeVariables #-}
module Sort_HeapSort where

import Prelude hiding (minimum)
import Tip
import SortUtils

--------------------------------------------------------------------------------

hsort :: [Int] -> [Int]
hsort = toList . toHeap

data Heap = Node (Heap) Int (Heap) | Nil

heap :: Heap -> Bool
heap Nil = True
heap (Node l x r) = heap1 x l && heap1 x r

heap1 :: Int -> Heap -> Bool
heap1 _ Nil = True
heap1 x (Node l y r) = x <= y && heap1 y l && heap1 y r

merge :: Heap -> Heap -> Heap
Nil        `merge` q          = q
p          `merge` Nil        = p
Node p x q `merge` Node r y s
  | x <= y                    = Node (q `merge` Node r y s) x p
  | otherwise                 = Node (Node p x q `merge` s) y r

mergeLists :: [Int] -> [Int] -> [Int]
mergeLists [] xs = xs
mergeLists xs [] = xs
mergeLists (x:xs) (y:ys)
  | x <= y = x:mergeLists xs (y:ys)
  | otherwise = y:mergeLists (x:xs) ys

insert :: Int -> Heap -> Heap
insert x h = merge (Node Nil x Nil) h

prop_merge x y = heap x ==> heap y ==> toList (merge x y) === toList x `mergeLists` toList y
prop_insert x h = heap h ==> toList (insert x h) === listInsert x (toList h)
prop_minimum h = heap h ==> listMinimum (toList h) === minimum h
prop_deleteMinimum h = heap h ==> listDeleteMinimum (toList h) === maybeToList (deleteMinimum h)


maybeToList :: Maybe Heap -> Maybe [Int]
maybeToList Nothing = Nothing
maybeToList (Just x) = Just (toList x)

minimum :: Heap -> Maybe Int
minimum Nil = Nothing
minimum (Node _ x _) = Just x

deleteMinimum :: Heap -> Maybe Heap
deleteMinimum Nil = Nothing
deleteMinimum (Node l _ r) = Just (merge l r)

toHeap :: [Int] -> Heap
toHeap [] = Nil
toHeap (x:xs) = insert x (toHeap xs)

listInsert :: Int -> [Int] -> [Int]
listInsert x [] = [x]
listInsert x (y:ys)
  | x <= y = x:y:ys
  | otherwise = y:listInsert x ys

listMinimum :: [Int] -> Maybe Int
listMinimum [] = Nothing
listMinimum (x:_) = Just x

listDeleteMinimum :: [Int] -> Maybe [Int]
listDeleteMinimum [] = Nothing
listDeleteMinimum (_:xs) = Just xs

toList :: Heap -> [Int]
toList h = toList' (heapSize h) h

toList' :: Int -> Heap -> [Int]
toList' 0 _ = []
toList' _ Nil = []
toList' n (Node p x q) = x : toList' (n-1) (p `merge` q)

heapSize :: Heap -> Int
heapSize Nil = 0
heapSize (Node l _ r) = 1 + heapSize l + heapSize r

--------------------------------------------------------------------------------

-- The sort function returns a sorted list.
prop_SortSorts (xs :: [Int]) =
  ordered (hsort xs) === True

-- The sort function permutes the input list.
prop_SortPermutes x (xs :: [Int]) =
  count x (hsort xs) === count x xs

-- The sort function permutes the input list, version 2.
prop_SortPermutes' (xs :: [Int]) =
  hsort xs `isPermutation` xs === True

--------------------------------------------------------------------------------

