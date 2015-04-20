; Source: Productive use of failure
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z y)
     (case (S z) (S (plus z y))))))
(define-funs-rec
  ((even ((x Nat)) bool))
  ((match x
     (case Z true)
     (case (S y)
       (match y
         (case Z false)
         (case (S z) (even z)))))))
(assert-not (forall ((x Nat)) (even (plus x x))))
(check-sat)
