; Integers implemented using natural numbers (from Agda standard library)
(declare-datatypes () ((Sign (Pos) (Neg))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes () ((Z2 (P (P_ Nat)) (N (N_ Nat)))))
(define-funs-rec
  ((toInteger ((x5 Sign) (x6 Nat)) Z2))
  ((match x5
     (case Pos (P x6))
     (case
       Neg
       (match x6
         (case Z (P x6))
         (case (S m) (N m)))))))
(define-funs-rec
  ((sign ((x11 Z2)) Sign))
  ((match x11
     (case (P ds) Pos)
     (case (N ds2) Neg))))
(define-funs-rec
  ((plus ((x Nat) (x2 Nat)) Nat))
  ((match x
     (case Z x2)
     (case (S n) (S (plus n x2))))))
(define-funs-rec
  ((opposite ((x12 Sign)) Sign))
  ((match x12
     (case Pos Neg)
     (case Neg Pos))))
(define-funs-rec
  ((timesSigns ((x7 Sign) (x8 Sign)) Sign))
  ((match x7
     (case Pos x8)
     (case Neg (opposite x8)))))
(define-funs-rec
  ((mult ((x3 Nat) (x4 Nat)) Nat))
  ((match x3
     (case Z x3)
     (case (S n2) (plus x4 (mult n2 x4))))))
(define-funs-rec
  ((abs2 ((x13 Z2)) Nat))
  ((match x13
     (case (P n3) n3)
     (case (N n4) (S n4)))))
(define-funs-rec
  ((times ((x9 Z2) (x10 Z2)) Z2))
  ((toInteger
     (timesSigns (sign x9) (sign x10)) (mult (abs2 x9) (abs2 x10)))))
(assert-not
  (forall
    ((x14 Z2) (y Z2) (z Z2))
    (= (times x14 (times y z)) (times (times x14 y) z))))
(check-sat)
