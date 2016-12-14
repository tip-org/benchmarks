; Property about the power function over naturals.
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus z y)))))
(define-fun-rec
  times
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z) (plus y (times z y)))))
(define-fun-rec
  formula-pow3
    ((x Nat) (y Nat)) Nat
    (match y
      (case Z (S Z))
      (case (S z) (times x (formula-pow3 x z)))))
(define-fun-rec
  formula-pow2
    ((x Nat) (y Nat)) Nat
    (match y
      (case Z (S Z))
      (case (S z) (times x (formula-pow2 x z)))))
(define-fun-rec
  formula-pow
    ((x Nat) (y Nat)) Nat
    (match y
      (case Z (S Z))
      (case (S z) (times x (formula-pow x z)))))
(assert-not
  (forall ((x Nat) (y Nat) (z Nat))
    (= (formula-pow x (times y z))
      (formula-pow2 (formula-pow3 x y) z))))
(check-sat)
