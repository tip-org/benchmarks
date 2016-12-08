{-# LANGUAGE ScopedTypeVariables #-}
module List where

import Tip
import Data.List
import SortUtils

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

prop_Select xs =
  map fst (select xs) === xs

prop_SelectPermutations xs =
  all (`isPermutation` xs) [ y:ys | (y,ys) <- select xs ] === True

prop_SelectPermutations' xs z =
  all ((n ==) . count z) [ y:ys | (y,ys) <- select xs ] === True
 where
  n = count z xs

prop_PairUnpair xs =
  even (length xs) ==>
    unpair (pairs xs) === xs

prop_PairEvens xs =
  even (length xs) ==>
    map fst (pairs xs) === evens xs

prop_PairOdds xs =
--  even (length xs) ==>
    map snd (pairs xs) === odds xs

prop_Interleave xs =
  interleave (evens xs) (odds xs) === xs

-- Injectivity of append
prop_append_inj_1 xs ys zs = xs ++ zs === ys ++ zs ==> xs === ys
prop_append_inj_2 xs ys zs = xs ++ ys === xs ++ zs ==> ys === zs

prop_nub_nub xs = nub (nub xs) === nub xs

prop_elem_nub_l x xs = x `elem` xs ==> x `elem` nub xs
prop_elem_nub_r x xs = x `elem` nub xs ==> x `elem` xs
prop_count_nub  x xs = x `elem` xs ==> count x (nub xs) === 1

prop_perm_trans xs ys zs = xs `isPermutation` ys ==> ys `isPermutation` zs ==> xs `isPermutation` zs
prop_perm_refl xs        = xs `isPermutation` xs === True
prop_perm_symm xs ys     = xs `isPermutation` ys ==> ys `isPermutation` xs

prop_perm_elem x xs ys   = x `elem` xs ==> xs `isPermutation` ys ==> x `elem` ys

prop_deleteAll_count x xs = deleteAll x xs === delete x xs ==> count x xs <= 1

prop_elem x xs = x `elem` xs ==> exists (\ i -> x == xs !! i)
prop_elem_map y f xs = y `elem` map f xs ==> exists (\ x -> f x === y .&&. y `elem` xs)
