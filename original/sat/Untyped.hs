module Untyped where

import Tip
import Prelude (Maybe(..),(&&),Bool(..))
import qualified Prelude

data Term
  = Term `Ap` Term
  | Var
  | I
#ifdef USE_K
  | K
#endif
#ifdef USE_S
  | S
#endif
#ifdef USE_B
  | B
#endif
#ifdef USE_C
  | C
#endif
#ifdef USE_W
  | W
#endif

infixl `Ap`

varFree :: Term -> Bool
varFree (a `Ap` b) = varFree a && varFree b
varFree Var        = False
varFree _          = True

step :: Term -> Maybe Term
step (I `Ap` x) = Just x
#ifdef USE_S
step (S `Ap` f `Ap` g `Ap` x) = Just (f `Ap` x `Ap` (g `Ap` x))
#endif
#ifdef USE_K
step (K `Ap` x `Ap` _) = Just x
#endif
#ifdef USE_B
step (B `Ap` f `Ap` g `Ap` x) = Just (f `Ap` (g `Ap` x))
#endif
#ifdef USE_C
step (C `Ap` f `Ap` x `Ap` y) = Just (f `Ap` y `Ap` x)
#endif
#ifdef USE_W
step (W `Ap` f `Ap` x) = Just (f `Ap` x `Ap` x)
#endif
step (t `Ap` u) = par t u (step t) (step u)
step _ = Nothing

par :: Term -> Term -> Maybe Term -> Maybe Term -> Maybe Term
par t u (Just t_red) (Just u_red) = Just (t_red `Ap` u_red)
par t u Nothing      (Just u_red) = Just (t     `Ap` u_red)
par t u (Just t_red) Nothing      = Just (t_red `Ap` u)
par _ _ _ _ = Nothing

data Nat = Zero | Suc Nat

astep :: Nat -> Term -> Maybe Term
astep Zero    x = Just x
astep (Suc n) x = case step x of
    Just u  -> astep n u
    Nothing -> Nothing

four = (Suc (Suc (Suc (Suc Zero))))
five = Suc four

sat_4_why y   = question (varFree y .&&. astep four (y `Ap` Var) === Just (Var `Ap` (y `Ap` Var)))
sat_5_why y   = question (varFree y .&&. astep five (y `Ap` Var) === Just (Var `Ap` (y `Ap` Var)))
sat_n_why n y = question (varFree y .&&. astep n    (y `Ap` Var) === Just (Var `Ap` (y `Ap` Var)))

