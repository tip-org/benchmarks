; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((last ((x (list Nat))) Nat))
  ((match x
     (case nil Z)
     (case
       (cons x2 ds)
       (match ds
         (case nil x2)
         (case (cons ipv ipv2) (last ds)))))))
(assert-not
  (forall
    ((x3 Nat) (xs (list Nat)))
    (=> (= xs (as nil (list Nat))) (= (last (cons x3 xs)) x3))))
(check-sat)
