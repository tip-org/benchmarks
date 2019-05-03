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
(prove
  (forall ((x Nat) (y Nat))
    (= (ite (leq x y) y x) (ite (leq y x) x y))))
