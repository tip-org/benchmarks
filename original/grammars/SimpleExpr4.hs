-- Show function for a simple expression language
{-# LANGUAGE DeriveDataTypeable #-}
module SimpleExpr4 where

import Prelude hiding ((++))
import Control.Monad
import Tip.DSL
import Test.QuickCheck hiding ((==>))
import Data.Typeable

(++) :: [a] -> [a] -> [a]
(x:xs) ++ ys = x:(xs ++ ys)
[]     ++ ys = ys

data E = E `Plus` E | EX | EY
  deriving (Typeable,Eq,Ord,Show)

data Tok = C | D | X | Y | Pl
  deriving (Typeable,Eq,Ord,Show)

lin :: E -> [Tok]
lin (a `Plus` b) = linTerm a ++ [Pl] ++ linTerm b
lin EX        = [X]
lin EY        = [Y]

linTerm :: E -> [Tok]
linTerm e@(_ `Plus` _) = [C] ++ lin e ++ [D]
linTerm EX          = [X]
linTerm EY          = [Y]

prop_unambig4 :: E -> E -> Prop E
prop_unambig4 u v = lin u =:= lin v ==> u =:= v

unambigTerm u v = linTerm u =:= linTerm v ==> u =:= v

injR u v w = v ++ u =:= w ++ u ==> v =:= w
inj1 x v w = v ++ [x] =:= w ++ [x] ==> v =:= w
injL u v w = u ++ v =:= u ++ w ==> v =:= w

lemma v w s t = lin v ++ s =:= lin w ++ t ==> (v,s) =:= (w,t)
lemmaTerm v w s t = linTerm v ++ s =:= linTerm w ++ t ==> (v,s) =:= (w,t)

instance Arbitrary E where
  arbitrary = sized arb
   where
    arb s = frequency
      [ (1,return EX)
      , (1,return EY)
      , (s,liftM2 Plus (arb s2) (arb s2))
      ]
     where
      s2 = s `div` 2

instance Arbitrary Tok where
  arbitrary = elements [C,D,X,Y,Pl]

