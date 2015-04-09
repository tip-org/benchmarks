; Source: Productive use of failure
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x3 Nat) (x4 Nat)) Nat))
  ((match x3
     (case Z x4)
     (case (S x5) (S (plus x5 x4))))))
(define-funs-rec
  ((even ((x Nat)) bool))
  ((match x
     (case Z true)
     (case
       (S ds)
       (match ds
         (case Z false)
         (case (S x2) (even x2)))))))
(assert (not (forall ((x6 Nat)) (even (plus x6 x6)))))
(check-sat)
