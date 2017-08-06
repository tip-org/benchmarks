; Weird functions over natural numbers
;
; Property about accumulative trinary addition function
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  add3acc :source WeirdInt.add3acc
    ((x Nat) (y Nat) (z Nat)) Nat
    (match x
      (case Z
        (match y
          (case Z z)
          (case (S x3) (add3acc Z x3 (S z)))))
      (case (S x2) (add3acc x2 (S y) z))))
(prove
  :source WeirdInt.prop_add3acc_assoc1
  (forall ((x1 Nat) (x2 Nat) (x3 Nat) (x4 Nat) (x5 Nat))
    (= (add3acc (add3acc x1 x2 x3) x4 x5)
      (add3acc x1 x2 (add3acc x3 x4 x5)))))
