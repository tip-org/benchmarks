{-# LANGUAGE CPP #-}
module Tree where

import Tip.Prelude hiding (ordered)
import qualified Prelude

data Tree a = B (Tree a) a (Tree a) | E

height :: Tree a -> Nat
height (B t1 _ t2) = S (height t1 `max` height t2)
height E           = Z

size :: Tree a -> Nat
size (B t1 _ t2) = S (size t1 + size t2)
size E           = Z

prop_height_size t = bool (height t <= size t)

balanced :: Tree a -> Bool
balanced t = bal t <= S (S Z)

diff x Z = x
diff Z y = y
diff (S x) (S y) = diff x y

bal (B t1 _ t2) = diff (height t1) (height t2) + bal t1 + bal t2
bal E = Z

perfect :: Tree a -> Bool
perfect (B t1 _ t2) = height t1 == height t2 && perfect t1 && perfect t2
perfect E           = True

prop_perfect_bal t = (bal t == Z) === perfect t

flatten :: Tree a -> [a]
flatten (B t1 x t2) = flatten t1 ++ [x] ++ flatten t2
flatten E           = []

ordered :: Tree Nat -> Bool
ordered = uniqsorted . flatten

member :: Nat -> Tree Nat -> Bool
member x (B l y r)
  | x < y     = x `member` l
  | x > y     = x `member` r
  | otherwise = True
member x E = False

prop_member x t = ordered t ==> x `elem` flatten t === x `member` t

evens :: Nat -> [Nat]
evens Z = []
evens (S n) = double n : evens n

odds :: Nat -> [Nat]
odds Z = []
odds (S n) = S (double n) : odds n

enum :: Nat -> [Nat]
enum Z     = []
enum (S n) = n : enum n

members :: [Nat] -> Tree Nat -> Bool
members (x:xs) t = x `member` t && xs `members` t
members []     t = True

notMembers :: [Nat] -> Tree Nat -> Bool
notMembers (x:xs) t = not (x `member` t) && xs `notMembers` t
notMembers []     t = True

allEven :: Tree Nat -> Bool
allEven (B l x r) = even x && allEven l && allEven r
allEven E         = True


#define n0 Z
#define n1 (S n0)
#define n2 (S n1)
#define n3 (S n2)
#define n4 (S n3)
#define n5 (S n4)
#define n6 (S n5)
#define n7 (S n6)
#define n8 (S n7)
#define n9 (S n8)
#define n10 (S n9)
#define n11 (S n10)
#define n12 (S n11)
#define n13 (S n12)
#define n14 (S n13)
#define n15 (S n14)
#define n16 (S n15)
#define n17 (S n16)
#define n18 (S n17)
#define n19 (S n18)
#define n20 (S n19)
#define n21 (S n20)
#define n22 (S n21)
#define n23 (S n22)
#define n24 (S n23)
#define n25 (S n24)
#define n26 (S n25)
#define n27 (S n26)
#define n28 (S n27)
#define n29 (S n28)

sat_even_members_02 t = question (balanced t .&&. ordered t .&&. evens n2 `members` t)
sat_even_members_03 t = question (balanced t .&&. ordered t .&&. evens n3 `members` t)
sat_even_members_04 t = question (balanced t .&&. ordered t .&&. evens n4 `members` t)
sat_even_members_05 t = question (balanced t .&&. ordered t .&&. evens n5 `members` t)
sat_even_members_06 t = question (balanced t .&&. ordered t .&&. evens n6 `members` t)
sat_even_members_07 t = question (balanced t .&&. ordered t .&&. evens n7 `members` t)
sat_even_members_08 t = question (balanced t .&&. ordered t .&&. evens n8 `members` t)
sat_even_members_09 t = question (balanced t .&&. ordered t .&&. evens n9 `members` t)
sat_even_members_10 t = question (balanced t .&&. ordered t .&&. evens n10 `members` t)
sat_even_members_11 t = question (balanced t .&&. ordered t .&&. evens n11 `members` t)
sat_even_members_12 t = question (balanced t .&&. ordered t .&&. evens n12 `members` t)
sat_even_members_13 t = question (balanced t .&&. ordered t .&&. evens n13 `members` t)
sat_even_members_14 t = question (balanced t .&&. ordered t .&&. evens n14 `members` t)

sat_enum_members_02 t = question (balanced t .&&. ordered t .&&. enum n2 `members` t)
sat_enum_members_03 t = question (balanced t .&&. ordered t .&&. enum n3 `members` t)
sat_enum_members_04 t = question (balanced t .&&. ordered t .&&. enum n4 `members` t)
sat_enum_members_05 t = question (balanced t .&&. ordered t .&&. enum n5 `members` t)
sat_enum_members_06 t = question (balanced t .&&. ordered t .&&. enum n6 `members` t)
sat_enum_members_07 t = question (balanced t .&&. ordered t .&&. enum n7 `members` t)
sat_enum_members_08 t = question (balanced t .&&. ordered t .&&. enum n8 `members` t)
sat_enum_members_09 t = question (balanced t .&&. ordered t .&&. enum n9 `members` t)
sat_enum_members_10 t = question (balanced t .&&. ordered t .&&. enum n10 `members` t)
sat_enum_members_11 t = question (balanced t .&&. ordered t .&&. enum n11 `members` t)
sat_enum_members_12 t = question (balanced t .&&. ordered t .&&. enum n12 `members` t)
sat_enum_members_13 t = question (balanced t .&&. ordered t .&&. enum n13 `members` t)
sat_enum_members_14 t = question (balanced t .&&. ordered t .&&. enum n14 `members` t)

sat_even_members_odd_nonmembers_02 t = question (balanced t .&&. ordered t .&&. evens n2 `members` t .&&. odds n2 `notMembers` t)
sat_even_members_odd_nonmembers_03 t = question (balanced t .&&. ordered t .&&. evens n3 `members` t .&&. odds n3 `notMembers` t)
sat_even_members_odd_nonmembers_04 t = question (balanced t .&&. ordered t .&&. evens n4 `members` t .&&. odds n4 `notMembers` t)
sat_even_members_odd_nonmembers_05 t = question (balanced t .&&. ordered t .&&. evens n5 `members` t .&&. odds n5 `notMembers` t)
sat_even_members_odd_nonmembers_06 t = question (balanced t .&&. ordered t .&&. evens n6 `members` t .&&. odds n6 `notMembers` t)
sat_even_members_odd_nonmembers_07 t = question (balanced t .&&. ordered t .&&. evens n7 `members` t .&&. odds n7 `notMembers` t)
sat_even_members_odd_nonmembers_08 t = question (balanced t .&&. ordered t .&&. evens n8 `members` t .&&. odds n8 `notMembers` t)
sat_even_members_odd_nonmembers_09 t = question (balanced t .&&. ordered t .&&. evens n9 `members` t .&&. odds n9 `notMembers` t)
sat_even_members_odd_nonmembers_10 t = question (balanced t .&&. ordered t .&&. evens n10 `members` t .&&. odds n10 `notMembers` t)
sat_even_members_odd_nonmembers_11 t = question (balanced t .&&. ordered t .&&. evens n11 `members` t .&&. odds n11 `notMembers` t)
sat_even_members_odd_nonmembers_12 t = question (balanced t .&&. ordered t .&&. evens n12 `members` t .&&. odds n12 `notMembers` t)
sat_even_members_odd_nonmembers_13 t = question (balanced t .&&. ordered t .&&. evens n13 `members` t .&&. odds n13 `notMembers` t)
sat_even_members_odd_nonmembers_14 t = question (balanced t .&&. ordered t .&&. evens n14 `members` t .&&. odds n14 `notMembers` t)

sat_size_odd_nonmembers_02 t = question (balanced t .&&. ordered t .&&. size t == n2 .&&. odds n2 `notMembers` t)
sat_size_odd_nonmembers_03 t = question (balanced t .&&. ordered t .&&. size t == n3 .&&. odds n3 `notMembers` t)
sat_size_odd_nonmembers_04 t = question (balanced t .&&. ordered t .&&. size t == n4 .&&. odds n4 `notMembers` t)
sat_size_odd_nonmembers_05 t = question (balanced t .&&. ordered t .&&. size t == n5 .&&. odds n5 `notMembers` t)
sat_size_odd_nonmembers_06 t = question (balanced t .&&. ordered t .&&. size t == n6 .&&. odds n6 `notMembers` t)
sat_size_odd_nonmembers_07 t = question (balanced t .&&. ordered t .&&. size t == n7 .&&. odds n7 `notMembers` t)
sat_size_odd_nonmembers_08 t = question (balanced t .&&. ordered t .&&. size t == n8 .&&. odds n8 `notMembers` t)
sat_size_odd_nonmembers_09 t = question (balanced t .&&. ordered t .&&. size t == n9 .&&. odds n9 `notMembers` t)
sat_size_odd_nonmembers_10 t = question (balanced t .&&. ordered t .&&. size t == n10 .&&. odds n10 `notMembers` t)
sat_size_odd_nonmembers_11 t = question (balanced t .&&. ordered t .&&. size t == n11 .&&. odds n11 `notMembers` t)
sat_size_odd_nonmembers_12 t = question (balanced t .&&. ordered t .&&. size t == n12 .&&. odds n12 `notMembers` t)
sat_size_odd_nonmembers_13 t = question (balanced t .&&. ordered t .&&. size t == n13 .&&. odds n13 `notMembers` t)
sat_size_odd_nonmembers_14 t = question (balanced t .&&. ordered t .&&. size t == n14 .&&. odds n14 `notMembers` t)

sat_size_even_pred_02 t = question (balanced t .&&. ordered t .&&. size t == n2 .&&. allEven t)
sat_size_even_pred_03 t = question (balanced t .&&. ordered t .&&. size t == n3 .&&. allEven t)
sat_size_even_pred_04 t = question (balanced t .&&. ordered t .&&. size t == n4 .&&. allEven t)
sat_size_even_pred_05 t = question (balanced t .&&. ordered t .&&. size t == n5 .&&. allEven t)
sat_size_even_pred_06 t = question (balanced t .&&. ordered t .&&. size t == n6 .&&. allEven t)
sat_size_even_pred_07 t = question (balanced t .&&. ordered t .&&. size t == n7 .&&. allEven t)
sat_size_even_pred_08 t = question (balanced t .&&. ordered t .&&. size t == n8 .&&. allEven t)
sat_size_even_pred_09 t = question (balanced t .&&. ordered t .&&. size t == n9 .&&. allEven t)
sat_size_even_pred_10 t = question (balanced t .&&. ordered t .&&. size t == n10 .&&. allEven t)
sat_size_even_pred_11 t = question (balanced t .&&. ordered t .&&. size t == n11 .&&. allEven t)
sat_size_even_pred_12 t = question (balanced t .&&. ordered t .&&. size t == n12 .&&. allEven t)
sat_size_even_pred_13 t = question (balanced t .&&. ordered t .&&. size t == n13 .&&. allEven t)
sat_size_even_pred_14 t = question (balanced t .&&. ordered t .&&. size t == n14 .&&. allEven t)

sat_perfect_size_even_pred_03 t = question (perfect t .&&. ordered t .&&. size t == n3 .&&. allEven t)
sat_perfect_size_even_pred_07 t = question (perfect t .&&. ordered t .&&. size t == n7 .&&. allEven t)
sat_perfect_size_even_pred_15 t = question (perfect t .&&. ordered t .&&. size t == n15 .&&. allEven t)

sat_perfect_size_03 t = question (perfect t .&&. ordered t .&&. size t == n3)
sat_perfect_size_07 t = question (perfect t .&&. ordered t .&&. size t == n7)
sat_perfect_size_15 t = question (perfect t .&&. ordered t .&&. size t == n15)

sat_perfect_unordered_size_03 t = question (perfect t .&&. size t == n3)
sat_perfect_unordered_size_07 t = question (perfect t .&&. size t == n7)
sat_perfect_unordered_size_15 t = question (perfect t .&&. size t == n15)

sat_perfect_unordered_height_02 t = question (perfect t .&&. height t == n2)
sat_perfect_unordered_height_03 t = question (perfect t .&&. height t == n3)
sat_perfect_unordered_height_04 t = question (perfect t .&&. height t == n4)
sat_perfect_unordered_height_05 t = question (perfect t .&&. height t == n5)
sat_perfect_unordered_height_06 t = question (perfect t .&&. height t == n6)
sat_perfect_unordered_height_07 t = question (perfect t .&&. height t == n7)
sat_perfect_unordered_height_08 t = question (perfect t .&&. height t == n8)
sat_perfect_unordered_height_09 t = question (perfect t .&&. height t == n9)
sat_perfect_unordered_height_10 t = question (perfect t .&&. height t == n10)
sat_perfect_unordered_height_11 t = question (perfect t .&&. height t == n11)
sat_perfect_unordered_height_12 t = question (perfect t .&&. height t == n12)
sat_perfect_unordered_height_13 t = question (perfect t .&&. height t == n13)
sat_perfect_unordered_height_14 t = question (perfect t .&&. height t == n14)

sat_balanced_unordered_size_02 t = question (balanced t .&&. size t == n2)
sat_balanced_unordered_size_03 t = question (balanced t .&&. size t == n3)
sat_balanced_unordered_size_04 t = question (balanced t .&&. size t == n4)
sat_balanced_unordered_size_05 t = question (balanced t .&&. size t == n5)
sat_balanced_unordered_size_06 t = question (balanced t .&&. size t == n6)
sat_balanced_unordered_size_07 t = question (balanced t .&&. size t == n7)
sat_balanced_unordered_size_08 t = question (balanced t .&&. size t == n8)
sat_balanced_unordered_size_09 t = question (balanced t .&&. size t == n9)
sat_balanced_unordered_size_10 t = question (balanced t .&&. size t == n10)
sat_balanced_unordered_size_11 t = question (balanced t .&&. size t == n11)
sat_balanced_unordered_size_12 t = question (balanced t .&&. size t == n12)
sat_balanced_unordered_size_13 t = question (balanced t .&&. size t == n13)
sat_balanced_unordered_size_14 t = question (balanced t .&&. size t == n14)
sat_balanced_unordered_size_15 t = question (balanced t .&&. size t == n15)
sat_balanced_unordered_size_16 t = question (balanced t .&&. size t == n16)
sat_balanced_unordered_size_17 t = question (balanced t .&&. size t == n17)
sat_balanced_unordered_size_18 t = question (balanced t .&&. size t == n18)
sat_balanced_unordered_size_19 t = question (balanced t .&&. size t == n19)
sat_balanced_unordered_size_20 t = question (balanced t .&&. size t == n20)
sat_balanced_unordered_size_21 t = question (balanced t .&&. size t == n21)
sat_balanced_unordered_size_22 t = question (balanced t .&&. size t == n22)
sat_balanced_unordered_size_23 t = question (balanced t .&&. size t == n23)
sat_balanced_unordered_size_24 t = question (balanced t .&&. size t == n24)
sat_balanced_unordered_size_25 t = question (balanced t .&&. size t == n25)
sat_balanced_unordered_size_26 t = question (balanced t .&&. size t == n26)
sat_balanced_unordered_size_27 t = question (balanced t .&&. size t == n27)
sat_balanced_unordered_size_28 t = question (balanced t .&&. size t == n28)
sat_balanced_unordered_size_29 t = question (balanced t .&&. size t == n29)

sat_balanced_unordered_height_02 t = question (balanced t .&&. height t == n2)
sat_balanced_unordered_height_03 t = question (balanced t .&&. height t == n3)
sat_balanced_unordered_height_04 t = question (balanced t .&&. height t == n4)
sat_balanced_unordered_height_05 t = question (balanced t .&&. height t == n5)
sat_balanced_unordered_height_06 t = question (balanced t .&&. height t == n6)
sat_balanced_unordered_height_07 t = question (balanced t .&&. height t == n7)
sat_balanced_unordered_height_08 t = question (balanced t .&&. height t == n8)
sat_balanced_unordered_height_09 t = question (balanced t .&&. height t == n9)
sat_balanced_unordered_height_10 t = question (balanced t .&&. height t == n10)
sat_balanced_unordered_height_11 t = question (balanced t .&&. height t == n11)
sat_balanced_unordered_height_12 t = question (balanced t .&&. height t == n12)
sat_balanced_unordered_height_13 t = question (balanced t .&&. height t == n13)
sat_balanced_unordered_height_14 t = question (balanced t .&&. height t == n14)

sat_perfect_height_02 t = question (perfect t .&&. ordered t .&&. height t == n2)
sat_perfect_height_03 t = question (perfect t .&&. ordered t .&&. height t == n3)
sat_perfect_height_04 t = question (perfect t .&&. ordered t .&&. height t == n4)
sat_perfect_height_05 t = question (perfect t .&&. ordered t .&&. height t == n5)
sat_perfect_height_06 t = question (perfect t .&&. ordered t .&&. height t == n6)
sat_perfect_height_07 t = question (perfect t .&&. ordered t .&&. height t == n7)
sat_perfect_height_08 t = question (perfect t .&&. ordered t .&&. height t == n8)
sat_perfect_height_09 t = question (perfect t .&&. ordered t .&&. height t == n9)
sat_perfect_height_10 t = question (perfect t .&&. ordered t .&&. height t == n10)
