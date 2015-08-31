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
(assert-not (forall ((x Nat)) (= (max2 x x) x)))
(check-sat)
