; Property about the power function over naturals.
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z y)
     (case (S n) (S (plus n y))))))
(define-funs-rec
  ((mult ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z Z)
     (case (S n) (plus y (mult n y))))))
(define-funs-rec
  ((pow ((x Nat) (y Nat)) Nat))
  ((match y
     (case Z (S Z))
     (case (S m) (mult x (pow x m))))))
(assert-not
  (forall ((x Nat) (y Nat) (z Nat))
    (= (pow x (mult y z)) (pow (pow x y) z))))
(check-sat)
