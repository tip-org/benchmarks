{-# LANGUAGE DeriveDataTypeable #-}
module SimpleExpr5 where

import Prelude hiding ((++))
import Control.Monad
import Tip.DSL
import Test.QuickCheck hiding ((==>))
import Data.Typeable

(++) :: [a] -> [a] -> [a]
(x:xs) ++ ys = x:(xs ++ ys)
[]     ++ ys = ys

data E = T `Plus` E | Term T
  deriving (Typeable,Eq,Ord,Show)

data T = TX | TY
  deriving (Typeable,Eq,Ord,Show)

data Tok = C | D | X | Y | Pl
  deriving (Typeable,Eq,Ord,Show)

lin :: E -> [Tok]
lin (a `Plus` b) = linTerm a ++ [Pl] ++ lin b
lin (Term t)  = linTerm t

linTerm :: T -> [Tok]
linTerm TX          = [X]
linTerm TY          = [Y]

prop_unambig5 :: E -> E -> Prop E
prop_unambig5 u v = lin u =:= lin v ==> u =:= v

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
      [ (1,liftM Term arbitrary)
      , (s,liftM2 Plus arbitrary (arb (s-1)))
      ]

instance Arbitrary T where
  arbitrary = elements [TX,TY]

instance Arbitrary Tok where
  arbitrary = elements [C,D,X,Y,Pl]

