(declare-datatype Nat ((zero) (succ (p Nat))))
(define-fun-rec
  leq
  ((x Nat) (y Nat)) Bool
  (match x
    ((zero true)
     ((succ z)
      (match y
        ((zero false)
         ((succ x2) (leq z x2))))))))
(define-fun
  geq
  ((x Nat) (y Nat)) Bool (leq y x))
(prove
  (forall ((x Nat) (y Nat) (z Nat))
    (=> (geq x y) (=> (geq y z) (geq x z)))))
