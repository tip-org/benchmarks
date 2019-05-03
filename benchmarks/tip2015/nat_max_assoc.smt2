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
      ((y2 (ite (leq y z) z y))
       (x2 (ite (leq x y) y x)))
      (= (ite (leq x y2) y2 x) (ite (leq x2 z) z x2)))))
