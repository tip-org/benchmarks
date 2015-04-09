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
(define-funs-rec
  ((par (a2) (append ((x3 (list a2)) (x4 (list a2))) (list a2))))
  ((match x3
     (case nil x4)
     (case (cons x5 xs) (cons x5 (as (append xs x4) (list a2)))))))
(assert
  (not
    (forall
      ((x6 Nat) (xs2 (list Nat)))
      (= (last (append xs2 (cons x6 (as nil (list Nat))))) x6))))
(check-sat)
