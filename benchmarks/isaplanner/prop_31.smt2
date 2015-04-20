; Source: IsaPlanner test suite
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((min2 ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z x)
     (case (S z)
       (match y
         (case Z y)
         (case (S y1) (S (min2 z y1))))))))
(assert-not
  (forall ((a Nat) (b Nat) (c Nat))
    (= (min2 (min2 a b) c) (min2 a (min2 b c)))))
(check-sat)
