; Weird functions over natural numbers
;
; Property about a trinary multiplication function, defined in terms of an
; accumulative trinary addition function
; mul3acc x y z = xyz + (xy + xz + yz) + (x + y + z) + 1
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S n) (S (plus n y)))))
(define-fun-rec
  mult
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S n) (plus y (mult n y)))))
(define-fun-rec
  add3acc
    ((x Nat) (y Nat) (z Nat)) Nat
    (match x
      (case Z
        (match y
          (case Z z)
          (case (S y2) (add3acc Z y2 (S z)))))
      (case (S x2) (add3acc x2 (S y) z))))
(define-fun-rec
  mul3acc
    ((x Nat) (y Nat) (z Nat)) Nat
    (match x
      (case Z Z)
      (case (S x2)
        (match y
          (case Z Z)
          (case (S x3)
            (match z
              (case Z Z)
              (case (S x4)
                (match x2
                  (case Z
                    (match x3
                      (case Z
                        (match x4
                          (case Z (S Z))
                          (case (S x5)
                            (S
                              (add3acc (mul3acc Z Z x4)
                                (add3acc (mul3acc (S Z) Z x4)
                                  (mul3acc Z (S Z) x4) (mul3acc Z Z (S Z)))
                                (add3acc Z Z x4))))))
                      (case (S x6)
                        (S
                          (add3acc (mul3acc Z x3 x4)
                            (add3acc (mul3acc (S Z) x3 x4)
                              (mul3acc Z (S Z) x4) (mul3acc Z x3 (S Z)))
                            (add3acc Z x3 x4))))))
                  (case (S x7)
                    (S
                      (add3acc (mul3acc x2 x3 x4)
                        (add3acc (mul3acc (S Z) x3 x4)
                          (mul3acc x2 (S Z) x4) (mul3acc x2 x3 (S Z)))
                        (add3acc x2 x3 x4))))))))))))
(assert-not
  (forall ((x Nat) (y Nat) (z Nat))
    (= (mul3acc x y z) (mult (mult x y) z))))
(check-sat)
