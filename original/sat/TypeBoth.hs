{-# LANGUAGE PatternGuards #-}
module Type where

import Tip.Prelude hiding ((*),(+))
import qualified Prelude

data Expr
    = App Expr Expr Ty | Lam Expr | Var Nat
    | Case Expr Ty Ty Expr Expr | Inl Expr | Inr Expr
    | Pair Expr Expr | Fst Expr Ty | Snd Ty Expr

data Ty = Ty `Arr` Ty | A | B | C | Ty `Either` Ty | Ty `Prod` Ty

infixr 8 `Arr`
infixr 8 -->
infixr 9 +
infixr 9 *
infix  4 `eqType`

eqType :: Ty -> Ty -> Bool
A `eqType` A = True
B `eqType` B = True
C `eqType` C = True
(a `Arr` x) `eqType` (b `Arr` y) = a `eqType` b && x `eqType` y
(a `Either` x) `eqType` (b `Either` y) = a `eqType` b && x `eqType` y
(a `Prod` x) `eqType` (b `Prod` y) = a `eqType` b && x `eqType` y
_ `eqType` _ = False

nf :: Expr -> Bool
nf (App Lam{} _ _) = False
nf (App e x _) = nf e && nf x
nf (Case u _ _ v w)  = nf u && nf v && nf w
nf (Pair u v)  = nf u && nf v
nf (Fst e _)   = nf e
nf (Snd _ e)   = nf e
nf (Inl e)     = nf e
nf (Inr e)     = nf e
nf (Lam e)     = nf e
nf Var{}       = True

pnf :: Expr -> Bool
pnf (Fst Pair{} _) = False
pnf (Snd _ Pair{}) = False
pnf (Case Inl{} _ _ _ _) = False
pnf (Case Inr{} _ _ _ _) = False
pnf (App Lam{} _ _) = False
pnf (App e x _) = pnf e && pnf x
pnf (Case u _ _ v w)  = pnf u && pnf v && pnf w
pnf (Pair u v)  = pnf u && pnf v
pnf (Fst e _)   = pnf e
pnf (Snd _ e)   = pnf e
pnf (Inl e)     = pnf e
pnf (Inr e)     = pnf e
pnf (Lam e)     = pnf e
pnf Var{}       = True

tc :: [Ty] -> Expr -> Ty -> Bool

tc env (Var x)            t | Just tx <- env `index` x = tx `eqType` t
tc env (App f x tx)       t              = (tc env f (tx `Arr` t)) && (tc env x tx)
tc env (Lam e)            (tx `Arr` t)   = (tc (tx:env) e t)
tc env (Case s ta tb a b) t              = tc env s (ta `Either` tb) &&
                                           tc (ta:env) a t &&
                                           tc (tb:env) b t
tc env (Inl e)            (t `Either` _) = tc env e t
tc env (Inr e)            (_ `Either` t) = tc env e t
tc env (Pair u v)         (tu `Prod` tv) = tc env u tu && tc env v tv
tc env (Fst e tr)         tl             = tc env e (tl `Prod` tr)
tc env (Snd tl e)         tr             = tc env e (tl `Prod` tr)
tc _   _                  _ = False

(-->) = Arr
(+) = Either
(*) = Prod

sat_synth_wk e      = question (tc [] e (A * B --> A + B))
sat_synth_drop1 e   = question (tc [] e (((A * B) + C) --> A + C))
sat_synth_dist1 e   = question (tc [] e (A * (B + C) --> (A * B) + (A * C)))
sat_synth_dist2 e   = question (tc [] e ((A * B) + (A * C) --> A * (B + C)))
sat_synth_dist3 e   = question (tc [] e ((A * C) + (B * C) --> (A + B) * C))
sat_synth_dist4 e   = question (tc [] e (((A + B) * C) --> (A * C) + (B * C)))

sat_synth_nf_wk e      = question (nf e .&&. tc [] e (A * B --> A + B))
sat_synth_nf_dist1 e   = question (nf e .&&. tc [] e (A * (B + C) --> (A * B) + (A * C)))
sat_synth_nf_dist2 e   = question (nf e .&&. tc [] e ((A * B) + (A * C) --> A * (B + C)))
sat_synth_nf_dist3 e   = question (nf e .&&. tc [] e ((A * C) + (B * C) --> (A + B) * C))
sat_synth_nf_dist4 e   = question (nf e .&&. tc [] e (((A + B) * C) --> (A * C) + (B * C)))

