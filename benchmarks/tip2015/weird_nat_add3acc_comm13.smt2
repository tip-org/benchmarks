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
  (forall ((x Nat) (y Nat) (z Nat))
    (= (add3acc x y z) (add3acc z y x))))
