(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  max2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z)
        (match y
          (case Z x)
          (case (S x2) (S (max2 z x2)))))))
(assert-not
  (forall ((x Nat) (y Nat) (z Nat))
    (= (max2 x (max2 y z)) (max2 (max2 x y) z))))
(check-sat)
