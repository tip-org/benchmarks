; Source: IsaPlanner test suite
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a) (filter ((x (=> a bool)) (y (list a))) (list a))))
  ((match y
     (case nil y)
     (case (cons z xs)
       (ite
         (@ x z) (cons z (as (filter x xs) (list a)))
         (as (filter x xs) (list a)))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (as (append xs y) (list a)))))))
(define-funs-rec
  ((par (a) (rev ((x (list a))) (list a))))
  ((match x
     (case nil x)
     (case (cons y xs)
       (append (as (rev xs) (list a)) (cons y (as nil (list a))))))))
(assert-not
  (par (a)
    (forall ((p (=> a bool)) (xs (list a)))
      (= (rev (filter p xs)) (filter p (rev xs))))))
(check-sat)
