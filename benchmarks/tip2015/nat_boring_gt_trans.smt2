(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  gt
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z false)
      (case (S z)
        (match y
          (case Z true)
          (case (S x2) (gt z x2))))))
(assert-not
  (forall ((x Nat) (y Nat) (z Nat))
    (=> (gt x y) (=> (gt y z) (gt x z)))))
(check-sat)
