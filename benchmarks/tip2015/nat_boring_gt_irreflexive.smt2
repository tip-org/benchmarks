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
(define-fun gt ((x Nat) (y Nat)) Bool (lt y x))
(assert-not (forall ((x Nat)) (not (gt x x))))
(check-sat)
