-- Lemmas from "Productive Use of Failure in Inductive Proof",
-- Andrew Ireland and Alan Bundy, JAR 1996
{-# LANGUAGE TypeOperators#-}
module Lemmas where

import Prelude (Eq,Ord,Show,Bool(..))
import Tip
import Definitions

prop_L01 :: Nat -> Nat -> Equality Nat
prop_L01 x y =
  x + (S y) === S (x + y)

prop_L02 :: [a] -> a -> [a] -> Equality Nat
prop_L02 xs y ys =
  length (xs ++ (y:ys)) === S (length (xs ++ ys))

prop_L03 :: [a] -> a -> Equality Nat
prop_L03 xs y =
  length (xs ++ (y : [])) === S (length xs)

prop_L04 :: Nat -> Nat -> a -> [a] -> Equality [a]
prop_L04 w x y zs =
  drop (S w) (drop x (y:zs)) === drop w (drop x zs)

prop_L05 :: Nat -> Nat -> a -> a -> [a] -> Equality [a]
prop_L05 v w x y zs =
  drop (S v) (drop (S w) (x : (y : zs))) === drop (S v) (drop w (x : zs))

prop_L06 :: Nat -> Nat -> Nat -> a -> [a] -> Equality [a]
prop_L06 v w x y z =
  drop (S v) (drop w (drop x (y:z))) === drop v (drop w (drop x z))

prop_L07 :: Nat -> Nat -> Nat -> a -> a -> [a] -> Equality [a]
prop_L07 u v w x y z =
  drop (S u) (drop v (drop (S w) (x : (y : z)))) ===
  drop (S u) (drop v (drop w (x:z)))

prop_L08 :: [a] -> a -> Equality [a]
prop_L08 x y =
  rev (x ++ (y : [])) === y : (rev x)

prop_L09 :: [a] -> [a] -> a -> Equality [a]
prop_L09 x y z =
  rev (x ++ (y ++ (z : []))) === z : (rev (x ++ []))

prop_L10 :: [a] -> a -> Equality [a]
prop_L10 x y =
  rev ((x ++ (y : [])) ++ []) === y : (rev (x ++ []))

prop_L11 :: [a] -> a -> [a] -> Equality [a]
prop_L11 x y z =
  (x ++ (y : [])) ++ z === x ++ (y : z)

prop_L12 :: Nat -> [Nat] -> Equality Bool
prop_L12 x y =
  sorted y ==> sorted (insert x y)

prop_L13 :: [a] -> [a] -> a -> Equality [a]
prop_L13 x y z =
  (x ++ y) ++ (z : []) === x ++ (y ++ (z : []))

prop_L14 :: [a] -> a -> a -> [a] -> Equality Bool
prop_L14 w x y z =
  even (length (w ++ z)) === even (length (w ++ (x : (y : z))))

prop_L15 :: [a] -> a -> a -> [a] -> Equality Nat
prop_L15 w x y z =
  length (w ++ (x : (y : z))) === S (S (length (w ++ z)))

prop_L16 :: Nat -> Nat -> Equality Bool
prop_L16 x y =
  even (x + y) === even (x + S (S y))

prop_L17 :: Nat -> Nat -> Equality Nat
prop_L17 x y =
  x + S (S y) === S (S (x + y))

prop_L18 :: Nat -> [Nat] -> Equality Nat
prop_L18 x y =
  length (insert x y) === S (length y)

prop_L19 :: Nat -> Nat -> [Nat] -> Bool :=>: Bool :=>: Bool
prop_L19 x y z =
  x /= y ==> (x `elem` insert y z ==> x `elem` z)

prop_L20 :: Nat -> [Nat] -> Equality Nat
prop_L20 x y =
  count x (insert x y) === S (count x y)

prop_L21 :: Nat -> Nat -> [Nat] -> Bool :=>: Equality Nat
prop_L21 x y z =
  x /= y ==> count x (insert y z) === count x z

prop_L22 :: [a] -> [a] -> [a] -> Equality [a]
prop_L22 xs ys zs =
  (xs ++ ys) ++ zs === xs ++ (ys ++ zs)

prop_L23 :: Nat -> Nat -> Nat -> Equality Nat
prop_L23 x y z =
  (x * y) * z === x * (y * z)

prop_L24 :: Nat -> Nat -> Nat -> Equality Nat
prop_L24 x y z =
  (x + y) + z === x + (y + z)
