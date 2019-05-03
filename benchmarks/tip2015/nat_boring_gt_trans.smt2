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
(define-fun
  gt
  ((x Nat) (y Nat)) Bool (lt y x))
(prove
  (forall ((x Nat) (y Nat) (z Nat))
    (=> (gt x y) (=> (gt y z) (gt x z)))))
