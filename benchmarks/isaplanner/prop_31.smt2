; Source: IsaPlanner test suite
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((min2 ((x Nat) (x2 Nat)) Nat))
  ((match x
     (case Z x)
     (case
       (S x3)
       (match x2
         (case Z x2)
         (case (S y) (S (min2 x3 y))))))))
(assert
  (not
    (forall
      ((a Nat) (b Nat) (c Nat))
      (= (min2 (min2 a b) c) (min2 a (min2 b c))))))
(check-sat)
