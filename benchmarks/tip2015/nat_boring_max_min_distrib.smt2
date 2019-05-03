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
       (x2 (ite (leq x y) x y))
       (y3 (ite (leq x z) x z)))
      (= (ite (leq x y2) x y2) (ite (leq x2 y3) y3 x2)))))
