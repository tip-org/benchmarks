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
  :source Int.prop_lt_ne
  (forall ((x Nat) (y Nat)) (=> (lt y x) (distinct x y))))
