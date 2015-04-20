; Source: Productive use of failure
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z y)
     (case (S z) (S (plus z y))))))
(define-funs-rec
  ((mult2 ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z x)
     (case (S z) (plus y (mult2 z y))))))
(define-funs-rec
  ((mult ((x Nat) (y Nat) (z Nat)) Nat))
  ((match x
     (case Z z)
     (case (S x2) (mult x2 y (plus y z))))))
(assert-not
  (forall ((x Nat) (y Nat)) (= (mult2 x y) (mult x y Z))))
(check-sat)
