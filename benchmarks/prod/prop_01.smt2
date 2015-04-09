; Source: Productive use of failure
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x3 Nat) (x4 Nat)) Nat))
  ((match x3
     (case Z x4)
     (case (S x5) (S (plus x5 x4))))))
(define-funs-rec
  ((double ((x Nat)) Nat))
  ((match x
     (case Z x)
     (case (S x2) (S (S (double x2)))))))
(assert (not (forall ((x6 Nat)) (= (double x6) (plus x6 x6)))))
(check-sat)
