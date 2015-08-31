{-# LANGUAGE TemplateHaskell #-}
module Subst where

import Tip.Prelude
import qualified Prelude as P

type Name = Int

data Expr
  = Var Name
  | Lam Name Expr
  | App Expr Expr

free :: Expr -> [Name]
free (Var x)   = [x]
free (App a b) = free a ++ free b
free (Lam x a) = filter (x P./=) (free a)

new :: [Name] -> Name
new xs = maximum 0 xs P.+ 1
  where
    maximum :: Int -> [Int] -> Int
    maximum x [] = x
    maximum x (y:ys)
      | x P.<= y = maximum y ys
      | otherwise = maximum x ys

subst :: Name -> Expr -> Expr -> Expr
subst x e (Var y)
  | x P.== y        = e
  | otherwise       = Var y
subst x e (App a b) = App (subst x e a) (subst x e b)
subst x e (Lam y a)
  | x P.== y         = Lam y a
  | y `zelem` free e = subst x e (Lam z (subst y (Var z) a))
  | otherwise        = Lam y (subst x e a)
 where
  z = new (free e ++ free a)

--------------------------------------------------------------------------------

prop_SubstFreeNo x e a y =
  x `zelem` free a === False ==>
    (y `zelem` free a) === (y `zelem` free (subst x e a))

prop_SubstFreeYes x e a y =
  x `zelem` free a === True ==>
    (y `zelem` (filter (P./= x) (free a) ++ free e)) === (y `zelem` free (subst x e a))
