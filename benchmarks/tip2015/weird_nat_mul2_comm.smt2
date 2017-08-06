; Weird functions over natural numbers
;
; Binary multiplication function with an interesting recursion structure,
; which calls an accumulative trinary addition function.
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
  mul2 :source WeirdInt.mul2
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z)
        (match y
          (case Z Z)
          (case (S x2) (plus (S Z) (add3acc z x2 (mul2 z x2))))))))
(prove
  :source WeirdInt.prop_mul2_comm
  (forall ((x Nat) (y Nat)) (= (mul2 x y) (mul2 y x))))
