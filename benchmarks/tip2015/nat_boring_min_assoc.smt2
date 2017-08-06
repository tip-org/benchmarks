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
  :source Int.prop_boring_min_assoc
  (forall ((x Nat) (y Nat) (z Nat))
    (= (let ((y2 (ite (le y z) y z))) (ite (le x y2) x y2))
      (@
        (let ((x2 (ite (le x y) x y)))
          (lambda ((y3 Nat)) (ite (le x2 y3) x2 y3)))
        z))))
