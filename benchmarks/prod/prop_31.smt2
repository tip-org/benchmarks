; Source: Productive use of failure
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a2) (qrev ((x (list a2)) (x2 (list a2))) (list a2))))
  ((match x
     (case nil x2)
     (case (cons x3 xs) (as (qrev xs (cons x3 x2)) (list a2))))))
(declare-sort a3 0)
(assert
  (not
    (forall
      ((x4 (list a3)))
      (= (qrev (qrev x4 (as nil (list a3))) (as nil (list a3))) x4))))
(check-sat)
