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
  :source Int.prop_boring_max_min_abs
  (forall ((x Nat) (y Nat))
    (= (let ((z (ite (le x y) x y))) (ite (le x z) z x)) x)))
