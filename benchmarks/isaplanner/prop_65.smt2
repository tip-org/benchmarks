; Source: IsaPlanner test suite
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus
      ((x4 Nat) (x5 Nat)) Nat
      (match x4
        (case Z x5)
        (case (S x6) (S (plus x6 x5)))))))
(define-funs-rec
  ((lt
      ((x Nat) (x2 Nat)) bool
      (match x2
        (case Z false)
        (case
          (S ipv)
          (match x
            (case Z true)
            (case (S x3) (lt x3 ipv))))))))
(assert (not (forall ((i Nat) (m Nat)) (lt i (S (plus m i))))))
(check-sat)
