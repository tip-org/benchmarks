; Source: IsaPlanner test suite
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((min2
      ((x Nat) (x2 Nat)) Nat
      (match x
        (case Z x)
        (case
          (S x3)
          (match x2
            (case Z x2)
            (case (S y) (S (min2 x3 y)))))))))
(assert (not (forall ((a Nat) (b Nat)) (= (min2 a b) (min2 b a)))))
(check-sat)
