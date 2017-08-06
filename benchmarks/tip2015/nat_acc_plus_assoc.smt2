; Property about accumulative addition function.
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  acc_plus :source Int.acc_plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (acc_plus z (S y)))))
(prove
  :source Int.prop_acc_plus_assoc
  (forall ((x Nat) (y Nat) (z Nat))
    (= (acc_plus x (acc_plus y z)) (acc_plus (acc_plus x y) z))))
