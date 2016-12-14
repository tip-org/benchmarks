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
  formula-pow
    ((x Nat) (y Nat)) Nat
    (match y
      (case Z (S Z))
      (case (S z) (times x (formula-pow x z)))))
(assert-not (forall ((x Nat)) (= (formula-pow (S Z) x) (S Z))))
(check-sat)
