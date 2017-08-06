; Property about accumulative addition function.
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus z y)))))
(define-fun-rec
  acc_plus :source Int.acc_plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (acc_plus z (S y)))))
(prove
  :source Int.prop_acc_plus_same
  (forall ((x Nat) (y Nat)) (= (plus x y) (acc_plus x y))))
