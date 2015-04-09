; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a2) (filter ((x (=> a2 bool)) (x2 (list a2))) (list a2))))
  ((match x2
     (case nil x2)
     (case
       (cons x3 xs)
       (ite
         (@ x x3) (cons x3 (as (filter x xs) (list a2)))
         (as (filter x xs) (list a2)))))))
(define-funs-rec
  ((par (a3) (append ((x4 (list a3)) (x5 (list a3))) (list a3))))
  ((match x4
     (case nil x5)
     (case (cons x6 xs2) (cons x6 (as (append xs2 x5) (list a3)))))))
(assert-not
  (par
    (a4)
    (forall
      ((p (=> a4 bool)) (xs3 (list a4)) (ys (list a4)))
      (=
        (filter p (append xs3 ys))
        (append (filter p xs3) (filter p ys))))))
(check-sat)
