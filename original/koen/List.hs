{-# LANGUAGE ScopedTypeVariables #-}
module List where

import Tip
import Prelude hiding (Eq(..), Ord(..), map, all, elem, null, length, even, (++))
import Nat
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

map f xs = [ f x | x <- xs ]
all p [] = True
all p (x:xs) = p x && all p xs
x `elem` [] = False
x `elem` (y:ys) = x == y || x `elem` ys
null [] = True
null _ = False
length [] = Z
length (_:xs) = S (length xs)
even Z = True
even (S Z) = False
even (S (S x)) = even x
[] ++ xs = xs
(x:xs) ++ ys = x:(xs ++ ys)

--------------------------------------------------------------------------------

select :: [a] -> [(a,[a])]
select []     = []
select (x:xs) = (x,xs) : [(y,x:ys) | (y,ys) <- select xs]

-- pairs :: [a] -> [(a,a)]
pairs (x:y:xs) = (x,y) : pairs xs
pairs _        = []

-- unpair :: [(a,a)] -> [a]
unpair []          = []
unpair ((x,y):xys) = x : y : unpair xys

{-# NOINLINE evens #-}
evens :: [a] -> [a]
evens (x:xs) = x : odds xs
evens []     = []

{-# NOINLINE odds #-}
odds :: [a] -> [a]
odds (x:xs) = evens xs
odds []     = []

-- interleave :: [a] -> [a] -> [a]
interleave (x:xs) ys = x : interleave ys xs
interleave []     ys = ys

--------------------------------------------------------------------------------

-- count :: Eq a => a -> [a] -> Integer
count x []                 = Z
count x (y:xs) | x == y    = S (count x xs)
               | otherwise = count x xs

-- isPermutation :: Eq a => [a] -> [a] -> Bool
[]     `isPermutation` ys = null ys
(x:xs) `isPermutation` ys = x `elem` ys && xs `isPermutation` delete x ys

--------------------------------------------------------------------------------

prop_Select xs =
  map fst (select xs) === xs

prop_SelectPermutations xs =
  all (`isPermutation` xs) [ y:ys | (y,ys) <- select xs ] === True

prop_SelectPermutations' xs z =
  all ((n `eq`) . count z) [ y:ys | (y,ys) <- select xs ] === True
 where
  n = count z xs

prop_PairUnpair xs =
  even (length xs) === True ==>
    unpair (pairs xs) === xs

prop_PairEvens xs =
  even (length xs) === True ==>
    map fst (pairs xs) === evens xs

prop_PairOdds xs =
--  even (length xs) ==>
    map snd (pairs xs) === odds xs

prop_Interleave xs =
  interleave (evens xs) (odds xs) === xs

-- Injectivity of append
prop_append_inj_1 xs ys zs = xs ++ zs === ys ++ zs ==> xs === ys
prop_append_inj_2 xs ys zs = xs ++ ys === xs ++ zs ==> ys === zs
