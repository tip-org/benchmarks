; Source: IsaPlanner test suite
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a) (null ((x (list a))) bool)))
  ((match x
     (case nil true)
     (case (cons y z) false))))
(define-funs-rec
  ((last ((x (list Nat))) Nat))
  ((match x
     (case nil Z)
     (case (cons y z)
       (match z
         (case nil y)
         (case (cons x2 x3) (last z)))))))
(assert-not
  (forall ((xs (list Nat)) (x Nat))
    (=> (not (null xs)) (= (last (cons x xs)) (last xs)))))
(check-sat)
