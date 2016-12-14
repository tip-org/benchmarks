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
(define-fun ge ((x Nat) (y Nat)) Bool (le y x))
(assert-not
  (forall ((x Nat) (y Nat)) (=> (ge x y) (=> (ge y x) (= x y)))))
(check-sat)
