-- Show function for a simple expression language
module SimpleExpr4 where

import Tip

data E = E `Plus` E | EX | EY

data Tok = C | D | X | Y | Pl

lin :: E -> [Tok]
lin (a `Plus` b) = linTerm a ++ [Pl] ++ linTerm b
lin EX        = [X]
lin EY        = [Y]

linTerm :: E -> [Tok]
linTerm e@(_ `Plus` _) = [C] ++ lin e ++ [D]
linTerm EX          = [X]
linTerm EY          = [Y]

prop_unambig4 u v = lin u === lin v ==> u === v

