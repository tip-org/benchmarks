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
  :source Int.prop_boring_max_min_distrib
  (forall ((x Nat) (y Nat) (z Nat))
    (= (let ((y2 (ite (le y z) z y))) (ite (le x y2) x y2))
      (ite
        (le x z)
        (@
          (let ((x3 (ite (le x y) x y)))
            (lambda ((y4 Nat)) (ite (le x3 y4) y4 x3)))
          x)
        (@
          (let ((x2 (ite (le x y) x y)))
            (lambda ((y3 Nat)) (ite (le x2 y3) y3 x2)))
          z)))))
