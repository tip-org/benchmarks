; Property about an alternative multiplication function which exhibits an
; interesting recursion structure.
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  plus :definition :source |+|
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero y)
      (case (succ z) (succ (plus z y)))))
(define-fun-rec
  times :definition :source |*|
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero zero)
      (case (succ z) (plus y (times z y)))))
(define-fun-rec
  alt_mul :source Int.alt_mul
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero zero)
      (case (succ z)
        (match y
          (case zero zero)
          (case (succ x2)
            (plus (plus (plus (succ zero) (alt_mul z x2)) z) x2))))))
(prove
  :source Int.prop_alt_mul_same
  (forall ((x Nat) (y Nat)) (= (alt_mul x y) (times x y))))
(assert
  :axiom |associativity of *|
  (forall ((x Nat) (y Nat) (z Nat))
    (= (times x (times y z)) (times (times x y) z))))
(assert
  :axiom |associativity of +|
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert
  :axiom |commutativity of *|
  (forall ((x Nat) (y Nat)) (= (times x y) (times y x))))
(assert
  :axiom |commutativity of +|
  (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert
  :axiom distributivity
  (forall ((x Nat) (y Nat) (z Nat))
    (= (times x (plus y z)) (plus (times x y) (times x z)))))
(assert
  :axiom distributivity
  (forall ((x Nat) (y Nat) (z Nat))
    (= (times (plus x y) z) (plus (times x z) (times y z)))))
(assert
  :axiom |identity for *|
  (forall ((x Nat)) (= (times x (succ zero)) x)))
(assert
  :axiom |identity for *|
  (forall ((x Nat)) (= (times (succ zero) x) x)))
(assert
  :axiom |identity for +|
  (forall ((x Nat)) (= (plus x zero) x)))
(assert
  :axiom |identity for +|
  (forall ((x Nat)) (= (plus zero x) x)))
(assert
  :axiom |zero for *|
  (forall ((x Nat)) (= (times x zero) zero)))
(assert
  :axiom |zero for *|
  (forall ((x Nat)) (= (times zero x) zero)))
