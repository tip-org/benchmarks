-- Regular expressions using Brzozowski derivatives (see the step function)
-- The plus and seq functions are smart constructors.
module RegExp where

import Tip
import Prelude hiding (seq)

--------------------------------------------------------------------------------

data R
  = Nil
  | Eps
  | Atom A
  | R `Plus` R
  | R `Seq` R
  | Star R

data A = X | Y

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

rev :: R -> R
rev (a `Plus` b) = rev a `Plus` rev b
rev (a `Seq` b)  = rev b `Seq` rev a
rev (Star a)     = Star (rev a)
rev a            = a

--------------------------------------------------------------------------------

prop_Reverse :: R -> [A] -> Equality Bool
prop_Reverse r s = recognise (rev r) s === recognise r (reverse s)

prop_PlusIdempotent :: R -> [A] -> Equality Bool
prop_PlusIdempotent p s =
  recognise (p `Plus` p) s === recognise p s

prop_PlusCommutative :: R -> R -> [A] -> Equality Bool
prop_PlusCommutative p q s =
  recognise (p `Plus` q) s === recognise (q `Plus` p) s

prop_PlusAssociative :: R -> R -> R -> [A] -> Equality Bool
prop_PlusAssociative p q r s =
  recognise (p `Plus` (q `Plus` r)) s === recognise ((p `Plus` q) `Plus` r) s

prop_SeqAssociative :: R -> R -> R -> [A] -> Equality Bool
prop_SeqAssociative p q r s =
  recognise (p `Seq` (q `Seq` r)) s === recognise ((p `Seq` q) `Seq` r) s

prop_SeqDistrPlus :: R -> R -> R -> [A] -> Equality Bool
prop_SeqDistrPlus p q r s =
  recognise (p `Seq` (q `Plus` r)) s === recognise ((p `Seq` q) `Plus` (p `Seq` r)) s

prop_Star :: R -> [A] -> Equality Bool
prop_Star p s =
  recognise (Star p) s === recognise (Eps `Plus` (p `Seq` Star p)) s

--------------------------------------------------------------------------------

eqA :: A -> A -> Bool
X `eqA` X = True
Y `eqA` Y = True
_ `eqA` _ = False

eqList :: [A] -> [A] -> Bool
[] `eqList` [] = True
(x:xs) `eqList` (y:ys) = x `eqA` y && xs `eqList` ys
_ `eqList` _ = False

prop_RecAtom a s =
  recognise (Atom a) s === (s `eqList` [a])

prop_RecEps s =
  recognise Eps s === null s

prop_RecNil s =
  recognise Nil s === False

prop_RecPlus p q s =
  recognise (p `Plus` q) s === (recognise p s || recognise q s)

prop_RecSeq p q s =
  recognise (p `Seq` q) s === or [ recognise p s1 && recognise q s2  | (s1,s2) <- split s ]

split :: [a] -> [([a], [a])]
split []    = [([],[])]
split (x:s) = ([],x:s):[ (x:xs,ys) | (xs,ys) <- split s ]

prop_RecStar p s =
  recognise (Star p) s === (null s || recognise (p `Seq` Star p) s)

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
  recognise (Star p) s === recognise (Star (deeps p)) s

