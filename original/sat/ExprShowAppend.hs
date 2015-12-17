module Expr where

import Tip.Prelude
import qualified Prelude

data Expr
  = IfThen     Expr Expr
  | IfThenElse Expr Expr Expr
  | Var Nat
  | Add Expr Expr

data Tok = IF | THEN | ELSE | N Nat | PLUS | STAR | C | D

data List a = Sing a | List a :++: List a

flatten :: List a -> [a]
flatten (Sing x)     = [x]
flatten (u :++: v) = flatten u ++ flatten v

showExpr :: Expr -> List Tok
showExpr (IfThen     b t)   = Sing IF :++: showExpr b :++: Sing THEN :++: showExpr t
showExpr (IfThenElse b t f) = Sing IF :++: showExpr b :++: Sing THEN :++: showExpr t :++: Sing ELSE :++: showExpr f
showExpr (Var x)            = Sing (N x)
showExpr (Add a b)          = Sing C :++: showExpr a :++: Sing PLUS :++: showExpr b :++: Sing D

showAdd :: Expr -> List Tok
showAdd e = showExpr e
{-
showAdd e@Add{} = Sing C :++: showExpr e :++: Sing D
showAdd e       = showExpr e
-}

{-
showMul :: Expr -> Sing Tok
showMul e@Add{} = Sing C :++: showExpr e :++: Sing D
showMul e@Mul{} = Sing C :++: showExpr e :++: Sing D
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

sat_ambig_witness a b = question (a =/= b .&&. flatten (showExpr a) === flatten (showExpr b))

-- sat_parse a p q noop boom = question (showExpr a === [IF,p,THEN,IF,q,THEN,noop,ELSE,boom])
--
-- sat_parse2 a b p q noop boom = question
--   (showExpr a === [IF,p,THEN,IF,q,THEN,noop,ELSE,boom] .&&.
--    showExpr b === [IF,p,THEN,IF,q,THEN,noop,ELSE,boom] .&&.
--    a =/= b)
--
-- sat_no_parse a p q noop boom = question
--   (showExpr a === [IF,p,THEN,q,ELSE,noop,ELSE,boom])
