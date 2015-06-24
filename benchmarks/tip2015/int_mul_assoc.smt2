; The implementation of these integers correspond to those in the
; Agda standard library, which is proved to be a commutative ring
(declare-datatypes () ((Sign (Pos) (Neg))))
(declare-datatypes () ((Nat (Zero) (Succ (pred Nat)))))
(declare-datatypes () ((Z (P (P_0 Nat)) (N (N_0 Nat)))))
(define-fun
  toInteger
    ((x Sign) (y Nat)) Z
    (match x
      (case Pos (P y))
      (case Neg
        (match y
          (case Zero (P Zero))
          (case (Succ m) (N m))))))
(define-fun
  sign
    ((x Z)) Sign
    (match x
      (case (P y) Pos)
      (case (N z) Neg)))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Zero y)
      (case (Succ n) (Succ (plus n y)))))
(define-fun
  opposite
    ((x Sign)) Sign
    (match x
      (case Pos Neg)
      (case Neg Pos)))
(define-fun
  timesSign
    ((x Sign) (y Sign)) Sign
    (match x
      (case Pos y)
      (case Neg (opposite y))))
(define-fun-rec
  mult
    ((x Nat) (y Nat)) Nat
    (match x
      (case Zero Zero)
      (case (Succ n) (plus y (mult n y)))))
(define-fun
  absVal
    ((x Z)) Nat
    (match x
      (case (P n) n)
      (case (N m) (Succ m))))
(define-fun
  times
    ((x Z) (y Z)) Z
    (toInteger (timesSign (sign x) (sign y))
      (mult (absVal x) (absVal y))))
(assert-not
  (forall ((x Z) (y Z) (z Z))
    (= (times x (times y z)) (times (times x y) z))))
(check-sat)
