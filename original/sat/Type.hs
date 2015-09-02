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
tc env (App f x tx) t           = (tc env f (tx `Arr` t)) && (tc env x tx)
tc env (Lam e)      (tx `Arr` t) = (tc (tx:env) e t)
tc _   _            _ = False


(-->) = Arr

sat_synth_S0 e = question (tc [] e (A --> A))
sat_synth_S1 e = question (tc [] e (A --> (A --> A) --> A))
sat_synth_S2 e = question (tc [] e ((A --> B) --> (A --> B)))
sat_synth_S3 e = question (tc [] e (A --> B --> B))
sat_synth_S4 e = question (tc [] e (A --> B --> A))
sat_synth_S5 e = question (tc [] e ((A --> B) --> (A --> A --> B)))

sat_synth_M0 e = question (tc [] e ((A --> A --> B) --> (A --> B)))
sat_synth_M1 e = question (tc [] e ((A --> B --> C) --> (B --> A --> C)))
sat_synth_M2 e = question (tc [] e ((B --> C) --> (A --> B) --> (A --> C)))
sat_synth_M3 e = question (tc [] e ((A --> B --> C) --> (A --> B) --> A --> C))

sat_synth_L0 e = question (tc [] e ((A --> A --> B) --> (B --> C) --> (A --> C)))
sat_synth_L1 e = question (tc [] e ((A --> B) --> (B --> B --> C) --> (A --> C)))
sat_synth_L2 e = question (tc [] e ((A --> A --> B) --> (B --> B --> C) --> (A --> C)))

sat_synth_S0_nf e = question (nf e .&&. tc [] e (A --> A))
sat_synth_S1_nf e = question (nf e .&&. tc [] e (A --> (A --> A) --> A))
sat_synth_S2_nf e = question (nf e .&&. tc [] e ((A --> B) --> (A --> B)))
sat_synth_S3_nf e = question (nf e .&&. tc [] e (A --> B --> B))
sat_synth_S4_nf e = question (nf e .&&. tc [] e (A --> B --> A))
sat_synth_S5_nf e = question (nf e .&&. tc [] e ((A --> B) --> (A --> A --> B)))

sat_synth_M0_nf e = question (nf e .&&. tc [] e ((A --> A --> B) --> (A --> B)))
sat_synth_M1_nf e = question (nf e .&&. tc [] e ((A --> B --> C) --> (B --> A --> C)))
sat_synth_M2_nf e = question (nf e .&&. tc [] e ((B --> C) --> (A --> B) --> (A --> C)))
sat_synth_M3_nf e = question (nf e .&&. tc [] e ((A --> B --> C) --> (A --> B) --> A --> C))

sat_synth_L0_nf e = question (nf e .&&. tc [] e ((A --> A --> B) --> (B --> C) --> (A --> C)))
sat_synth_L1_nf e = question (nf e .&&. tc [] e ((A --> B) --> (B --> B --> C) --> (A --> C)))
sat_synth_L2_nf e = question (nf e .&&. tc [] e ((A --> A --> B) --> (B --> B --> C) --> (A --> C)))

f = Var (S Z)
g = Var (S (S Z))
x = Var Z
y = Var (S Z)

sat_infer_S0 t = question (tc [] (Lam x) t)
sat_infer_S1 t = question (tc [] (Lam (Lam x)) t)
sat_infer_S2 t = question (tc [] (Lam (Lam y)) t)
sat_infer_S3 t t1 = question (tc [] (Lam (Lam (App f x t1))) t)
sat_infer_S4 t t1 = question (tc [] (Lam (Lam (App x f t1))) t)

sat_infer_M0 t t1 t2 = question (tc [] (Lam (Lam (App (App f x t1) x t2))) t)
sat_infer_M1 t t1 t2 = question (tc [] (Lam (Lam (Lam (App g (App f x t1) t2)))) t .&&. t1 =/= t2)
sat_infer_M2 t t1 t2 = question (tc [] (Lam (Lam (Lam (App (App g y t1) x t2)))) t .&&. t1 =/= t2)
sat_infer_M3 t t1 t2 t3 = question (tc [] (Lam (Lam (Lam (App (App g x t1) (App f x t2) t3)))) t .&&. t2 =/= t3)

sat_self e t1 t = question (tc [] (App e e t1) t)
