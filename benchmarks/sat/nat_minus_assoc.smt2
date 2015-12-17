; Very simple questions about natural numbers
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  minus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S n)
        (match y
          (case Z x)
          (case (S m) (minus n m))))))
(assert-not
  (forall ((x Nat) (y Nat) (z Nat))
    (= (minus (minus x y) z) (minus x (minus y z)))))
(check-sat)
