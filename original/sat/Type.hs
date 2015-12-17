{-# LANGUAGE PatternGuards #-}
module Type where

import Tip.Prelude
import qualified Prelude

data Expr = App Expr Expr Ty | Lam Expr | Var Nat

data Ty = Ty `Arr` Ty | A | B | C

infixr 9 `Arr`
infixr 9 -->
infix  4 `eqType`

eqType :: Ty -> Ty -> Bool
A `eqType` A = True
B `eqType` B = True
C `eqType` C = True
(a `Arr` x) `eqType` (b `Arr` y) = a `eqType` b && x `eqType` y
_ `eqType` _ = False

nf :: Expr -> Bool
nf (App Lam{} _ _) = False
nf (App e x _) = nf e && nf x
nf (Lam e)     = nf e
nf Var{}       = True

tc :: [Ty] -> Expr -> Ty -> Bool

tc env (Var x)      t | Just tx <- env `index` x = tx `eqType` t
tc env (App f x tx) t            = (tc env f (tx `Arr` t)) && (tc env x tx)
tc env (Lam e)      (tx `Arr` t) = (tc (tx:env) e t)
tc _   _            _ = False


(-->) = Arr

sat_synth_id e = question (tc [] e (A --> A))
sat_synth_k e = question (tc [] e (A --> B --> B))

sat_synth_w e = question (tc [] e ((A --> A --> B) --> (A --> B)))
sat_synth_flip e = question (tc [] e ((A --> B --> C) --> (B --> A --> C)))
sat_synth_compose e = question (tc [] e ((B --> C) --> (A --> B) --> (A --> C)))
sat_synth_s e = question (tc [] e ((A --> B --> C) --> (A --> B) --> A --> C))

-- sat_synth_nf_coerce e = question (tc [] e (A --> B))

sat_synth_nf_id e = question (nf e .&&. tc [] e (A --> A))
sat_synth_nf_k e = question (nf e .&&. tc [] e (A --> B --> B))
sat_synth_nf_w e = question (nf e .&&. tc [] e ((A --> A --> B) --> (A --> B)))
sat_synth_nf_flip e = question (nf e .&&. tc [] e ((A --> B --> C) --> (B --> A --> C)))
sat_synth_nf_compose e = question (nf e .&&. tc [] e ((B --> C) --> (A --> B) --> (A --> C)))
sat_synth_nf_s e = question (nf e .&&. tc [] e ((A --> B --> C) --> (A --> B) --> A --> C))

