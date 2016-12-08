{-# LANGUAGE TemplateHaskell #-}
module Subst where

import Tip

type Name = Int

data Expr
  = Var Name
  | Lam Name Expr
  | App Expr Expr

free :: Expr -> [Name]
free (Var x)   = [x]
free (App a b) = free a ++ free b
free (Lam x a) = filter (x /=) (free a)

new :: [Name] -> Name
new xs = maximum 0 xs + 1
  where
    maximum :: Int -> [Int] -> Int
    maximum x [] = x
    maximum x (y:ys)
      | x <= y = maximum y ys
      | otherwise = maximum x ys

subst :: Name -> Expr -> Expr -> Expr
subst x e (Var y)
  | x == y        = e
  | otherwise       = Var y
subst x e (App a b) = App (subst x e a) (subst x e b)
subst x e (Lam y a)
  | x == y         = Lam y a
  | y `elem` free e = subst x e (Lam z (subst y (Var z) a))
  | otherwise        = Lam y (subst x e a)
 where
  z = new (free e ++ free a)

--------------------------------------------------------------------------------

prop_SubstFreeNo x e a y =
  x `elem` free a === False ==>
    (y `elem` free a) === (y `elem` free (subst x e a))

prop_SubstFreeYes x e a y =
  x `elem` free a === True ==>
    (y `elem` (filter (/= x) (free a) ++ free e)) === (y `elem` free (subst x e a))
