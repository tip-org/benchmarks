(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  min2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z)
        (match y
          (case Z Z)
          (case (S x2) (S (min2 z x2)))))))
(define-fun-rec
  max2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z)
        (match y
          (case Z x)
          (case (S x2) (S (max2 z x2)))))))
(assert-not (forall ((x Nat) (y Nat)) (= (max2 x (min2 x y)) x)))
(check-sat)
