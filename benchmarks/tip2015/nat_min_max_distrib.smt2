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
  (forall ((x Nat) (y Nat) (z Nat))
    (= (let ((y2 (ite (le y z) y z))) (ite (le x y2) y2 x))
      (ite
        (le x z)
        (@
          (let ((x3 (ite (le x y) y x)))
            (lambda ((y4 Nat)) (ite (le x3 y4) x3 y4)))
          z)
        (@
          (let ((x2 (ite (le x y) y x)))
            (lambda ((y3 Nat)) (ite (le x2 y3) x2 y3)))
          x)))))
(check-sat)
