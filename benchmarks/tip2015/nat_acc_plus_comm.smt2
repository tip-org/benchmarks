; Property about accumulative addition function.
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  acc_plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero y)
      (case (succ z) (acc_plus z (succ y)))))
(prove
  (forall ((x Nat) (y Nat)) (= (acc_plus x y) (acc_plus y x))))
