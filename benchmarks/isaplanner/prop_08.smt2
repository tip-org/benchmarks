; Source: IsaPlanner test suite
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus
      ((x3 Nat) (x4 Nat)) Nat
      (match x3
        (case Z x4)
        (case (S x5) (S (plus x5 x4)))))))
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
      ((k Nat) (m Nat) (n Nat))
      (= (minus (plus k m) (plus k n)) (minus m n)))))
(check-sat)
