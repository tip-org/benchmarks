; Very simple questions about natural numbers
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S n) (S (plus n y)))))
(assert-not (forall ((x Nat)) (distinct (plus x x) x)))
(check-sat)
