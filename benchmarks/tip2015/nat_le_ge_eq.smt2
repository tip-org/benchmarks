(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  leq :definition :source |<=|
    ((x Nat) (y Nat)) Bool
    (match x
      (case zero true)
      (case (succ z)
        (match y
          (case zero false)
          (case (succ x2) (leq z x2))))))
(define-fun
  geq :definition :source |>=| ((x Nat) (y Nat)) Bool (leq y x))
(prove
  :source Int.prop_le_ge_eq
  (forall ((x Nat) (y Nat)) (=> (geq x y) (=> (leq x y) (= x y)))))
