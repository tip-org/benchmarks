; Property about an alternative multiplication function with an
; interesting recursion structure that also calls an addition
; function with an accumulating parameter.
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((acc_plus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z y)
     (case (S z) (acc_plus z (S y))))))
(define-funs-rec
  ((acc_alt_mul ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z Z)
     (case (S z)
       (match y
         (case Z Z)
         (case (S x2)
           (S (acc_plus z (acc_plus x2 (acc_alt_mul z x2))))))))))
(assert-not
  (forall ((x Nat) (y Nat) (z Nat))
    (= (acc_alt_mul x (acc_alt_mul y z))
      (acc_alt_mul (acc_alt_mul x y) z))))
(check-sat)
