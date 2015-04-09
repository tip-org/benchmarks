; Source: IsaPlanner test suite
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((minus
      ((x Nat) (x2 Nat)) Nat
      (match x
        (case Z x)
        (case
          (S ipv)
          (match x2
            (case Z x)
            (case (S ipv2) (minus ipv ipv2))))))))
(assert
  (not
    (forall
      ((m Nat) (n Nat) (k Nat))
      (= (minus (minus (S m) n) (S k)) (minus (minus m n) k)))))
(check-sat)
