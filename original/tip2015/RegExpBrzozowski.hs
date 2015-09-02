-- Regular expressions using Brzozowski derivatives (see the step function)
-- This version does not use smart constructors.
module RegExpBrzozowski where

import Tip.Prelude hiding (eqList)
import qualified Prelude as P

import RegExp

--------------------------------------------------------------------------------

plus, seq :: R -> R -> R
plus = Plus
seq  = Seq

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
deeps (p `Plus` q) = deeps p `Plus` deeps q
deeps (p `Seq` q)
  | eps p && eps q = deeps p `Plus` deeps q
  | otherwise      = p `Seq` q
deeps (Star p)     = deeps p

prop_Deeps p s =
  recognise (Star p) s === recognise (Star (deeps p)) s

--------------------------------------------------------------------------------

sat_comm p q s        = recognise (p `seq` q) s === recognise (q `seq` p) s
sat_star_plus p q s   = recognise (Star (p `plus` q)) s === recognise (Star p `plus` Star q) s
sat_star_seq p q s    = recognise (Star (p `seq` q)) s === recognise (Star p `seq` Star q) s
sat_switcheroo p q s  = recognise (p `plus` q) s === recognise (p `seq` q) s
sat_bad_assoc p q r s = recognise (p `plus` (q `seq` r)) s === recognise ((p `plus` q) `seq` r) s

sat_xyy    p = question (recognise p [X,Y,Y])
sat_xyxy   p = question (recognise p [X,Y,X,Y])
sat_xxyy   p = question (recognise p [X,X,Y,Y])
sat_xyyx   p = question (recognise p [X,Y,Y,X])
sat_xyxyx  p = question (recognise p [X,Y,X,Y,X])
sat_xyxyy  p = question (recognise p [X,Y,X,Y,Y])
sat_xyxyxy p = question (recognise p [X,Y,X,Y,X,Y])

prop_FullSpec p s = okay p ==> recognise p s === reck p s

sat_wrong_FullSpec p s = recognise p s === reck p s

