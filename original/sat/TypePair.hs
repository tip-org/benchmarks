{-# LANGUAGE PatternGuards #-}
module Type where

import Tip.Prelude hiding ((*))
import qualified Prelude

data Expr
    = App Expr Expr Ty | Lam Expr | Var Nat
    | Pair Expr Expr | Fst Expr Ty | Snd Ty Expr

data Ty = Ty `Arr` Ty | A | B | C | Ty `Prod` Ty

infixr 8 `Arr`
infixr 8 -->
infixr 9 *
infix  4 `eqType`

eqType :: Ty -> Ty -> Bool
A `eqType` A = True
B `eqType` B = True
C `eqType` C = True
(a `Arr` x) `eqType` (b `Arr` y) = a `eqType` b && x `eqType` y
(a `Prod` x) `eqType` (b `Prod` y) = a `eqType` b && x `eqType` y
_ `eqType` _ = False

nf :: Expr -> Bool
nf (App Lam{} _ _) = False
nf (App e x _) = nf e && nf x
nf (Pair u v)  = nf u && nf v
nf (Fst e _)   = nf e
nf (Snd _ e)   = nf e
nf (Lam e)     = nf e
nf Var{}       = True

pnf :: Expr -> Bool
pnf (Fst Pair{} _) = False
pnf (Snd _ Pair{}) = False
pnf (App Lam{} _ _) = False
pnf (App e x _) = nf e && nf x
pnf (Pair u v)  = nf u && nf v
pnf (Fst e _)   = nf e
pnf (Snd _ e)   = nf e
pnf (Lam e)     = nf e
pnf Var{}       = True



tc :: [Ty] -> Expr -> Ty -> Bool

tc env (Var x)      t | Just tx <- env `index` x = tx `eqType` t
tc env (App f x tx) t              = (tc env f (tx `Arr` t)) && (tc env x tx)
tc env (Lam e)      (tx `Arr` t)   = (tc (tx:env) e t)
tc env (Pair u v)   (tu `Prod` tv) = tc env u tu && tc env v tv
tc env (Fst e tr)   tl             = tc env e (tl `Prod` tr)
tc env (Snd tl e)   tr             = tc env e (tl `Prod` tr)
tc _   _            _ = False

(-->) = Arr
(*) = Prod

sat_synth_dup e     = question (tc [] e (A --> A * A))
sat_synth_swap e    = question (tc [] e (A * B --> B * A))
sat_synth_curry e   = question (tc [] e ((A * B --> C) --> A --> B --> C))
sat_synth_uncurry e = question (tc [] e ((A --> B --> C) --> A * B --> C))
sat_synth_assoc e   = question (tc [] e ((A * (B * C) --> (A * B) * C)))
sat_synth_dist1 e   = question (tc [] e ((A --> B) --> (A --> C) --> A --> B * C))
sat_synth_dist2 e   = question (tc [] e ((A --> B * C) --> (A --> C) * (A --> B)))

sat_synth_nf_dup e     = question (nf e .&&. tc [] e (A --> A * A))
sat_synth_nf_swap e    = question (nf e .&&. tc [] e (A * B --> B * A))
sat_synth_nf_curry e   = question (nf e .&&. tc [] e ((A * B --> C) --> A --> B --> C))
sat_synth_nf_uncurry e = question (nf e .&&. tc [] e ((A --> B --> C) --> A * B --> C))
sat_synth_nf_assoc e   = question (nf e .&&. tc [] e ((A * (B * C) --> (A * B) * C)))
sat_synth_nf_dist1 e   = question (nf e .&&. tc [] e ((A --> B) --> (A --> C) --> A --> B * C))
sat_synth_nf_dist2 e   = question (nf e .&&. tc [] e ((A --> B * C) --> (A --> C) * (A --> B)))

sat_synth_pnf_dup e     = question (pnf e .&&. tc [] e (A --> A * A))
sat_synth_pnf_swap e    = question (pnf e .&&. tc [] e (A * B --> B * A))
sat_synth_pnf_curry e   = question (pnf e .&&. tc [] e ((A * B --> C) --> A --> B --> C))
sat_synth_pnf_uncurry e = question (pnf e .&&. tc [] e ((A --> B --> C) --> A * B --> C))
sat_synth_pnf_assoc e   = question (pnf e .&&. tc [] e ((A * (B * C) --> (A * B) * C)))
sat_synth_pnf_dist1 e   = question (pnf e .&&. tc [] e ((A --> B) --> (A --> C) --> A --> B * C))
sat_synth_pnf_dist2 e   = question (pnf e .&&. tc [] e ((A --> B * C) --> (A --> C) * (A --> B)))
