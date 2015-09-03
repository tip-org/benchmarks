# 1 "Untyped.hs"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "Untyped.hs"
module Untyped where

import Tip
import Prelude (Maybe(..),(&&),Bool(..))
import qualified Prelude

data Term
  = Term `Ap` Term
  | Var
  | I

  | K


  | S
# 27 "Untyped.hs"
infixl `Ap`

varFree :: Term -> Bool
varFree (a `Ap` b) = varFree a && varFree b
varFree Var = False
varFree _ = True

step :: Term -> Maybe Term
step (I `Ap` x) = Just x

step (S `Ap` f `Ap` g `Ap` x) = Just (f `Ap` x `Ap` (g `Ap` x))


step (K `Ap` x `Ap` _) = Just x
# 51 "Untyped.hs"
step (t `Ap` u) = par t u (step t) (step u)
step _ = Nothing

par :: Term -> Term -> Maybe Term -> Maybe Term -> Maybe Term
par t u (Just t_red) (Just u_red) = Just (t_red `Ap` u_red)
par t u Nothing (Just u_red) = Just (t `Ap` u_red)
par t u (Just t_red) Nothing = Just (t_red `Ap` u)
par _ _ _ _ = Nothing

data Nat = Zero | Suc Nat

astep :: Nat -> Term -> Maybe Term
astep Zero x = Just x
astep (Suc n) x = case step x of
    Just u -> astep n u
    Nothing -> Nothing

four = (Suc (Suc (Suc (Suc Zero))))
five = Suc four

sat_4_why y = question (varFree y .&&. astep four (y `Ap` Var) === Just (Var `Ap` (y `Ap` Var)))
sat_5_why y = question (varFree y .&&. astep five (y `Ap` Var) === Just (Var `Ap` (y `Ap` Var)))
sat_n_why n y = question (varFree y .&&. astep n (y `Ap` Var) === Just (Var `Ap` (y `Ap` Var)))
