; QuickSort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((insert2 ((x Int) (y (list Int))) (list Int)))
  ((match y
     (case nil (cons x y))
     (case (cons z xs)
       (ite (<= x z) (cons x y) (cons z (insert2 x xs)))))))
(define-funs-rec
  ((isort ((x (list Int))) (list Int)))
  ((match x
     (case nil x)
     (case (cons y xs) (insert2 y (isort xs))))))
(define-funs-rec
  ((par (t) (filter ((p (=> t Bool)) (x (list t))) (list t))))
  ((match x
     (case nil x)
     (case (cons y z)
       (ite (@ p y) (cons y (filter p z)) (filter p z))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(define-funs-rec
  ((qsort ((x (list Int))) (list Int)))
  ((match x
     (case nil x)
     (case (cons y xs)
       (append
       (append (qsort (filter (lambda ((z Int)) (<= z y)) xs))
         (cons y (as nil (list Int))))
         (qsort (filter (lambda ((x2 Int)) (> x2 y)) xs)))))))
(assert-not (forall ((x (list Int))) (= (qsort x) (isort x))))
(check-sat)
