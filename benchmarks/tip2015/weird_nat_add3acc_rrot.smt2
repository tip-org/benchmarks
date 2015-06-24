; Weird functions over natural numbers
;
; Property about accumulative trinary addition function
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  add3acc
    ((x Nat) (y Nat) (z Nat)) Nat
    (match x
      (case Z
        (match y
          (case Z z)
          (case (S y2) (add3acc Z y2 (S z)))))
      (case (S x2) (add3acc x2 (S y) z))))
(assert-not
  (forall ((x Nat) (y Nat) (z Nat))
    (= (add3acc x y z) (add3acc z x y))))
(check-sat)
