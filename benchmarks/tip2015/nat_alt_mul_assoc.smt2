; Property about an alternative multiplication function which exhibits an
; interesting recursion structure.
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus z y)))))
(define-fun-rec
  alt_mul :source Int.alt_mul
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z)
        (match y
          (case Z Z)
          (case (S x2) (plus (plus (plus (S Z) (alt_mul z x2)) z) x2))))))
(prove
  :source Int.prop_alt_mul_assoc
  (forall ((x Nat) (y Nat) (z Nat))
    (= (alt_mul x (alt_mul y z)) (alt_mul (alt_mul x y) z))))
