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
  plus2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S n) (S (plus2 n y)))))
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
      (case (S n) (plus2 y (mult n y)))))
(define-fun-rec
  minus
    ((x Nat) (y Nat)) Integer
    (match x
      (case Z
        (match y
          (case Z (P Z))
          (case (S n) (N n))))
      (case (S m)
        (match y
          (case Z (P x))
          (case (S o) (minus m o))))))
(define-fun
  plus
    ((x Integer) (y Integer)) Integer
    (match x
      (case (P m)
        (match y
          (case (P n) (P (plus2 m n)))
          (case (N o) (minus m (S o)))))
      (case (N m2)
        (match y
          (case (P n2) (minus n2 (S m2)))
          (case (N n3) (N (S (plus2 m2 n3))))))))
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
  (forall ((x Integer) (y Integer) (z Integer))
    (= (times (plus x y) z) (plus (times x z) (times y z)))))
(check-sat)
