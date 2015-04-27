; Weird functions over natural numbers
;
; Property about a trinary multiplication function, defined in terms of an
; trinary addition function
; mul3 x y z = xyz + (xy + xz + yz) + (x + y + z) + 1
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((add3 ((x Nat) (y Nat) (z Nat)) Nat))
  ((match x
     (case Z
       (match y
         (case Z z)
         (case (S y2) (S (add3 x y2 z)))))
     (case (S x2) (S (add3 x2 y z))))))
(define-funs-rec
  ((mul3 ((x Nat) (y Nat) (z Nat)) Nat))
  ((match x
     (case Z x)
     (case (S x2)
       (match y
         (case Z y)
         (case (S x3)
           (match z
             (case Z z)
             (case (S x4)
               (match x2
                 (case Z
                   (match x3
                     (case Z
                       (match x4
                         (case Z z)
                         (case (S x5)
                           (S
                           (add3 (mul3 x2 x3 x4)
                             (add3 (mul3 y x3 x4) (mul3 x2 y x4) (mul3 x2 x3 y))
                             (add3 x2 x3 x4))))))
                     (case (S x6)
                       (S
                       (add3 (mul3 x2 x3 x4)
                         (add3 (mul3 x x3 x4) (mul3 x2 x x4) (mul3 x2 x3 x))
                         (add3 x2 x3 x4))))))
                 (case (S x7)
                   (S
                   (add3 (mul3 x2 x3 x4)
                     (add3 (mul3 (S Z) x3 x4) (mul3 x2 (S Z) x4) (mul3 x2 x3 (S Z)))
                     (add3 x2 x3 x4)))))))))))))
(assert-not
  (forall ((x Nat) (y Nat) (z Nat)) (= (mul3 x y z) (mul3 x z y))))
(check-sat)
