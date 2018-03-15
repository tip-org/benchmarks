module RegExpDeluxe where

import Tip hiding ((.&.))

data R a
  = Nil
  | Eps
  | Atom a
  | R a :+: R a
  | R a :&: R a
  | R a :>: R a
  | Star (R a)
 deriving ( Eq, Show )

data T = A | B | C
 deriving ( Eq, Ord, Show )

(.+.), (.&.), (.>.) :: R T -> R T -> R T
-- a .+. b = a :+: b
Nil .+. q   = q
p   .+. Nil = p
p   .+. q   = p :+: q

-- a .&. b = a :&: b
Nil .&. q   = Nil
p   .&. Nil = Nil
p   .&. q   = p :&: q

-- a .>. b = a :>: b
Nil .>. q   = Nil
p   .>. Nil = Nil
Eps .>. q   = q
p   .>. Eps = p
p   .>. q   = p :>: q

-- FLAGS: meps
eps :: R T -> Bool
eps Eps                = True
eps (p :+: q)          = eps p || eps q
eps (p :&: q)          = eps p && eps q
eps (p :>: q)          = eps p && eps q
eps (Star _)           = True
eps _                  = False

cond :: Bool -> R T
cond False = Nil
cond True  = Eps

rep :: R T -> Int -> Int -> R T
rep p i 0 = case i of
             0   -> Eps
             _ -> Nil
rep p i j = (cond (i == 0) :+: p) :>: rep p (pred i) (pred j)

iter :: Int -> R T -> R T
iter 0     _ = Eps
iter n r = r :>: iter (pred n) r

prop_iter i j p s =
  i /= j ==>
  eps p == False ==>
  rec (iter i p :&: iter j p) s === False

prop_iter' i j p s =
  i /= j ==>
  eps p === False ==>
  rec (iter i p .&. iter j p) s === False

{-
step :: R T -> T -> R T
step (Atom a)  x | a `eqT` x = Eps
step (p :+: q) x           =  label 1 (step p x) :+: label 2 (step q x)
step (p :&: q) x           =  label 1 (step p x) :&: label 2 (step q x)
step (p :>: q) x           = (label 1 (step p x) :>: q) :+: (cond (eps p) :>: label 2 (step q x))
step (Star p)  x           =  label 1 (step p x) :>: Star p
step _         x           = Nil
-}

step :: R T -> T -> R T
step (Atom a)  x | a == x = Eps
step (p :+: q) x           =  (step p x) .+. (step q x)
step (p :&: q) x           =  (step p x) .&. (step q x)
step (p :>: q) x           = ((step p x) .>. q) .+. if eps p then step q x else Nil
step (Star p)  x           =  (step p x) .>. Star p
step _         x           = Nil

rec :: R T -> [T] -> Bool
rec p []     = eps p
rec p (x:xs) = rec (step p x) xs


-- 2m48s:
prop_star_plus p q s = rec (Star (p :+: q)) s === rec (Star p :+: Star q) s

prop_koen p q s = rec (p :>: q) s === rec (q :>: p) s


-- 10s:
prop_star_plus_easy p q a b = rec (Star (p :+: q)) [a,b] === rec (Star p :+: Star q) [a,b]

prop_star_seq p q s = rec (Star (p :>: q)) s === rec (Star p :>: Star q) s

prop_switcheroo p q s = rec (p :+: q) s === rec (p :>: q) s

prop_bad_assoc p q r s = rec (p :+: (q :>: r)) s === rec ((p :+: q) :>: r) s

prop_Conj p s =
  eps p == False ==>
    rec (p :&: (p :>: p)) s === False

prop_Conj' p s =
  eps p == False ==>
    rec (p .&. (p .>. p)) s === False

prop_FromToConj_difficult p i i' j j' s =
  eps p === False ==>
    rec (rep p i j :&: rep p i' j') s === rec (rep p (max i i') (min j j')) s

i  = 0
j  = 1
i' = 2
j' = 2

prop_FromToConj p s =
  eps p == False ==>
    rec (rep p i j :&: rep p i' j') s === rec (rep p (max i i') (min j j')) s
