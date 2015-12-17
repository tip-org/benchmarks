module Expr where

import Tip.Prelude
import qualified Prelude

data Expr
  = IfThen     Expr Expr
  | IfThenElse Expr Expr Expr
  | Var Nat
  | Add Expr Expr

data Tok = IF | THEN | ELSE | N Nat | PLUS | STAR | C | D

showExpr :: Expr -> [Tok]
showExpr (IfThen     b t)   = [IF] ++ showExpr b ++ [THEN] ++ showExpr t
showExpr (IfThenElse b t f) = [IF] ++ showExpr b ++ [THEN] ++ showExpr t ++ [ELSE] ++ showExpr f
showExpr (Var x)            = [N x]
showExpr (Add a b)          = [C] ++ showExpr a ++ [PLUS] ++ showExpr b ++ [D]

showAdd :: Expr -> [Tok]
showAdd e = showExpr e
{-
showAdd e@Add{} = [C] ++ showExpr e ++ [D]
showAdd e       = showExpr e
-}

{-
showMul :: Expr -> [Tok]
showMul e@Add{} = [C] ++ showExpr e ++ [D]
showMul e@Mul{} = [C] ++ showExpr e ++ [D]
showMul e       = showExpr e
-}

-- sat_ambig_easy p q noop boom =
--   question (showExpr (IfThenElse p (IfThen q noop) boom)
--         === showExpr (IfThen p (IfThenElse q noop boom)))
--
-- sat_ambig_full p a b boom =
--   question (showExpr (IfThenElse p a boom) === showExpr (IfThen p b))
--
-- sat_ambig a b = question (showExpr a === showExpr b .&&. a =/= b)

sat_ambig_witness a b = question (a =/= b .&&. showExpr a === showExpr b)

-- sat_parse a p q noop boom = question (showExpr a === [IF,p,THEN,IF,q,THEN,noop,ELSE,boom])
--
-- sat_parse2 a b p q noop boom = question
--   (showExpr a === [IF,p,THEN,IF,q,THEN,noop,ELSE,boom] .&&.
--    showExpr b === [IF,p,THEN,IF,q,THEN,noop,ELSE,boom] .&&.
--    a =/= b)
--
-- sat_no_parse a p q noop boom = question
--   (showExpr a === [IF,p,THEN,q,ELSE,noop,ELSE,boom])
