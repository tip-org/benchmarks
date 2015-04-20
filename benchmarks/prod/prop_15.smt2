; Source: Productive use of failure
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z y)
     (case (S z) (S (plus z y))))))
(assert-not (forall ((x Nat)) (= (plus x (S x)) (S (plus x x)))))
(check-sat)
