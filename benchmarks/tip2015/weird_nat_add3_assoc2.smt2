; Weird functions over natural numbers
;
; Property about trinary addition function
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((add3 ((x Nat) (y Nat) (z Nat)) Nat))
  ((match x
     (case Z
       (match y
         (case Z z)
         (case (S y2) (S (add3 x y2 z)))))
     (case (S x2) (S (add3 x2 y z))))))
(assert-not
  (forall ((x1 Nat) (x2 Nat) (x3 Nat) (x4 Nat) (x5 Nat))
    (= (add3 (add3 x1 x2 x3) x4 x5) (add3 x1 (add3 x2 x3 x4) x5))))
(check-sat)
