; Source: IsaPlanner test suite
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x3 Nat) (x4 Nat)) Nat))
  ((match x3
     (case Z x4)
     (case (S x5) (S (plus x5 x4))))))
(define-funs-rec
  ((le ((x Nat) (x2 Nat)) bool))
  ((match x
     (case Z true)
     (case
       (S ipv)
       (match x2
         (case Z false)
         (case (S ipv2) (le ipv ipv2)))))))
(assert (not (forall ((n Nat) (m Nat)) (le n (plus n m)))))
(check-sat)
