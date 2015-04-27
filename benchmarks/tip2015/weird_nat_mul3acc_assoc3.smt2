; Weird functions over natural numbers
;
; Property about a trinary multiplication function, defined in terms of an
; accumulative trinary addition function
; mul3acc x y z = xyz + (xy + xz + yz) + (x + y + z) + 1
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
  ((mul3acc ((x Nat) (y Nat) (z Nat)) Nat))
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
                           (add3acc (mul3acc x2 x3 x4)
                             (add3acc (mul3acc y x3 x4) (mul3acc x2 y x4) (mul3acc x2 x3 y))
                             (add3acc x2 x3 x4))))))
                     (case (S x6)
                       (S
                       (add3acc (mul3acc x2 x3 x4)
                         (add3acc (mul3acc x x3 x4) (mul3acc x2 x x4) (mul3acc x2 x3 x))
                         (add3acc x2 x3 x4))))))
                 (case (S x7)
                   (S
                   (add3acc (mul3acc x2 x3 x4)
                     (add3acc (mul3acc (S Z) x3 x4)
                       (mul3acc x2 (S Z) x4) (mul3acc x2 x3 (S Z)))
                     (add3acc x2 x3 x4)))))))))))))
(assert-not
  (forall ((x1 Nat) (x2 Nat) (x3acc Nat) (x4 Nat) (x5 Nat))
    (= (mul3acc x1 (mul3acc x2 x3acc x4) x5)
      (mul3acc x1 x2 (mul3acc x3acc x4 x5)))))
(check-sat)
