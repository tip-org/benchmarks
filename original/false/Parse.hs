module Parse where

import Prelude hiding (Show(show), Char, String)
import Tip

type String = [Char]

data Char = PAR1 | PAR2 | PLUS | MULT | CHARX
          | DIG0 | DIG1 | DIG2
          | DIG3 | DIG4 | DIG5
          | DIG6 | DIG7 | DIG8 | DIG9

data Expr
  = X
  | Add Expr Expr
  | Mul Expr Expr
  | Num Int

show :: Expr -> String
show X         = [CHARX]
show (Add a b) = show a ++ [PLUS] ++ show b
show (Mul a b) = showF a ++ [MULT] ++ showF b
show (Num n)   = showNum n

showF a@(Add _ _) = PAR1 : show a ++ [PAR2]
showF a           = show a

showNum :: Int -> String
showNum 0 = [DIG0]
showNum n = num [] n
 where
  num ds 0 = ds
  num ds n = num (a:ds) n'
   where
    (a,n') = mod10 n

mod10 :: Int -> (Char,Int)
mod10 n =
  case min10 n of
    Left d   -> (d, 0)
    Right n' -> let (d,n'') = mod10 n' in (d, succ n'')

min10 :: Int -> Either Char Int
min10 0 = Left DIG0
min10 1 = Left DIG1
min10 2 = Left DIG2
min10 3 = Left DIG3
min10 4 = Left DIG4
min10 5 = Left DIG5
min10 6 = Left DIG6
min10 7 = Left DIG7
min10 8 = Left DIG8
min10 9 = Left DIG9
min10 n = Right (n-10)

prop1 e = show e === [CHARX,PLUS,DIG0,MULT,CHARX] ==> True === False
prop2 e = show e === [PAR1,CHARX,PLUS,DIG1,DIG3,PAR2,MULT,CHARX] ==> True === False
prop3 e = show e === [PAR1,PAR1,CHARX,PLUS,DIG5,PAR2,PLUS,DIG7,PAR2,MULT,CHARX] ==> True === False

depth :: Int -> Expr -> Bool
depth d (Add a b) = depth (pred d) a && depth (pred d) b
depth d (Mul a b) = depth (pred d) a && depth (pred d) b
depth d     (Num n)   = n <= d
depth _     X         = True
depth _     _         = False

e = Add X (Num 0 `Mul` X)
