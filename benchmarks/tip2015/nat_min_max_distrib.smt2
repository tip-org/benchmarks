(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  leq
    ((x Nat) (y Nat)) Bool
    (match x
      (case zero true)
      (case (succ z)
        (match y
          (case zero false)
          (case (succ x2) (leq z x2))))))
(prove
  (forall ((x Nat) (y Nat) (z Nat))
    (let
      ((y2 (ite (leq y z) y z))
       (x2 (ite (leq x y) y x))
       (y3 (ite (leq x z) z x)))
      (= (ite (leq x y2) y2 x) (ite (leq x2 y3) x2 y3)))))
