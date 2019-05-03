(declare-datatype Nat ((zero) (succ (p Nat))))
(define-fun-rec
  plus
  ((x Nat) (y Nat)) Nat
  (match x
    ((zero y)
     ((succ z) (succ (plus z y))))))
(define-fun-rec
  times
  ((x Nat) (y Nat)) Nat
  (match x
    ((zero zero)
     ((succ z) (plus y (times z y))))))
(define-fun-rec
  formula-pow3
  ((x Nat) (y Nat)) Nat
  (match y
    ((zero (succ zero))
     ((succ z) (times x (formula-pow3 x z))))))
(define-fun-rec
  formula-pow2
  ((x Nat) (y Nat)) Nat
  (match y
    ((zero (succ zero))
     ((succ z) (times x (formula-pow2 x z))))))
(define-fun-rec
  formula-pow
  ((x Nat) (y Nat)) Nat
  (match y
    ((zero (succ zero))
     ((succ z) (times x (formula-pow x z))))))
(prove
  (forall ((x Nat) (y Nat) (z Nat))
    (= (formula-pow x (plus y z))
      (times (formula-pow2 x y) (formula-pow3 x z)))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (times x (times y z)) (times (times x y) z))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert (forall ((x Nat) (y Nat)) (= (times x y) (times y x))))
(assert (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (times x (plus y z)) (plus (times x y) (times x z)))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (times (plus x y) z) (plus (times x z) (times y z)))))
(assert (forall ((x Nat)) (= (times x (succ zero)) x)))
(assert (forall ((x Nat)) (= (times (succ zero) x) x)))
(assert (forall ((x Nat)) (= (plus x zero) x)))
(assert (forall ((x Nat)) (= (plus zero x) x)))
(assert (forall ((x Nat)) (= (times x zero) zero)))
(assert (forall ((x Nat)) (= (times zero x) zero)))
