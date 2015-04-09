{-# LANGUAGE TemplateHaskell, DeriveDataTypeable #-}
module Escape where

import Data.Typeable
import Data.Data
import HipSpec

import Prelude hiding (all)

-- import Test.QuickCheck
-- import Test.QuickCheck.All

--------------------------------------------------------------------------------

data Token = A | B | C | D | ESC | P | Q | R
 deriving ( Eq, Ord, Show, Typeable, Data )

escape :: [Token] -> [Token]
escape []                   = []
escape (x:xs) | isSpecial x = ESC : code x : escape xs
              | otherwise   = x : escape xs

isSpecial :: Token -> Bool
isSpecial ESC = True
isSpecial P   = True
isSpecial Q   = True
isSpecial R   = True
isSpecial _   = False

code :: Token -> Token
code ESC = ESC
code P   = A
code Q   = B
code R   = C
code x   = x

all :: (a -> Bool) -> [a] -> Bool
all p [] = True
all p (x:xs) = p x && all p xs

isEsc :: Token -> Bool
isEsc ESC = True
isEsc _   = False

ok :: Token -> Bool
ok x = not (isSpecial x) || isEsc x

--------------------------------------------------------------------------------

prop_Injective xs ys =
  escape xs =:= escape ys ==> xs =:= ys

prop_NoSpecial xs =
  all ok (escape xs) =:= True

--------------------------------------------------------------------------------

instance Arbitrary Token where
  arbitrary = elements [A,B,C,D,ESC,P,Q,R]

-- return []
-- testAll = $(quickCheckAll)

--------------------------------------------------------------------------------

