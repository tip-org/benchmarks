; Source: Productive use of failure
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a) (qrev ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (as (qrev xs (cons z y)) (list a))))))
(assert-not
  (par (a)
    (forall ((x (list a)))
      (= (qrev (qrev x (as nil (list a))) (as nil (list a))) x))))
(check-sat)
