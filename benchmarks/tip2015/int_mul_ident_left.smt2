; The implementation of these integers correspond to those in the
; Agda standard library, which is proved to be a commutative ring
(declare-datatypes ()
  ((Sign :source Integers.Sign (Pos :source Integers.Pos)
     (Neg :source Integers.Neg))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes ()
  ((Integer :source Integers.Integer
     (P :source Integers.P (proj1-P Nat))
     (N :source Integers.N (proj1-N Nat)))))
(define-fun
  toInteger :source Integers.toInteger
    ((x Sign) (y Nat)) Integer
    (match x
      (case Pos (P y))
      (case Neg
        (match y
          (case Z (P Z))
          (case (S z) (N z))))))
(define-fun
  sign :source Integers.sign
    ((x Integer)) Sign
    (match x
      (case (P y) Pos)
      (case (N z) Neg)))
(define-fun
  pred :source Integers.pred ((x Nat)) Nat (match x (case (S y) y)))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus z y)))))
(define-fun-rec
  times2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z) (plus y (times2 z y)))))
(define-fun
  opposite :source Integers.opposite
    ((x Sign)) Sign
    (match x
      (case Pos Neg)
      (case Neg Pos)))
(define-fun
  timesSign :source Integers.timesSign
    ((x Sign) (y Sign)) Sign
    (match x
      (case Pos y)
      (case Neg (opposite y))))
(define-fun one :source Integers.one () Integer (P (S Z)))
(define-fun
  absVal :source Integers.absVal
    ((x Integer)) Nat
    (match x
      (case (P n) n)
      (case (N m) (plus (S Z) m))))
(define-fun
  times :source Integers.times
    ((x Integer) (y Integer)) Integer
    (toInteger (timesSign (sign x) (sign y))
      (times2 (absVal x) (absVal y))))
(prove
  :source Integers.prop_mul_ident_left
  (forall ((x Integer)) (= x (times one x))))
