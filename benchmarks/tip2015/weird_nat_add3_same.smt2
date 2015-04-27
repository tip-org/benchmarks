; Weird functions over natural numbers
;
; Property about accumulative trinary addition function
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((add3acc ((x Nat) (y Nat) (z Nat)) Nat))
  ((match x
     (case Z
       (match y
         (case Z z)
         (case (S y2) (add3acc x y2 (S z)))))
     (case (S x2) (add3acc x2 (S y) z)))))
(define-funs-rec
  ((add3 ((x Nat) (y Nat) (z Nat)) Nat))
  ((match x
     (case Z
       (match y
         (case Z z)
         (case (S y2) (S (add3 x y2 z)))))
     (case (S x2) (S (add3 x2 y z))))))
(assert-not
  (forall ((x Nat) (y Nat) (z Nat))
    (= (add3 x y z) (add3acc x y z))))
(check-sat)
