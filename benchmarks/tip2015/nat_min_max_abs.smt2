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
(assert-not
  (forall ((x Nat) (y Nat))
    (= (let ((z (ite (le x y) y x))) (ite (le x z) x z)) x)))
(check-sat)
