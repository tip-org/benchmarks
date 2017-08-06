(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  le
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (le z x2))))))
(prove
  :source Int.prop_le_antisym
  (forall ((x Nat) (y Nat)) (=> (le x y) (=> (le y x) (= x y)))))
