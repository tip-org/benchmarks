(declare-datatype Nat ((zero) (succ (p Nat))))
(define-fun-rec
  lt
  ((x Nat) (y Nat)) Bool
  (match y
    ((zero false)
     ((succ z)
      (match x
        ((zero true)
         ((succ n) (lt n z))))))))
(prove
  (forall ((x Nat) (y Nat) (z Nat))
    (=> (lt x y) (=> (lt y z) (lt x z)))))
