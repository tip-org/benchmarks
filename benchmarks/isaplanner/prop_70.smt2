; Source: IsaPlanner test suite
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((le ((x Nat) (x2 Nat)) bool))
  ((match x
     (case Z true)
     (case
       (S ipv)
       (match x2
         (case Z false)
         (case (S ipv2) (le ipv ipv2)))))))
(assert
  (not (forall ((m Nat) (n Nat)) (=> (le m n) (le m (S n))))))
(check-sat)
