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
  (forall ((x Nat) (y Nat) (z Nat))
    (let
      ((y2 (ite (leq y z) y z))
       (x2 (ite (leq x y) x y)))
      (= (ite (leq x y2) x y2) (ite (leq x2 z) x2 z)))))
