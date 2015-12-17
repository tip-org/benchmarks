-- Turner's abstraction algorithm as defined by Simon PJ
-- (with properties added)

-- This is from the reach article and presumably true.
-- It is not adapted to TIP yet

import QuickCheck
import Monad

infixl 9 :@

data Var = V0 | V1
  deriving Show

data Exp = Exp :@ Exp | L Var Exp | V Var | F Comb
  deriving Show

data Comb = I | K | B | C | S | C' | B' | S'
  deriving Show

-- Instances

instance Eq Var where
  (==) V0 V0 = True
  (==) V1 V1 = True
  (==) _ _ = False

instance Eq Exp where
  (==) (f :@ a) (g :@ b) = f == g && a == b
  (==) (L v e) (L w f) = v == w && e == f
  (==) (V v) (V w) = v == w
  (==) (F c) (F d) = c == d

instance Eq Comb where
  (==) I I = True
  (==) K K = True
  (==) B B = True
  (==) C C = True
  (==) S S = True
  (==) C' C' = True
  (==) B' B' = True
  (==) S' S' = True
  (==) _ _ = False

instance Arbitrary Var where
  arbitrary = oneof [return V0, return V1]

instance Arbitrary Exp where
  arbitrary = sized exp
    where
      exp 0 = oneof [ liftM V arbitrary ]
      exp n = oneof [ liftM2 L arbitrary (exp (n `div` 2))
                    , liftM2 (:@) (exp (n `div` 2)) (exp (n `div` 2))
                    ]

instance Arbitrary Comb where
  arbitrary = oneof [ return I, return K, return B, return C
                    , return S, return C', return B', return S' ]

-- Compiler

compile (f :@ x) = compile f :@ compile x
compile (L v e) = abstr v (compile e)
compile e = e

abstr v (f :@ x) = opt (F S :@ abstr v f :@ abstr v x)
abstr v (V w) | v == w = F I
abstr v e = F K :@ e

opt (F S :@ (F K :@ p) :@ (F K :@ q)) = F K :@ (p :@ q)
opt (F S :@ (F K :@ p) :@ F I) = p
opt (F S :@ (F K :@ p) :@ (F B :@ q :@ r)) = F B' :@ p :@ q :@ r
opt (F S :@ (F K :@ p) :@ q) = F B :@ p :@ q
opt (F S :@ (F B :@ p :@ q) :@ (F K :@ r)) = F C' :@ p :@ q :@ r
opt (F S :@ p :@ (F K :@ q)) = F C :@ p :@ q
opt (F S :@ (F B :@ p :@ q) :@ r) = F S' :@ p :@ q :@ r
opt e = e

-- Combinator reduction

simp (F I :@ a) = Just a
simp (F K :@ a :@ b) = Just a
simp (F S :@ f :@ g :@ x) = Just (f :@ x :@ (g :@ x))
simp (F B :@ f :@ g :@ x) = Just (f :@ (g :@ x))
simp (F C :@ f :@ g :@ x) = Just (f :@ x :@ g)
simp (F B' :@ k :@ f :@ g :@ x) = Just (k :@ (f :@ (g :@ x)))
simp (F C' :@ k :@ f :@ g :@ x) = Just (k :@ (f :@ x) :@ g)
simp (F S' :@ k :@ f :@ g :@ x) = Just (k :@ (f :@ x) :@ (g :@ x))
simp e = Nothing

simplify e =
  case simp e of
    Nothing -> case e of
                 f :@ g -> simplify f :@ simplify g
                 _ -> e
    Just e' -> simplify e'

-- Helper

pure (f :@ a) = pure f && pure a
pure (L v e) = pure e
pure (V v) = True
pure (F c) = False

-- Properties

prop_abstr v e = pure e ==> simplify (abstr v e :@ V v) == e

main = quickCheck prop_abstr
