; Source: IsaPlanner test suite
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((le ((x Nat) (y Nat)) bool))
  ((match x
     (case Z true)
     (case (S z)
       (match y
         (case Z false)
         (case (S x2) (le z x2)))))))
(assert-not (forall ((m Nat) (n Nat)) (=> (le m n) (le m (S n)))))
(check-sat)
