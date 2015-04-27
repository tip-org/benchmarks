{-# LANGUAGE TemplateHaskell #-}
module Subst where

import Tip.DSL
import Prelude hiding (Eq(..), Ord(..), map, all, elem, null, length, even, (++), filter)
import Nat hiding ((+))
import qualified Prelude

type OrdA = Int

(>), (<=), (==), (/=) :: Int -> Int -> Bool
(<=) = (Prelude.<=)
(>)  = (Prelude.>)
(==) = (Prelude.==)
(/=) = (Prelude./=)

delete :: Int -> [Int] -> [Int]
delete x [] = []
delete x (y:ys)
  | x == y = ys
  | otherwise = y:delete x ys

filter p xs = [ x | x <- xs, p x ]
map f xs = [ f x | x <- xs ]
all p [] = True
all p (x:xs) = p x && all p xs
x `elem` [] = False
x `elem` (y:ys) = x == y || x `elem` ys
null [] = True
null _ = False
length [] = Z
length (_:xs) = S (length xs)
even Z = True
even (S Z) = False
even (S (S x)) = even x
[] ++ xs = xs
(x:xs) ++ ys = x:(xs ++ ys)

type Name = Int

data Expr
  = Var Name
  | Lam Name Expr
  | App Expr Expr

free :: Expr -> [Name]
free (Var x)   = [x]
free (App a b) = free a ++ free b
free (Lam x a) = filter (x/=) (free a)

new :: [Name] -> Name
new xs = maximum 0 xs + 1
  where
    maximum x [] = x
    maximum x (y:ys)
      | x <= y = maximum y ys
      | otherwise = maximum x ys

subst :: Name -> Expr -> Expr -> Expr
subst x e (Var y)
  | x == y          = e
  | otherwise       = Var y
subst x e (App a b) = App (subst x e a) (subst x e b)
subst x e (Lam y a)
  | x == y          = Lam y a
  | y `elem` free e = subst x e (Lam z (subst y (Var z) a))
  | otherwise       = Lam y (subst x e a)
 where
  z = new (free e ++ free a)

--------------------------------------------------------------------------------

prop_SubstFreeNo x e a y =
  x `elem` free a =:= False ==>
    (y `elem` free a) =:= (y `elem` free (subst x e a))

prop_SubstFreeYes x e a y =
  x `elem` free a =:= True ==>
    (y `elem` (filter (/=x) (free a) ++ free e)) =:= (y `elem` free (subst x e a))
