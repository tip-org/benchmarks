(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  lt
    ((x Nat) (y Nat)) Bool
    (match y
      (case Z false)
      (case (S z)
        (match x
          (case Z true)
          (case (S n) (lt n z))))))
(assert-not
  (forall ((x Nat) (y Nat) (z Nat))
    (=> (lt x y) (=> (lt y z) (lt x z)))))
(check-sat)
