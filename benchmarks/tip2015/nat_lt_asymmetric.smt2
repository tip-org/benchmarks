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
  (forall ((x Nat) (y Nat)) (=> (lt x y) (not (lt y x)))))
(check-sat)
