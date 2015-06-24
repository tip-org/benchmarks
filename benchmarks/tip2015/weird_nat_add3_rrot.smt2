; Weird functions over natural numbers
;
; Property about trinary addition function
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  add3
    ((x Nat) (y Nat) (z Nat)) Nat
    (match x
      (case Z
        (match y
          (case Z z)
          (case (S y2) (S (add3 Z y2 z)))))
      (case (S x2) (S (add3 x2 y z)))))
(assert-not
  (forall ((x Nat) (y Nat) (z Nat)) (= (add3 x y z) (add3 z x y))))
(check-sat)
