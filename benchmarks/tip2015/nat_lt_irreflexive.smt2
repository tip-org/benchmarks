(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  lt
    ((x Nat) (y Nat)) Bool
    (match y
      (case zero false)
      (case (succ z)
        (match x
          (case zero true)
          (case (succ n) (lt n z))))))
(prove (forall ((x Nat)) (not (lt x x))))
