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
(prove (forall ((x Nat) (y Nat)) (=> (gt x y) (not (gt y x)))))
