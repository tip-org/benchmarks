; 2^n < n! for n > 3
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
  lt
    ((x Nat) (y Nat)) Bool
    (match y
      (case Z false)
      (case (S z)
        (match x
          (case Z true)
          (case (S n) (lt n z))))))
(define-fun-rec
  formula-pow :let
    ((x Nat) (y Nat)) Nat
    (match y
      (case Z (S Z))
      (case (S z) (times x (formula-pow x z)))))
(define-fun-rec
  factorial :source Int.factorial
    ((x Nat)) Nat
    (match x
      (case Z (S Z))
      (case (S y) (times x (factorial y)))))
(prove
  :source Int.prop_pow_le_factorial
  (forall ((n Nat))
    (lt (formula-pow (S (S Z)) (plus (S (S (S (S Z)))) n))
      (factorial (plus (S (S (S (S Z)))) n)))))
