-- The implementation of these integers correspond to those in the
-- Agda standard library, which is proved to be a commutative ring
{-# LANGUAGE DeriveDataTypeable #-}
module Challenges.Integers where

import Prelude (Eq,Ord,Show,iterate,(!!),fmap,Bool(..),return,undefined)
import HipSpec
import Data.Typeable

import Nat hiding ((-))

data Z = P Nat | N Nat deriving (Show,Eq,Typeable,Ord)

instance Arbitrary Z where
  arbitrary = oneof [P `fmap` arbitrary,N `fmap` arbitrary]
{-
instance Names Z where
    names _ = ["i","j","k"]-}

-- Natural subtraction
(-) :: Nat -> Nat -> Z
Z   - Z     = P Z
S m - Z     = P (S m)
Z   - S n   = N n
S m - S n   = m - n

neg :: Z -> Z
neg (P (S n)) = N n
neg (P Z)     = P Z
neg (N n)     = P (S n)

prop_neg_involutive :: Z -> Prop Z
prop_neg_involutive x = x =:= neg (neg x)

-- Integer addition
plus :: Z -> Z -> Z
N m `plus` N n = N (S (m + n))
N m `plus` P n = n - S m
P m `plus` N n = m - S n
P m `plus` P n = P (m + n)

zero :: Z
zero = P Z

prop_add_ident_left :: Z -> Prop Z
prop_add_ident_left x = x =:= zero `plus` x

prop_add_ident_right :: Z -> Prop Z
prop_add_ident_right x = x =:= x `plus` zero

prop_add_assoc :: Z -> Z -> Z -> Prop Z
prop_add_assoc x y z = (x `plus` (y `plus` z)) =:= ((x `plus` y) `plus` z)

prop_add_comm :: Z -> Z -> Prop Z
prop_add_comm x y = (x `plus` y) =:= (y `plus` x)

prop_add_inv_left :: Z -> Prop Z
prop_add_inv_left x = neg x `plus` x =:= zero

prop_add_inv_right :: Z -> Prop Z
prop_add_inv_right x = x `plus` neg x =:= zero

-- Integer subtraction
(-.) :: Z -> Z -> Z
N m -. N n = n - m
N m -. P n = N (n + m)
P m -. N n = P (S (n + m))
P m -. P n = m - n

abs' :: Z -> Nat
abs' (P n) = n
abs' (N n) = S n

data Sign = Pos | Neg deriving (Eq,Show,Ord,Typeable)
{-
instance Names Sign where
    names _ = ["s","t","u"]-}

instance Arbitrary Sign where
  arbitrary = elements [Pos,Neg]

opposite :: Sign -> Sign
opposite Pos = Neg
opposite Neg = Pos

timesSigns :: Sign -> Sign -> Sign
Pos `timesSigns` x = x
Neg `timesSigns` x = opposite x

-- prop_sign_assoc :: Sign -> Sign -> Sign -> Prop Sign
-- prop_sign_assoc s t u = (s `timesSigns` (t `timesSigns` u)) =:= ((s `timesSigns` t) `timesSigns` u)
--
-- prop_sign_ident_left :: Sign -> Prop Sign
-- prop_sign_ident_left s = s `timesSigns` Pos =:= s
--
-- prop_sign_ident_right :: Sign -> Prop Sign
-- prop_sign_ident_right s = Pos `timesSigns` s =:= s
--
-- prop_sign_opposite_involutive :: Sign -> Prop Sign
-- prop_sign_opposite_involutive s = opposite (opposite s) =:= s
--
-- prop_sign_triple :: Sign -> Prop Sign
-- prop_sign_triple s = s `timesSigns` (s `timesSigns` s) =:= s

sign :: Z -> Sign
sign (P _) = Pos
sign (N _) = Neg

toInteger :: Sign -> Nat -> Z
Pos `toInteger` n     = P n
Neg `toInteger` Z     = P Z
Neg `toInteger` (S m) = N m

-- Integer multiplication
times :: Z -> Z -> Z
i `times` j = (sign i `timesSigns` sign j) `toInteger` (abs' i * abs' j)

one :: Z
one = P (S Z)

prop_mul_ident_left :: Z -> Prop Z
prop_mul_ident_left x = x =:= one `times` x

prop_mul_ident_right :: Z -> Prop Z
prop_mul_ident_right x = x =:= x `times` one

prop_mul_assoc :: Z -> Z -> Z -> Prop Z
prop_mul_assoc x y z = (x `times` (y `times` z)) =:= ((x `times` y) `times` z)

prop_mul_comm :: Z -> Z -> Prop Z
prop_mul_comm x y = (x `times` y) =:= (y `times` x)

prop_left_distrib :: Z -> Z -> Z -> Prop Z
prop_left_distrib x y z = x `times` (y `plus` z) =:= (x `times` y) `plus` (x `times` z)

prop_right_distrib :: Z -> Z -> Z -> Prop Z
prop_right_distrib x y z = (x `plus` y) `times` z =:= (x `times` z) `plus` (y `times` z)

{-
sig =
    [ vars ["x","y","z"] natType
     vars ["n","m","o"] intType
    , vars ["s","t","u"] signType
    , fun1 "P" P
    , fun1 "N" N
    , fun0 "Pos" Pos
    , fun0 "Neg" Neg
    , fun0 "Z" Z
    , fun1 "S" S
    , fun0 "zero" zero
    , fun0 "one"  one
    , fun2 "`toInteger`" toInteger
    , fun2 "+" (+)
    , fun2 "-" (-)
    , fun2 "*" (*)
    , fun2 "`plus`" plus
    , fun2 "-." (-.)
    , fun2 "`times`" times
    , fun2 "`timesSigns`" timesSigns
    , fun1 "opposite" opposite
    , fun1 "neg" neg
    , fun1 "abs'" abs'
    , fun1 "sign" sign
    ]
  where
    natType = (undefined :: Nat)
    intType = (undefined :: Z)
    signType = (undefined :: Sign)

-}
