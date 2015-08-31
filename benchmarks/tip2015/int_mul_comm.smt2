; The implementation of these integers correspond to those in the
; Agda standard library, which is proved to be a commutative ring
(declare-datatypes () ((Sign (Pos) (Neg))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes () ((Integer (P (P_0 Nat)) (N (N_0 Nat)))))
(define-fun
  toInteger
    ((x Sign) (y Nat)) Integer
    (match x
      (case Pos (P y))
      (case Neg
        (match y
          (case Z (P Z))
          (case (S m) (N m))))))
(define-fun
  sign
    ((x Integer)) Sign
    (match x
      (case (P y) Pos)
      (case (N z) Neg)))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S n) (S (plus n y)))))
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
      (case Z Z)
      (case (S n) (plus y (mult n y)))))
(define-fun
  absVal
    ((x Integer)) Nat
    (match x
      (case (P n) n)
      (case (N m) (S m))))
(define-fun
  times
    ((x Integer) (y Integer)) Integer
    (toInteger (timesSign (sign x) (sign y))
      (mult (absVal x) (absVal y))))
(assert-not
  (forall ((x Integer) (y Integer)) (= (times x y) (times y x))))
(check-sat)
