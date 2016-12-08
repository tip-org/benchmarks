-- Show function for a simple expression language
module SimpleExpr5 where

import Tip

data E = T `Plus` E | Term T

data T = TX | TY

data Tok = C | D | X | Y | Pl

lin :: E -> [Tok]
lin (a `Plus` b) = linTerm a ++ [Pl] ++ lin b
lin (Term t)     = linTerm t

linTerm :: T -> [Tok]
linTerm TX          = [X]
linTerm TY          = [Y]

prop_unambig5 u v = lin u === lin v ==> u === v

