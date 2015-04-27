-- Relaxed prefix in VerifyThis 2015: etaps2015.verifythis.org
-- Challenge 1, submitted by Thomas Genet
module RelaxedPrefix where

import Prelude hiding (or, (++))
import Tip.DSL

data It = A | B | C

eq :: It -> It -> Bool
eq A A = True
eq B B = True
eq C C = True
eq _ _ = False

(++) :: [It] -> [It] -> [It]
[] ++ xs = xs
(x:xs) ++ ys = x:(xs++ys)

isPrefix :: [It] -> [It] -> Bool
isPrefix [] _ = True
isPrefix _ [] = False
isPrefix (x:xs) (y:ys) =
  case x `eq` y of
    True -> isPrefix xs ys
    False -> False

isRelaxedPrefix :: [It] -> [It] -> Bool
isRelaxedPrefix [] _ = True
isRelaxedPrefix [_] _ = True
isRelaxedPrefix _ [] = False
isRelaxedPrefix (x:xs) (y:ys)
  | x `eq` y = isRelaxedPrefix xs ys
  | otherwise = isPrefix xs (y:ys)

spec :: [It] -> [It] -> Bool
spec xs ys = or [ isPrefix xs' ys | xs' <- xs:removeOne xs ]

or :: [Bool] -> Bool
or [] = False
or (True:_) = True
or (False:xs) = or xs

removeOne :: [It] -> [[It]]
removeOne [] = []
removeOne (x:xs) = xs:[ x:ys | ys <- removeOne xs ]

-- Relaxed prefix conforms to its specification
prop_correct :: [It] -> [It] -> Prop Bool
prop_correct xs ys = isRelaxedPrefix xs ys =:= spec xs ys

-- A way to specify the relaxed prefix function
prop_is_prefix_1 :: [It] -> [It] -> Prop Bool
prop_is_prefix_1 xs ys = isRelaxedPrefix xs (xs++ys) =:= True
prop_is_prefix_2 :: It -> [It] -> [It] -> [It] -> Prop Bool
prop_is_prefix_2 x xs ys zs = isRelaxedPrefix (xs ++ [x] ++ ys) (xs++ys++zs) =:= True
prop_is_prefix_3 :: It -> [It] -> [It] -> Prop Bool
prop_is_prefix_3 x xs ys = isRelaxedPrefix (xs ++ [x]) (xs++ys) =:= True
prop_is_prefix_4 :: It -> [It] -> [It] -> Prop Bool
prop_is_prefix_4 x xs ys = isRelaxedPrefix (x:xs) (xs++ys) =:= True
