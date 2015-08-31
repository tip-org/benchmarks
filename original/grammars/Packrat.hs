-- Show unambiguity of the following grammar:
--
--  S <- A | B
--  A <- xAy | xzy
--  B <- xByy | xzyy
--
-- From "Packrat Parsing: Simple, Powerful, Lazy, Linear Time" (Functional
-- Pearl), Bryan Ford ICFP 2012
module Packrat where

import Prelude ()
import Tip.Prelude hiding (Nat(Z))

{-

The way we show that this is unambiguous is to show that:

count x A = count y A
double (count x B) = count y B
count x A > 0
count y A > 0
count x B > 0
count y B > 0
double x != x for x > x, using:
  x + y = x + z => y = z
  double x = x + x
  (and perhaps also commutativity)
list homomorphism of count x and +

-}

data S = A A | B B

data A = SA A | ZA

data B = SB B | ZB

data Tok = X | Y | Z

linS :: S -> [Tok]
linS (A a) = linA a
linS (B b) = linB b

linA :: A -> [Tok]
linA ZA     = [X,Z,Y]
linA (SA a) = [X] ++ linA a ++ [Y]

linB :: B -> [Tok]
linB ZB     = [X,Z,Y,Y]
linB (SB b) = [X] ++ linB b ++ [Y,Y]

prop_unambigPackrat u v = linS u === linS v ==> u === v

