(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  lt :definition :source |<|
    ((x Nat) (y Nat)) Bool
    (match y
      (case zero false)
      (case (succ z)
        (match x
          (case zero true)
          (case (succ n) (lt n z))))))
(define-fun-rec
  leq :definition :source |<=|
    ((x Nat) (y Nat)) Bool
    (match x
      (case zero true)
      (case (succ z)
        (match y
          (case zero false)
          (case (succ x2) (leq z x2))))))
(prove
  :source Int.prop_le_ne_lt
  (forall ((x Nat) (y Nat))
    (=> (leq x y) (=> (distinct x y) (lt x y)))))
