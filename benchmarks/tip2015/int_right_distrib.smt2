; The implementation of these integers correspond to those in the
; Agda standard library, which is proved to be a commutative ring
(declare-datatypes () ((Sign (Pos) (Neg))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes ()
  ((Integer (P (proj1-P Nat)) (N (proj1-N Nat)))))
(define-fun-rec
  x-
    ((x Nat) (y Nat)) Integer
    (let
      ((fail
          (match y
            (case Z (P x))
            (case (S z)
              (match x
                (case Z (N y))
                (case (S x2) (x- x2 z)))))))
      (match x
        (case Z
          (match y
            (case Z (P Z))
            (case (S x4) fail)))
        (case (S x3) fail))))
(define-fun
  toInteger
    ((x Sign) (y Nat)) Integer
    (match x
      (case Pos (P y))
      (case Neg
        (match y
          (case Z (P Z))
          (case (S z) (N z))))))
(define-fun
  sign
    ((x Integer)) Sign
    (match x
      (case (P y) Pos)
      (case (N z) Neg)))
(define-fun pred ((x Nat)) Nat (match x (case (S y) y)))
(define-fun-rec
  plus2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus2 z y)))))
(define-fun-rec
  times2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z) (plus2 y (times2 z y)))))
(define-fun
  plus
    ((x Integer) (y Integer)) Integer
    (match x
      (case (P m)
        (match y
          (case (P n) (P (plus2 m n)))
          (case (N o) (x- m (plus2 (S Z) o)))))
      (case (N m2)
        (match y
          (case (P n2) (x- n2 (plus2 (S Z) m2)))
          (case (N n3) (N (plus2 (plus2 (S Z) m2) n3)))))))
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
(define-fun
  absVal
    ((x Integer)) Nat
    (match x
      (case (P n) n)
      (case (N m) (plus2 (S Z) m))))
(define-fun
  times
    ((x Integer) (y Integer)) Integer
    (toInteger (timesSign (sign x) (sign y))
      (times2 (absVal x) (absVal y))))
(assert-not
  (forall ((x Integer) (y Integer) (z Integer))
    (= (times (plus x y) z) (plus (times x z) (times y z)))))
(check-sat)
