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
(prove
  :source WeirdInt.prop_mul3acc_assoc2
  (forall ((x1 Nat) (x2 Nat) (x3acc Nat) (x4 Nat) (x5 Nat))
    (= (mul3acc (mul3acc x1 x2 x3acc) x4 x5)
      (mul3acc x1 (mul3acc x2 x3acc x4) x5))))
