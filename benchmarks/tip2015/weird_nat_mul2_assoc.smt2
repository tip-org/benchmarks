; Weird functions over natural numbers
;
; Binary multiplication function with an interesting recursion structure,
; which calls an accumulative trinary addition function.
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((add3acc ((x Nat) (y Nat) (z Nat)) Nat))
  ((match x
     (case Z
       (match y
         (case Z z)
         (case (S y2) (add3acc Z y2 (S z)))))
     (case (S x2) (add3acc x2 (S y) z)))))
(define-funs-rec
  ((mul2 ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z Z)
     (case (S z)
       (match y
         (case Z Z)
         (case (S x2) (S (add3acc z x2 (mul2 z x2)))))))))
(assert-not
  (forall ((x Nat) (y Nat) (z Nat))
    (= (mul2 x (mul2 y z)) (mul2 (mul2 x y) z))))
(check-sat)
