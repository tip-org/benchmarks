; Source: Productive use of failure
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z y)
     (case (S z) (S (plus z y))))))
(define-funs-rec
  ((half ((x Nat)) Nat))
  ((match x
     (case Z x)
     (case (S y)
       (match y
         (case Z y)
         (case (S z) (S (half z))))))))
(assert-not (forall ((x Nat)) (= (half (plus x x)) x)))
(check-sat)
