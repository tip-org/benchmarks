; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a2) (null ((x (list a2))) bool)))
  ((match x
     (case nil true)
     (case (cons ipv ipv2) false))))
(define-funs-rec
  ((last ((x2 (list Nat))) Nat))
  ((match x2
     (case nil Z)
     (case
       (cons x3 ds)
       (match ds
         (case nil x3)
         (case (cons ipv3 ipv4) (last ds)))))))
(assert-not
  (forall
    ((xs (list Nat)) (x4 Nat))
    (=> (not (null xs)) (= (last (cons x4 xs)) (last xs)))))
(check-sat)
