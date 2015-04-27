(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z y)
     (case (S n) (S (plus n y))))))
(define-funs-rec
  ((mult ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z x)
     (case (S n) (plus y (mult n y))))))
(define-funs-rec
  ((pow ((x Nat) (y Nat)) Nat))
  ((match y
     (case Z (S y))
     (case (S m) (mult x (pow x m))))))
(assert-not
  (forall ((n Nat) (x Nat) (y Nat) (z Nat))
    (=>
    (= (plus (pow (S x) (S (S (S n)))) (pow (S y) (S (S (S n)))))
      (pow (S z) (S (S (S n)))))
      false)))
(check-sat)
