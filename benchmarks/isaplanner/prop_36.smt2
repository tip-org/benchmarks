; Source: IsaPlanner test suite
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a) (takeWhile ((x (=> a bool)) (y (list a))) (list a))))
  ((match y
     (case nil y)
     (case (cons z xs)
       (ite
         (@ x z) (cons z (as (takeWhile x xs) (list a)))
         (as nil (list a)))))))
(assert-not
  (par (a)
    (forall ((xs (list a)))
      (= (takeWhile (lambda ((x a)) true) xs) xs))))
(check-sat)
