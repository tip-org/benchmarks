; Property about an alternative multiplication function with an
; interesting recursion structure that also calls an addition
; function with an accumulating parameter.
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  acc_plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (acc_plus z (S y)))))
(define-fun-rec
  acc_alt_mul
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z)
        (match y
          (case Z Z)
          (case (S x2) (acc_plus x (acc_plus x2 (acc_alt_mul z x2))))))))
(assert-not
  (forall ((x Nat) (y Nat)) (= (acc_alt_mul x y) (acc_alt_mul y x))))
(check-sat)
