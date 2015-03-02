{-# LANGUAGE TemplateHaskell, DeriveDataTypeable #-}
module RegExp where

import Test.QuickCheck
import Test.QuickCheck.All
import Control.Monad ( liftM, liftM2 )
import HipSpec
import Prelude hiding (seq)

--------------------------------------------------------------------------------

data R
  = Nil
  | Eps
  | Atom A
  | R `Plus` R
  | R `Seq` R
  | Star R
 deriving ( Eq, Ord, Show, Typeable )

data A = X | Y deriving (Eq, Ord, Show, Typeable)

instance Arbitrary A where arbitrary = elements [X, Y]

plus, seq :: R -> R -> R
Nil `plus` q   = q
p   `plus` Nil = p
p   `plus` q   = p `Plus` q

Nil `seq` q   = Nil
p   `seq` Nil = Nil
Eps `seq` q   = q
p   `seq` Eps = p
p   `seq` q   = p `Seq` q

eps :: R -> Bool
eps Eps       = True
eps (p `Plus` q) = eps p || eps q
eps (p `Seq` q) = eps p && eps q
eps (Star _)  = True
eps _         = False

epsR :: R -> R
epsR p | eps p     = Eps
       | otherwise = Nil

step :: R -> A -> R
step (Atom a)  x | a `eqA` x = Eps
step (p `Plus` q) x          = step p x `plus` step q x
step (p `Seq` q) x          = (step p x `seq` q) `plus` (epsR p `seq` step q x)
step (Star p)  x          = step p x `seq` Star p
step _         x          = Nil

recognise :: R -> [A] -> Bool
recognise p []     = eps p
recognise p (x:xs) = recognise (step p x) xs

--------------------------------------------------------------------------------

prop_PlusIdempotent :: R -> [A] -> Prop Bool
prop_PlusIdempotent p s =
  recognise (p `Plus` p) s =:= recognise p s

prop_PlusCommutative :: R -> R -> [A] -> Prop Bool
prop_PlusCommutative p q s =
  recognise (p `Plus` q) s =:= recognise (q `Plus` p) s

prop_PlusAssociative :: R -> R -> R -> [A] -> Prop Bool
prop_PlusAssociative p q r s =
  recognise (p `Plus` (q `Plus` r)) s =:= recognise ((p `Plus` q) `Plus` r) s

prop_SeqAssociative :: R -> R -> R -> [A] -> Prop Bool
prop_SeqAssociative p q r s =
  recognise (p `Seq` (q `Seq` r)) s =:= recognise ((p `Seq` q) `Seq` r) s

prop_SeqDistrPlus :: R -> R -> R -> [A] -> Prop Bool
prop_SeqDistrPlus p q r s =
  recognise (p `Seq` (q `Plus` r)) s =:= recognise ((p `Seq` q) `Plus` (p `Seq` r)) s

prop_Star :: R -> [A] -> Prop Bool
prop_Star p s =
  recognise (Star p) s =:= recognise (Eps `Plus` (p `Seq` Star p)) s

--------------------------------------------------------------------------------

eqA :: A -> A -> Bool
X `eqX` X = True
Y `eqA` Y = True
_ `eqA` _ = False

eqList :: [A] -> [A] -> Bool
[] `eqList` [] = True
(x:xs) `eqList` (y:ys) = x `eqA` y && xs `eqList` ys
_ `eqList` _ = False

prop_RecAtom a s =
  recognise (Atom a) s =:= (s `eqList` [a])

prop_RecEps s =
  recognise Eps s =:= null s

prop_RecNil s =
  recognise Nil s =:= False

prop_RecPlus p q s =
  recognise (p `Plus` q) s =:= recognise p s || recognise q s

prop_RecSeq p q s =
  recognise (p `Seq` q) s =:= recognisePair p q (split s)

recognisePair :: R -> R -> [([A], [A])] -> Bool
recognisePair p q [] = False
recognisePair p q ((s1,s2):xs) = (recognise p s1 && recognise q s2) || recognisePair p q xs

split :: [a] -> [([a], [a])]
split []    = [([],[])]
split (x:s) = ([],x:s): consfst x (split s)

consfst :: a -> [([a], b)] -> [([a], b)]
consfst x [] = []
consfst x ((xs, y):ys) = (x:xs, y):consfst x ys

prop_RecStar p s =
  recognise (Star p) s =:= null s || recognise (p `Seq` Star p) s

--------------------------------------------------------------------------------

deeps :: R -> R
deeps Nil          = Nil
deeps Eps          = Nil
deeps (Atom a)     = Atom a
deeps (p `Plus` q)    = deeps p `Plus` deeps q
deeps (p `Seq` q)
  | eps p && eps q = deeps p `Plus` deeps q
  | otherwise      = p `Seq` q
deeps (Star p)     = deeps p

prop_Deeps p s =
  recognise (Star p) s =:= recognise (Star (deeps p)) s

--------------------------------------------------------------------------------

instance Arbitrary R where
  arbitrary = sized arbR
   where
    arbR n = frequency
             [ (n, liftM2 Plus (arbR n2) (arbR n2))
             , (n, liftM2 Seq (arbR n2) (arbR n2))
             , (n, liftM  Star  (arbR n2))
             , (1, return Nil)
             , (1, return Eps)
             , (1, liftM  Atom arbitrary)
             ]
     where
      n2 = n `div` 2

  shrink (p `Plus` q) = [p,q] ++ [p' `Plus` q | p' <- shrink p] ++ [p `Plus` q' | q' <- shrink q]
  shrink (p `Seq` q) = [p,q] ++ [p' `Seq` q | p' <- shrink p] ++ [p `Seq` q' | q' <- shrink q]
  shrink (Star p)  = [Eps,p] ++ [Star p' | p' <- shrink p]
  shrink Nil       = []
  shrink Eps       = [Nil]
  shrink (Atom a)  = [Eps,Nil] ++ [Atom a' | a' <- shrink a]

return []
testAll = $(quickCheckAll)

--------------------------------------------------------------------------------

