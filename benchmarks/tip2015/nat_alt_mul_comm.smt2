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
  alt_mul
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z)
        (match y
          (case Z Z)
          (case (S x2) (plus (plus (plus (S Z) (alt_mul z x2)) z) x2))))))
(assert-not
  (forall ((x Nat) (y Nat)) (= (alt_mul x y) (alt_mul y x))))
(check-sat)
