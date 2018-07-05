; Property about an alternative multiplication function with an
; interesting recursion structure that also calls an addition
; function with an accumulating parameter.
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  acc_plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero y)
      (case (succ z) (acc_plus z (succ y)))))
(define-fun-rec
  acc_alt_mul
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero zero)
      (case (succ z)
        (match y
          (case zero zero)
          (case (succ x2) (acc_plus x (acc_plus x2 (acc_alt_mul z x2))))))))
(prove
  (forall ((x Nat) (y Nat)) (= (acc_alt_mul x y) (acc_alt_mul y x))))
