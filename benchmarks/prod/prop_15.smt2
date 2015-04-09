; Source: Productive use of failure
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x Nat) (x2 Nat)) Nat))
  ((match x
     (case Z x2)
     (case (S x3) (S (plus x3 x2))))))
(assert
  (not (forall ((x4 Nat)) (= (plus x4 (S x4)) (S (plus x4 x4))))))
(check-sat)
