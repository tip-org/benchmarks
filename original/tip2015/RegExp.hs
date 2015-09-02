-- Regular expressions specification
module RegExp where

import Tip.Prelude hiding (eqList)
import qualified Prelude as P

data A = X | Y

data R
  = Nil
  | Eps
  | Atom A
  | R `Plus` R
  | R `Seq` R
  | Star R

eps :: R -> Bool
eps Eps       = True
eps (p `Plus` q) = eps p || eps q
eps (p `Seq` q) = eps p && eps q
eps (Star _)  = True
eps _         = False

eqA :: A -> A -> Bool
X `eqA` X = True
Y `eqA` Y = True
_ `eqA` _ = False

reck :: R -> [A] -> Bool
reck Eps       []  = True
reck (Atom a)  [b] = a `eqA` b
reck (p `Plus` q) s = reck p s || reck q s
reck (p `Seq`  q) s = or [ reck p l && reck q r | (l,r) <- splits s ]
reck (Star p)  []  = True
reck (Star p)  s   | not (eps p) = reck (p `Seq` Star p) s
reck _ _  = False

okay :: R -> Bool
okay (p `Plus` q) = okay p && okay q
okay (p `Seq` q)  = okay p && okay q
okay (Star p)     = okay p && not (eps p)
okay _            = True

splits :: [a] -> [([a],[a])]
splits []     = [([],[])]
splits (x:xs) = ([],x:xs) : [ (x:as,bs) | (as,bs) <- splits xs ]

sat_reck_comm p q s        = reck (p `Seq` q) s === reck (q `Seq` p) s
sat_reck_star_plus p q s   = reck (Star (p `Plus` q)) s === reck (Star p `Plus` Star q) s
sat_reck_star_seq p q s    = reck (Star (p `Seq` q)) s === reck (Star p `Seq` Star q) s
sat_reck_switcheroo p q s  = reck (p `Plus` q) s === reck (p `Seq` q) s
sat_reck_bad_assoc p q r s = reck (p `Plus` (q `Seq` r)) s === reck ((p `Plus` q) `Seq` r) s

sat_reck_xyy    p = question (reck p [X,Y,Y])
sat_reck_xyxy   p = question (reck p [X,Y,X,Y])
sat_reck_xxyy   p = question (reck p [X,X,Y,Y])
sat_reck_xyyx   p = question (reck p [X,Y,Y,X])
sat_reck_xyxyx  p = question (reck p [X,Y,X,Y,X])
sat_reck_xyxyy  p = question (reck p [X,Y,X,Y,Y])
sat_reck_xyxyxy p = question (reck p [X,Y,X,Y,X,Y])

