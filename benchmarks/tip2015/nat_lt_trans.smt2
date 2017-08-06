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
(prove
  :source Int.prop_lt_trans
  (forall ((x Nat) (y Nat) (z Nat))
    (=> (lt x y) (=> (lt y z) (lt x z)))))
