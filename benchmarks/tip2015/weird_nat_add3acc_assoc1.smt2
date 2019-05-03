; Weird functions over natural numbers
;
; Property about accumulative trinary addition function
(declare-datatype Nat ((zero) (succ (p Nat))))
(define-fun-rec
  add3acc
  ((x Nat) (y Nat) (z Nat)) Nat
  (match x
    ((zero
      (match y
        ((zero z)
         ((succ x3) (add3acc zero x3 (succ z))))))
     ((succ x2) (add3acc x2 (succ y) z)))))
(prove
  (forall ((x1 Nat) (x2 Nat) (x3 Nat) (x4 Nat) (x5 Nat))
    (= (add3acc (add3acc x1 x2 x3) x4 x5)
      (add3acc x1 x2 (add3acc x3 x4 x5)))))
