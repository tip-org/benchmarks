; QuickSort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (t) (x ((p (=> t bool)) (y (list t))) (list t))))
  ((match y
     (case nil y)
     (case (cons z x2) (ite (@ p z) (cons z (x p x2)) (x p x2))))))
(define-funs-rec
  ((insert2 ((y int) (z (list int))) (list int)))
  ((match z
     (case nil (cons y z))
     (case (cons y2 xs)
       (ite (<= y y2) (cons y z) (cons y2 (insert2 y xs)))))))
(define-funs-rec
  ((isort ((y (list int))) (list int)))
  ((match y
     (case nil y)
     (case (cons z xs) (insert2 z (isort xs))))))
(define-funs-rec
  ((par (a) (append ((y (list a)) (z (list a))) (list a))))
  ((match y
     (case nil z)
     (case (cons x2 xs) (cons x2 (append xs z))))))
(define-funs-rec
  ((qsort ((y (list int))) (list int)))
  ((match y
     (case nil y)
     (case (cons z xs)
       (append
       (append (qsort (x (lambda ((x2 int)) (<= x2 z)) xs))
         (cons z (as nil (list int))))
         (qsort (x (lambda ((x3 int)) (> x3 z)) xs)))))))
(assert-not (forall ((y (list int))) (= (qsort y) (isort y))))
(check-sat)
