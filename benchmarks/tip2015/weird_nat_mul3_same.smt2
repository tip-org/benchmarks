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
      (case (S z) (S (plus z y)))))
(define-fun-rec
  add3acc :source WeirdInt.add3acc
    ((x Nat) (y Nat) (z Nat)) Nat
    (match x
      (case Z
        (match y
          (case Z z)
          (case (S x3) (add3acc Z x3 (S z)))))
      (case (S x2) (add3acc x2 (S y) z))))
(define-fun-rec
  mul3acc :source WeirdInt.mul3acc
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
                (let
                  ((fail
                      (plus (S Z)
                        (add3acc (mul3acc x2 x3 x4)
                          (add3acc (mul3acc (S Z) x3 x4)
                            (mul3acc x2 (S Z) x4) (mul3acc x2 x3 (S Z)))
                          (add3acc x y z)))))
                  (ite
                    (= x2 Z) (ite (= x3 Z) (ite (= x4 Z) (S Z) fail) fail)
                    fail)))))))))
(define-fun-rec
  add3 :source WeirdInt.add3
    ((x Nat) (y Nat) (z Nat)) Nat
    (match x
      (case Z
        (match y
          (case Z z)
          (case (S x3) (plus (S Z) (add3 Z x3 z)))))
      (case (S x2) (plus (S Z) (add3 x2 y z)))))
(define-fun-rec
  mul3 :source WeirdInt.mul3
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
                (let
                  ((fail
                      (plus (S Z)
                        (add3 (mul3 x2 x3 x4)
                          (add3 (mul3 (S Z) x3 x4) (mul3 x2 (S Z) x4) (mul3 x2 x3 (S Z)))
                          (add3 x2 x3 x4)))))
                  (ite
                    (= x2 Z) (ite (= x3 Z) (ite (= x4 Z) (S Z) fail) fail)
                    fail)))))))))
(prove
  :source WeirdInt.prop_mul3_same
  (forall ((x Nat) (y Nat) (z Nat))
    (= (mul3 x y z) (mul3acc x y z))))
