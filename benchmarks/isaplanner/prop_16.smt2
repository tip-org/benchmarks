; Source: IsaPlanner test suite
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((last ((x (list Nat))) Nat))
  ((match x
     (case nil Z)
     (case (cons y z)
       (match z
         (case nil y)
         (case (cons x2 x3) (last z)))))))
(assert-not
  (forall ((x Nat) (xs (list Nat)))
    (=> (= xs (as nil (list Nat))) (= (last (cons x xs)) x))))
(check-sat)
