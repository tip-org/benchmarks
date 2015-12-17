{-# LANGUAGE CPP #-}
module Parse where

import Tip.Prelude
import qualified Prelude as P

data Char = PAR1 | PAR2 | PLUS | MULT | CHARX
          | DIG0 | DIG1 | DIG2
          | DIG3 | DIG4 | DIG5
          | DIG6 | DIG7 | DIG8 | DIG9
 deriving ( P.Show )

left Z     = X
left (S n) = Add (Mul (left n) X) X

right Z     = X
right (S n) = Add X (Mul X (right n))

digits Z     = X
digits (S n) = Num (S n * S n) `Add` digits n

PAR1 `eqC` PAR1 = True
PAR2 `eqC` PAR2 = True
PLUS `eqC` PLUS = True
MULT `eqC` MULT = True
CHARX `eqC` CHARX = True
DIG0 `eqC` DIG0 = True
DIG1 `eqC` DIG1 = True
DIG2 `eqC` DIG2 = True
DIG3 `eqC` DIG3 = True
DIG4 `eqC` DIG4 = True
DIG5 `eqC` DIG5 = True
DIG6 `eqC` DIG6 = True
DIG7 `eqC` DIG7 = True
DIG8 `eqC` DIG8 = True
DIG9 `eqC` DIG9 = True
_    `eqC` _    = False

data Expr
  = X
  | Add Expr Expr
  | Mul Expr Expr
  | Num Nat
 deriving ( P.Show )

type String = [Char]

show :: Expr -> String
show X         = [CHARX]
show (Add a b) = show a ++ [PLUS] ++ show b
show (Mul a b) = showF a ++ [MULT] ++ showF b
show (Num n)   = showNum n

showF a@(Add _ _) = PAR1 : show a ++ [PAR2]
showF a           = show a

showNum Z = [DIG0]
showNum n = num [] n
 where
  num ds Z = ds
  num ds n = num (a:ds) n'
   where
    (a,n') = mod10 n

mod10 :: Nat -> (Char,Nat)
mod10 n =
  case min10 n of
    Left d   -> (d, Z)
    Right n' -> let (d,n'') = mod10 n' in (d, S n'')

min10 n =
  case n of
    Z -> Left DIG0
    S n1 ->
      case n1 of
        Z -> Left DIG1
        S n2 ->
          case n2 of
            Z -> Left DIG2
            S n3 ->
              case n3 of
                Z -> Left DIG3
                S n4 ->
                  case n4 of
                    Z -> Left DIG4
                    S n5 ->
                      case n5 of
                        Z -> Left DIG5
                        S n6 ->
                          case n6 of
                            Z -> Left DIG6
                            S n7 ->
                              case n7 of
                                Z -> Left DIG7
                                S n8 ->
                                  case n8 of
                                    Z -> Left DIG8
                                    S n9 ->
                                      case n9 of
                                        Z -> Left DIG9
                                        S n9 -> Right n9

target_1 e = question (show e === [CHARX,PLUS,DIG0,MULT,CHARX])
target_2 e = question (show e === [PAR1,CHARX,PLUS,DIG1,DIG3,PAR2,MULT,CHARX])
target_3 e = question (show e === [PAR1,CHARX,PLUS,DIG5,PLUS,DIG7,PAR2,MULT,CHARX])

--                                  (     (    x      +    5   )    *    x     +     7    )  *      x
target_4 e = question (show e === [PAR1,PAR1,CHARX,PLUS,DIG5,PAR2,MULT,CHARX,PLUS,DIG7,PAR2,MULT,CHARX])

target_5 e = question (show e === reverse [PAR2,PAR2,CHARX,PLUS,DIG5,PAR1,MULT,CHARX,PLUS,DIG7,PAR1,MULT,CHARX])
target_6 e = question (show e === [PAR1,DIG2,DIG5,PLUS,DIG1,DIG3,PAR2,MULT,DIG3,DIG7])

#define n3 (S (S (S Z)))
#define n4 (S n3)
#define n5 (S n4)
#define n6 (S n5)
#define n7 (S n6)
#define n8 (S n7)
#define n9 (S n8)

target_left_3 e = question (show e === show (left n3))
target_left_4 e = question (show e === show (left n4))
target_left_5 e = question (show e === show (left n5))
target_left_6 e = question (show e === show (left n6))
target_left_7 e = question (show e === show (left n7))
target_left_8 e = question (show e === show (left n8))
target_left_9 e = question (show e === show (left n9))

target_right_3 e = question (show e === show (right n3))
target_right_4 e = question (show e === show (right n4))
target_right_5 e = question (show e === show (right n5))
target_right_6 e = question (show e === show (right n6))
target_right_7 e = question (show e === show (right n7))
target_right_8 e = question (show e === show (right n8))
target_right_9 e = question (show e === show (right n9))

target_digits_3 e = question (show e === show (digits n3))
target_digits_4 e = question (show e === show (digits n4))
target_digits_5 e = question (show e === show (digits n5))
target_digits_6 e = question (show e === show (digits n6))
target_digits_7 e = question (show e === show (digits n7))
target_digits_8 e = question (show e === show (digits n8))
target_digits_9 e = question (show e === show (digits n9))
