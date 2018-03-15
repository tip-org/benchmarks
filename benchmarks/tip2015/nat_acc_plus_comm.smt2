; Property about accumulative addition function.
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  acc_plus :source Int.acc_plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero y)
      (case (succ z) (acc_plus z (succ y)))))
(prove
  :source Int.prop_acc_plus_comm
  (forall ((x Nat) (y Nat)) (= (acc_plus x y) (acc_plus y x))))
