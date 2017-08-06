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
  :source WeirdInt.prop_add3acc_comm13
  (forall ((x Nat) (y Nat) (z Nat))
    (= (add3acc x y z) (add3acc z y x))))
