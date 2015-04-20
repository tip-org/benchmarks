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
(define-funs-rec
  ((par (a) (dropWhile ((x (=> a bool)) (y (list a))) (list a))))
  ((match y
     (case nil y)
     (case (cons z xs)
       (ite (@ x z) (as (dropWhile x xs) (list a)) y)))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (as (append xs y) (list a)))))))
(assert-not
  (par (a)
    (forall ((p (=> a bool)) (xs (list a)))
      (= (append (takeWhile p xs) (dropWhile p xs)) xs))))
(check-sat)
