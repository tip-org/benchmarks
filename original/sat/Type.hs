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

sat_synth_Sa e = question (tc [] e (A --> A))
sat_synth_Sb e = question (tc [] e (A --> (A --> A) --> A))
sat_synth_Sc e = question (tc [] e ((A --> B) --> (A --> B)))
sat_synth_Sd e = question (tc [] e (A --> B --> B))
sat_synth_Se e = question (tc [] e (A --> B --> A))
sat_synth_Sf e = question (tc [] e ((A --> B) --> (A --> A --> B)))

sat_synth_Ma e = question (tc [] e ((A --> A --> B) --> (A --> B)))
sat_synth_Mb e = question (tc [] e ((A --> B --> C) --> (B --> A --> C)))
sat_synth_Mc e = question (tc [] e ((B --> C) --> (A --> B) --> (A --> C)))
sat_synth_Md e = question (tc [] e ((A --> B --> C) --> (A --> B) --> A --> C))

sat_synth_La e = question (tc [] e ((A --> A --> B) --> (B --> C) --> (A --> C)))
sat_synth_Lb e = question (tc [] e ((A --> B) --> (B --> B --> C) --> (A --> C)))
sat_synth_Lc e = question (tc [] e ((A --> A --> B) --> (B --> B --> C) --> (A --> C)))

sat_synth_Sa_nf e = question (nf e .&&. tc [] e (A --> A))
sat_synth_Sb_nf e = question (nf e .&&. tc [] e (A --> (A --> A) --> A))
sat_synth_Sc_nf e = question (nf e .&&. tc [] e ((A --> B) --> (A --> B)))
sat_synth_Sd_nf e = question (nf e .&&. tc [] e (A --> B --> B))
sat_synth_Se_nf e = question (nf e .&&. tc [] e (A --> B --> A))
sat_synth_Sf_nf e = question (nf e .&&. tc [] e ((A --> B) --> (A --> A --> B)))

sat_synth_Ma_nf e = question (nf e .&&. tc [] e ((A --> A --> B) --> (A --> B)))
sat_synth_Mb_nf e = question (nf e .&&. tc [] e ((A --> B --> C) --> (B --> A --> C)))
sat_synth_Mc_nf e = question (nf e .&&. tc [] e ((B --> C) --> (A --> B) --> (A --> C)))
sat_synth_Md_nf e = question (nf e .&&. tc [] e ((A --> B --> C) --> (A --> B) --> A --> C))

sat_synth_La_nf e = question (nf e .&&. tc [] e ((A --> A --> B) --> (B --> C) --> (A --> C)))
sat_synth_Lb_nf e = question (nf e .&&. tc [] e ((A --> B) --> (B --> B --> C) --> (A --> C)))
sat_synth_Lc_nf e = question (nf e .&&. tc [] e ((A --> A --> B) --> (B --> B --> C) --> (A --> C)))

f = Var (S Z)
g = Var (S (S Z))
x = Var Z
y = Var (S Z)

sat_infer_Sa t = question (tc [] (Lam x) t)
sat_infer_Sb t = question (tc [] (Lam (Lam x)) t)
sat_infer_Sc t = question (tc [] (Lam (Lam y)) t)
sat_infer_Sd t t1 = question (tc [] (Lam (Lam (App f x t1))) t)
sat_infer_Se t t1 = question (tc [] (Lam (Lam (App x f t1))) t)

sat_infer_Ma t t1 t2 = question (tc [] (Lam (Lam (App (App f x t1) x t2))) t)
sat_infer_Mb t t1 t2 = question (tc [] (Lam (Lam (Lam (App g (App f x t1) t2)))) t .&&. t1 =/= t2)
sat_infer_Mc t t1 t2 = question (tc [] (Lam (Lam (Lam (App (App g y t1) x t2)))) t .&&. t1 =/= t2)
sat_infer_Md t t1 t2 t3 = question (tc [] (Lam (Lam (Lam (App (App g x t1) (App f x t2) t3)))) t .&&. t2 =/= t3)

sat_self e t1 t = question (tc [] (App e e t1) t)
