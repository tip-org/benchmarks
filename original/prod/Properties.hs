-- Property from "Productive Use of Failure in Inductive Proof",
-- Andrew Ireland and Alan Bundy, JAR 1996
{-# LANGUAGE TypeOperators #-}
module Properties where

import Tip
import Data.Typeable
import Prelude(Bool(..))
import Definitions

-- Theorems

prop_T01 :: Nat -> Equality Nat
prop_T01 x = double x === x + x

prop_T02 :: [a] -> [a] -> Equality Nat
prop_T02 x y = length (x ++ y ) === length (y ++ x)

prop_T03 :: [a] -> [a] -> Equality Nat
prop_T03 x y = length (x ++ y ) === length (y ) + length x

prop_T04 :: [a] -> Equality Nat
prop_T04 x = length (x ++ x) === double (length x)

prop_T05 :: [a] -> Equality Nat
prop_T05 x = length (rev x) === length x

prop_T06 :: [a] -> [a] -> Equality Nat
prop_T06 x y = length (rev (x ++ y )) === length x + length y

prop_T07 :: [a] -> [a] -> Equality Nat
prop_T07 x y = length (qrev x y) === length x + length y

prop_T08 :: Nat -> Nat -> [a] -> Equality [a]
prop_T08 x y z = drop x (drop y z) === drop y (drop x z)

prop_T09 :: Nat -> Nat -> [a] -> Nat -> Equality [a]
prop_T09 x y z w = drop w (drop x (drop y z)) === drop y (drop x (drop w z))

prop_T10 :: [a] -> Equality [a]
prop_T10 x = rev (rev x) === x

prop_T11 :: [a] -> [a] -> Equality [a]
prop_T11 x y = rev (rev x ++ rev y) === y ++ x

prop_T12 :: [a] -> [a] -> Equality [a]
prop_T12 x y = qrev x y === rev x ++ y

prop_T13 :: Nat -> Equality Nat
prop_T13 x = half (x + x) === x

-- This property is the same as isaplanner #78
prop_T14 :: [Nat] -> Equality Bool
prop_T14 x = bool (sorted (isort x))

prop_T15 :: Nat -> Equality Nat
prop_T15 x = x + S x === S (x + x)

prop_T16 :: Nat -> Equality Bool
prop_T16 x = bool (even (x + x))

prop_T17 :: [a] -> [a] -> Equality [a]
prop_T17 x y = rev (rev (x ++ y)) === rev (rev x) ++ rev (rev y)

prop_T18 :: [a] -> [a] -> Equality [a]
prop_T18 x y = rev (rev x ++ y) === rev y ++ x

prop_T19 :: [a] -> [a] -> Equality [a]
prop_T19 x y = rev (rev x) ++ y === rev (rev (x ++ y))

prop_T20 :: [a] -> Equality Bool
prop_T20 x = bool (even (length (x ++ x)))

prop_T21 :: [a] -> [a] -> Equality [a]
prop_T21 x y = rotate (length x) (x ++ y) === y ++ x

prop_T22 :: [a] -> [a] -> Equality Bool
prop_T22 x y = even (length (x ++ y)) === even (length (y ++ x))

prop_T23 :: [a] -> [a] -> Equality Nat
prop_T23 x y = half (length (x ++ y)) === half (length (y ++ x))

prop_T24 :: Nat -> Nat -> Equality Bool
prop_T24 x y = even (x + y) === even (y + x)

prop_T25 :: [a] -> [a] -> Equality Bool
prop_T25 x y = even (length (x ++ y)) === even (length y + length x)

prop_T26 :: Nat -> Nat -> Equality Nat
prop_T26 x y = half (x + y) === half (y + x)

prop_T27 :: [a] -> Equality [a]
prop_T27 x = rev x === qrev x []

prop_T28 :: [[a]] -> Equality [a]
prop_T28 x = revflat x === qrevflat x []

prop_T29 :: [a] -> Equality [a]
prop_T29 x = rev (qrev x []) === x

prop_T30 :: [a] -> Equality [a]
prop_T30 x = rev (rev x ++ []) === x

prop_T31 :: [a] -> Equality [a]
prop_T31 x = qrev (qrev x []) [] === x

prop_T32 :: [a] -> Equality [a]
prop_T32 x = rotate (length x) x === x

prop_T33 :: Nat -> Equality Nat
prop_T33 x = fac x === qfac x one

prop_T34 :: Nat -> Nat -> Equality Nat
prop_T34 x y = x * y === mult x y zero

prop_T35 :: Nat -> Nat -> Equality Nat
prop_T35 x y = exp x y === qexp x y one

prop_T36 :: Nat -> [Nat] -> [Nat] -> Bool :=>: Bool
prop_T36 x y z = x `elem` y ==> x `elem` (y ++ z)

prop_T37 :: Nat -> [Nat] -> [Nat] -> Bool :=>: Bool
prop_T37 x y z = x `elem` z ==>  x `elem` (y ++ z)

prop_T38 :: Nat -> [Nat] -> [Nat] -> Bool :=>: Bool :=>: Bool
prop_T38 x y z = x `elem` y ==>
                 x `elem` z ==>
                 x `elem` (y ++ z)

prop_T39 :: Nat -> Nat -> [Nat] -> Bool :=>: Bool
prop_T39 x y z = x `elem` drop y z ==> x `elem` z

prop_T40 :: [Nat] -> [Nat] -> Bool :=>: Equality [Nat]
prop_T40 x y = x `subset` y ==> (x `union` y) === y

prop_T41 :: [Nat] -> [Nat] -> Bool :=>: Equality [Nat]
prop_T41 x y = x `subset` y ==> (x `intersect` y) === x

prop_T42 :: Nat -> [Nat] -> [Nat] -> Bool :=>: Bool
prop_T42 x y z = x `elem` y ==> x `elem` (y `union` z)

prop_T43 :: Nat -> [Nat] -> [Nat] -> Bool :=>: Bool
prop_T43 x y z = x `elem` y ==> x `elem` (z `union` y)

prop_T44 :: Nat -> [Nat] -> [Nat] -> Bool :=>: Bool :=>: Bool
prop_T44 x y z = x `elem` y ==>
                 x `elem` z ==>
                 x `elem` (y `intersect` z)

prop_T45 :: Nat -> [Nat] -> Equality Bool
prop_T45 x y = bool (x `elem` insert x y)

prop_T46 :: Nat -> Nat -> [Nat] -> Equality Nat :=>: Bool
prop_T46 x y z = x === y ==> x `elem` insert y z

prop_T47 :: Nat -> Nat -> [Nat] -> Bool :=>: Equality Bool
prop_T47 x y z = x /= y ==> (x `elem` insert y z) === x `elem` z

-- This property is the same as isaplanner #20
prop_T48 :: [Nat] -> Equality Nat
prop_T48 x = length (isort x) === length x

prop_T49 :: Nat -> [Nat] -> Bool :=>: Bool
prop_T49 x y = x `elem` isort y ==> x `elem` y

-- This property is the same as isaplanner #53
prop_T50 :: Nat -> [Nat] -> Equality Nat
prop_T50 x y = count x (isort y) === count x y

