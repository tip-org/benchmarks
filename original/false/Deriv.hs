module Deriv where

import Tip hiding (label)
import Tip.GHC.Annotations

data E = N Int | E :+: E | E :*: E | X deriving (Eq)

{-# ANN label Inline #-}
label _ x = x

d :: E -> E
d (f :+: g) = label 1 (d f) :+: label 2 (d g)
d (f :*: g) = (label 1 (d f) :*: g) :+: (f :*: label 2 (d g))
d X         = N 1
d N{}       = N 0

infix 5 :*:
infix 4 :+:

-- FLAGS: copt
opt :: E -> E
opt (N 0 :*: e)       = N 0
opt (e :*: N 0)       = N 0
opt (N 1 :*: e)   = e
opt (e :*: N 1)   = e
opt (N 0     :+: e)   = e
opt (e :+: N 0)       = e
opt (N a :+: N b)     = N (a + b)
opt (N a :*: N b)     = N (a * b)
opt (a :+: b) | a == b = N 2 :*: label 1 (opt a)
opt ((a :+: b) :+: c) = label 1 (opt (a :+: (b :+: c)))
opt ((a :*: b) :*: c) = label 1 (opt (a :*: (b :*: c)))
opt (a :+: b)         = label 1 (opt a) :+: label 2 (opt b)
opt (a :*: b)         = label 1 (opt a) :*: label 2 (opt b)
opt e                 = e

eval :: E -> Int -> Int
eval X         x = x
eval (a :+: b) x = label 1 (eval a x) + label 1 (eval b x)
eval (a :*: b) x = label 1 (eval a x) * label 1 (eval b x)
eval (N n)     _ = n

prop1 e = opt (d e) === opt (N 2 :+: (X :+: X)) ==> True === False

prop2 e = opt (d e) === X :*: X :+: X :*: (X :+: X) ==> True === False

prop3 e x = eval e x === eval (opt e) x

prop4 e = opt (d e) === opt (d (opt e))

propm4 e = opt (d e) === X :*: (X :*: X) :+: X :*: (X :*: X :+: X :*: (X :+: X)) ==> True === False

propm5 e = opt (d e) === X :*: (X :*: (X :*: X)) :+: X :*: (X :*: (X :*: X) :+: X :*: (X :*: X :+: X :*: (X :+: X))) ==> True === False

propm6 e = opt (d e) === X :*: (X :*: (X :*: (X :*: X))) :+: X :*: (X :*: (X :*: (X :*: X)) :+: X :*: (X :*: (X :*: X) :+: X :*: (X :*: X :+: X :*: (X :+: X)))) ==> True === False

muls :: Int -> E
muls 0 = N 1
muls 1 = X
muls n = X :*: muls (n - 1)

