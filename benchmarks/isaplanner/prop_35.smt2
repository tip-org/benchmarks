; Source: IsaPlanner test suite
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a) (dropWhile ((x (=> a bool)) (y (list a))) (list a))))
  ((match y
     (case nil y)
     (case (cons z xs)
       (ite (@ x z) (as (dropWhile x xs) (list a)) y)))))
(assert-not
  (par (a)
    (forall ((xs (list a)))
      (= (dropWhile (lambda ((x a)) false) xs) xs))))
(check-sat)
