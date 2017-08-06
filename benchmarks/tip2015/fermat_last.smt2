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
  formula-pow3 :let
    ((x Nat) (y Nat)) Nat
    (match y
      (case Z (S Z))
      (case (S z) (times x (formula-pow3 x z)))))
(define-fun-rec
  formula-pow2 :let
    ((x Nat) (y Nat)) Nat
    (match y
      (case Z (S Z))
      (case (S z) (times x (formula-pow2 x z)))))
(define-fun-rec
  formula-pow :let
    ((x Nat) (y Nat)) Nat
    (match y
      (case Z (S Z))
      (case (S z) (times x (formula-pow x z)))))
(prove
  :source Fermat.prop_last
  (forall ((n Nat) (x Nat) (y Nat) (z Nat))
    (distinct
      (plus (formula-pow (plus (S Z) x) (plus (S (S (S Z))) n))
        (formula-pow2 (plus (S Z) y) (plus (S (S (S Z))) n)))
      (formula-pow3 (plus (S Z) z) (plus (S (S (S Z))) n)))))
