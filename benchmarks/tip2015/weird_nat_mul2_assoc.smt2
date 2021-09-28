; Weird functions over natural numbers
;
; Binary multiplication function with an interesting recursion structure,
; which calls an accumulative trinary addition function.
(declare-datatype Nat ((zero) (succ (p Nat))))
(define-fun-rec
  plus
  ((x Nat) (y Nat)) Nat
  (match x
    ((zero y)
     ((succ z) (succ (plus z y))))))
(define-fun-rec
  add3acc
  ((x Nat) (y Nat) (z Nat)) Nat
  (match x
    ((zero
      (match y
        ((zero z)
         ((succ x2) (add3acc zero x2 (succ z))))))
     ((succ x3) (add3acc x3 (succ y) z)))))
(define-fun-rec
  mul2
  ((x Nat) (y Nat)) Nat
  (match x
    ((zero zero)
     ((succ z)
      (match y
        ((zero zero)
         ((succ x2) (plus (succ zero) (add3acc z x2 (mul2 z x2))))))))))
(prove
  (forall ((x Nat) (y Nat) (z Nat))
    (= (mul2 x (mul2 y z)) (mul2 (mul2 x y) z))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert (forall ((x Nat)) (= (plus x zero) x)))
(assert (forall ((x Nat)) (= (plus zero x) x)))
