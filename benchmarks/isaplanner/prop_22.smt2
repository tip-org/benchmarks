; Source: IsaPlanner test suite
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((max2
      ((x Nat) (x2 Nat)) Nat
      (match x
        (case Z x2)
        (case
          (S ipv)
          (match x2
            (case Z x)
            (case (S ipv2) (S (max2 ipv ipv2)))))))))
(assert
  (not
    (forall
      ((a Nat) (b Nat) (c Nat))
      (= (max2 (max2 a b) c) (max2 a (max2 b c))))))
(check-sat)
