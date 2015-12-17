-- Buggy simplification on an expression datatype
module ExprSimp where

import Tip.Prelude
import qualified Prelude as P
import qualified Test.QuickCheck as Q
import qualified Control.Monad as M

type V = Nat

data E
  = N Nat
  | Add E E
  | Mul E E
  | Div E E
  | Eq E E
  | V V
 deriving ( P.Show )

eqE :: E -> E -> Bool
eqE (N a)       (N b)       = a == b
eqE (V a)       (V b)       = a == b
eqE (Add a1 a2) (Add b1 b2) = (a1 `eqE` b1) && (a2 `eqE` b2)
eqE (Mul a1 a2) (Mul b1 b2) = (a1 `eqE` b1) && (a2 `eqE` b2)
eqE (Eq a1 a2)  (Eq b1 b2)  = (a1 `eqE` b1) && (a2 `eqE` b2)
eqE _           _           = False

div :: Nat -> Nat -> Nat
div x Z = Z -- arbitrary
div x y = divv x y Z
 where
  divv Z y z = z
  divv x y z = divv (x - y) y (S z)

type State = [Nat]

fetch :: State -> V -> Nat
fetch []     _     = Z
fetch (n:st) Z     = n
fetch (_:st) (S x) = fetch st x

store :: State -> V -> Nat -> State
store []     Z     m = [m]
store []     (S x) m = Z : store [] x m
store (n:st) Z     m = m : st
store (n:st) (S x) m = n : store st x m

eval :: State -> E -> V
eval st (N n)     = n
eval st (V x)     = fetch st x
eval st (Add a b) = eval st a + eval st b
eval st (Mul a b) = eval st a * eval st b
eval st (Div a b) = eval st a `div` eval st b
eval st (Eq a b)  = if eval st a == eval st b then S Z else Z

---

simp1 :: E -> E
simp1 (Add a b) = step1 (Add (simp1 a) (simp1 b))
simp1 (Mul a b) = step1 (Mul (simp1 a) (simp1 b))
simp1 (Eq  a b) = step1 (Eq (simp1 a) (simp1 b))
simp1 a         = step1 a

step1 :: E -> E
step1 (Add (N Z) b) = b
step1 (Add a (N Z)) = a
step1 (Add a b) | a `eqE` b = Mul (N (S (S Z))) a
step1 (Add (V x) (V y)) | x == x = Mul (N (S (S Z))) (V x)
step1 (Eq a b)  | a `eqE` b = N (S Z)
step1 (Mul (N Z) b) = N Z
step1 (Mul a (N Z)) = N Z
step1 (Mul (N (S Z)) b) = b
step1 (Mul a (N (S Z))) = a
--step1 (Div a b) | a `eqE` b = N (S Z)
--step1 (Div (Mul a b) c) | b `eqE` c && not (c `eqE` N Z) = a
step1 (Add (Add a b) c) = Add a (Add b c)
step1 (Mul (Mul a b) c) = Mul a (Mul b c)
step1 a             = a

target_1 st a = (eval st a == eval st (simp1 a)) === True

---

simp2 :: E -> E
simp2 (Add a b) = step2 (Add (simp2 a) (simp2 b))
simp2 (Mul a b) = step2 (Mul (simp2 a) (simp2 b))
simp2 (Eq  a b) = step2 (Eq (simp2 a) (simp2 b))
simp2 a         = step2 a

step2 :: E -> E
step2 (Add (N Z) b) = b
step2 (Add a (N Z)) = a
step2 (Add a b) | a `eqE` b = Mul (N (S (S Z))) a
--step2 (Add (V x) (V y)) | x == x = Mul (N (S (S Z))) (V x)
step2 (Eq a b)  | a `eqE` b = N (S Z)
step2 (Mul (N Z) b) = N Z
step2 (Mul a (N Z)) = N Z
step2 (Mul (N (S Z)) b) = b
step2 (Mul a (N (S Z))) = a
step2 (Div a b) | a `eqE` b = N (S Z)
--step2 (Div (Mul a b) c) | b `eqE` c && not (c `eqE` N Z) = a
step2 (Add (Add a b) c) = Add a (Add b c)
step2 (Mul (Mul a b) c) = Mul a (Mul b c)
step2 a             = a

target_2 st a = (eval st a == eval st (simp2 a)) === True

---

simp3 :: E -> E
simp3 (Add a b) = step3 (Add (simp3 a) (simp3 b))
simp3 (Mul a b) = step3 (Mul (simp3 a) (simp3 b))
simp3 (Eq  a b) = step3 (Eq (simp3 a) (simp3 b))
simp3 a         = step3 a

step3 :: E -> E
step3 (Add (N Z) b) = b
step3 (Add a (N Z)) = a
step3 (Add a b) | a `eqE` b = Mul (N (S (S Z))) a
--step3 (Add (V x) (V y)) | x == x = Mul (N (S (S Z))) (V x)
step3 (Eq a b)  | a `eqE` b = N (S Z)
step3 (Mul (N Z) b) = N Z
step3 (Mul a (N Z)) = N Z
step3 (Mul (N (S Z)) b) = b
step3 (Mul a (N (S Z))) = a
--step3 (Div a b) | a `eqE` b = N (S Z)
step3 (Div (Mul a b) c) | b `eqE` c && not (c `eqE` N Z) = a
step3 (Add (Add a b) c) = Add a (Add b c)
step3 (Mul (Mul a b) c) = Mul a (Mul b c)
step3 a             = a

target_3 st a = (eval st a == eval st (simp3 a)) === True

---

simp4 :: E -> E
simp4 (Add a b) = step4 (Add (simp4 a) (simp4 b))
simp4 (Mul a b) = step4 (Mul (simp4 a) (simp4 b))
simp4 (Eq  a b) = step4 (Eq (simp4 a) (simp4 b))
simp4 a         = step4 a

step4 :: E -> E
step4 (Add (N Z) b) = b
step4 (Add a (N Z)) = a
step4 (Add a b) | a `eqE` b = Mul (N (S (S Z))) a
--step4 (Add (V x) (V y)) | x == x = Mul (N (S (S Z))) (V x)
step4 (Eq a b)  | a `eqE` b = N (S Z)
step4 (Mul (N Z) b) = N Z
step4 (Mul a (N Z)) = N Z
step4 (Mul (N (S Z)) b) = b
step4 (Mul a (N (S Z))) = a
--step4 (Div a b) | a `eqE` b = N (S Z)
step4 (Div (Mul a b) c) | b `eqE` c && not (c `eqE` N Z) && not (isVar c) = a
step4 (Add (Add a b) c) = Add a (Add b c)
step4 (Mul (Mul a b) c) = Mul a (Mul b c)
step4 a             = a

isVar (V _) = True
isVar _     = False

target_4 st a = (eval st a == eval st (simp4 a)) === True

---

instance Q.Arbitrary Nat where
  arbitrary =
    do x <- Q.choose (0,10)
       P.return (conv (P.abs (x :: P.Int)))
   where
    conv 0 = Z
    conv n = S (conv (n P.- 1))

instance Q.Arbitrary E where
  arbitrary = Q.sized arbE
   where
    arbE n = frequency
      [ (n, M.liftM2 Add arb2 arb2)
      , (n, M.liftM2 Mul arb2 arb2)
      , (n, M.liftM2 Eq  arb2 arb2)
      , (n, M.liftM2 Div arb2 arb2)
      , (1, M.liftM  V   Q.arbitrary)
      , (1, M.liftM  N   Q.arbitrary)
      ]
     where
      arb2 = arbE (n `P.div` 2)

