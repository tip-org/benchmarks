module Expr where

import Tip

type V = Integer

data E
  = N Integer
  | Add E E
  | Mul E E
  | Div E E
  | Eq E E
  | V V
  deriving Eq

type State = [Integer]

fetch :: State -> V -> Integer
fetch []     _     = 0
fetch (n:st) 0     = n
fetch (_:st) x = fetch st (pred x)

store :: State -> V -> Integer -> State
store []     0     m = [m]
store []     x m = 0 : store [] (pred x) m
store (n:st) 0     m = m : st
store (n:st) x     m = n : store st (pred x) m

eval :: State -> E -> V
eval st (N n)     = n
eval st (V x)     = fetch st x
eval st (Add a b) = eval st a + eval st b
eval st (Mul a b) = eval st a * eval st b
eval st (Div a b) = eval st a `div` eval st b
eval st (Eq a b)  = if eval st a == eval st b then 1 else 0

---

simp1 :: E -> E
simp1 (Add a b) = step1 (Add (simp1 a) (simp1 b))
simp1 (Mul a b) = step1 (Mul (simp1 a) (simp1 b))
simp1 (Eq  a b) = step1 (Eq (simp1 a) (simp1 b))
simp1 a         = step1 a

step1 :: E -> E
step1 (Add (N 0) b) = b
step1 (Add a (N 0)) = a
step1 (Add a b) | a == b = Mul (N 2) a
step1 (Add (V x) (V y)) | x == x = Mul (N 2) (V x)
step1 (Eq a b)  | a == b = N 1
step1 (Mul (N 0) b) = N 0
step1 (Mul a (N 0)) = N 0
step1 (Mul (N 1) b) = b
step1 (Mul a (N 1)) = a
--step1 (Div a b) | a == b = N 1
--step1 (Div (Mul a b) c) | b == c && not (c == N 0) = a
step1 (Add (Add a b) c) = Add a (Add b c)
step1 (Mul (Mul a b) c) = Mul a (Mul b c)
step1 a             = a

prop1 st a = (eval st a == eval st (simp1 a)) === True

---

simp2 :: E -> E
simp2 (Add a b) = step2 (Add (simp2 a) (simp2 b))
simp2 (Mul a b) = step2 (Mul (simp2 a) (simp2 b))
simp2 (Eq  a b) = step2 (Eq (simp2 a) (simp2 b))
simp2 a         = step2 a

step2 :: E -> E
step2 (Add (N 0) b) = b
step2 (Add a (N 0)) = a
step2 (Add a b) | a == b = Mul (N 2) a
--step2 (Add (V x) (V y)) | x == x = Mul (N 2) (V x)
step2 (Eq a b)  | a == b = N 1
step2 (Mul (N 0) b) = N 0
step2 (Mul a (N 0)) = N 0
step2 (Mul (N 1) b) = b
step2 (Mul a (N 1)) = a
step2 (Div a b) | a == b = N 1
--step2 (Div (Mul a b) c) | b == c && not (c == N 0) = a
step2 (Add (Add a b) c) = Add a (Add b c)
step2 (Mul (Mul a b) c) = Mul a (Mul b c)
step2 a             = a

prop2 st a = (eval st a == eval st (simp2 a)) === True

---

simp3 :: E -> E
simp3 (Add a b) = step3 (Add (simp3 a) (simp3 b))
simp3 (Mul a b) = step3 (Mul (simp3 a) (simp3 b))
simp3 (Eq  a b) = step3 (Eq (simp3 a) (simp3 b))
simp3 a         = step3 a

step3 :: E -> E
step3 (Add (N 0) b) = b
step3 (Add a (N 0)) = a
step3 (Add a b) | a == b = Mul (N 2) a
--step3 (Add (V x) (V y)) | x == x = Mul (N 2) (V x)
step3 (Eq a b)  | a == b = N 1
step3 (Mul (N 0) b) = N 0
step3 (Mul a (N 0)) = N 0
step3 (Mul (N 1) b) = b
step3 (Mul a (N 1)) = a
--step3 (Div a b) | a == b = N 1
step3 (Div (Mul a b) c) | b == c && not (c == N 0) = a
step3 (Add (Add a b) c) = Add a (Add b c)
step3 (Mul (Mul a b) c) = Mul a (Mul b c)
step3 a             = a

prop3 st a = (eval st a == eval st (simp3 a)) === True

---

simp4 :: E -> E
simp4 (Add a b) = step4 (Add (simp4 a) (simp4 b))
simp4 (Mul a b) = step4 (Mul (simp4 a) (simp4 b))
simp4 (Eq  a b) = step4 (Eq (simp4 a) (simp4 b))
simp4 a         = step4 a

step4 :: E -> E
step4 (Add (N 0) b) = b
step4 (Add a (N 0)) = a
step4 (Add a b) | a == b = Mul (N 2) a
--step4 (Add (V x) (V y)) | x == x = Mul (N 2) (V x)
step4 (Eq a b)  | a == b = N 1
step4 (Mul (N 0) b) = N 0
step4 (Mul a (N 0)) = N 0
step4 (Mul (N 1) b) = b
step4 (Mul a (N 1)) = a
--step4 (Div a b) | a == b = N 1
step4 (Div (Mul a b) c) | b == c && not (c == N 0) && not (isVar c) = a
step4 (Add (Add a b) c) = Add a (Add b c)
step4 (Mul (Mul a b) c) = Mul a (Mul b c)
step4 a             = a

isVar (V _) = True
isVar _     = False

prop4 st a = (eval st a == eval st (simp4 a)) === True
