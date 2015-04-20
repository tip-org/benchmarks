; Source: IsaPlanner test suite
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z y)
     (case (S z) (S (plus z y))))))
(define-funs-rec
  ((minus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z x)
     (case (S z)
       (match y
         (case Z x)
         (case (S x2) (minus z x2)))))))
(assert-not
  (forall ((i Nat) (j Nat) (k Nat))
    (= (minus (minus i j) k) (minus i (plus j k)))))
(check-sat)
