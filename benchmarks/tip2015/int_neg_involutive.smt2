; Integers implemented using natural numbers (from Agda standard library)
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes () ((Z2 (P (P_ Nat)) (N (N_ Nat)))))
(define-funs-rec
  ((neg ((x Z2)) Z2))
  ((match x
     (case
       (P ds)
       (match ds
         (case Z x)
         (case (S n) (N n))))
     (case (N n2) (P (S n2))))))
(assert (not (forall ((x2 Z2)) (= x2 (neg (neg x2))))))
(check-sat)
