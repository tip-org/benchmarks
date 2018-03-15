(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  lt :definition :source |<|
    ((x Nat) (y Nat)) Bool
    (match y
      (case zero false)
      (case (succ z)
        (match x
          (case zero true)
          (case (succ n) (lt n z))))))
(prove
  :source Int.prop_lt_trans
  (forall ((x Nat) (y Nat) (z Nat))
    (=> (lt x y) (=> (lt y z) (lt x z)))))
