; Property about accumulative addition function.
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((acc_plus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z y)
     (case (S z) (acc_plus z (S y))))))
(assert-not
  (forall ((x Nat) (y Nat)) (= (acc_plus x y) (acc_plus y x))))
(check-sat)
