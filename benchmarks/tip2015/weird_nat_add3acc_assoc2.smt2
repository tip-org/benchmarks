; Weird functions over natural numbers
;
; Property about accumulative trinary addition function
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  add3acc :source WeirdInt.add3acc
    ((x Nat) (y Nat) (z Nat)) Nat
    (match x
      (case zero
        (match y
          (case zero z)
          (case (succ x3) (add3acc zero x3 (succ z)))))
      (case (succ x2) (add3acc x2 (succ y) z))))
(prove
  :source WeirdInt.prop_add3acc_assoc2
  (forall ((x1 Nat) (x2 Nat) (x3 Nat) (x4 Nat) (x5 Nat))
    (= (add3acc (add3acc x1 x2 x3) x4 x5)
      (add3acc x1 (add3acc x2 x3 x4) x5))))
