; QuickSort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec ((or2 ((x bool) (y bool)) bool)) ((ite x true y)))
(define-funs-rec
  ((par (t) (null ((x (list t))) bool)))
  ((match x
     (case nil true)
     (case (cons y z) false))))
(define-funs-rec
  ((par (t) (filter ((p (=> t bool)) (x (list t))) (list t))))
  ((match x
     (case nil x)
     (case (cons y z)
       (ite (@ p y) (cons y (filter p z)) (filter p z))))))
(define-funs-rec
  ((elem ((x int) (y (list int))) bool))
  ((match y
     (case nil false)
     (case (cons z ys) (or2 (= x z) (elem x ys))))))
(define-funs-rec
  ((delete ((x int) (y (list int))) (list int)))
  ((match y
     (case nil y)
     (case (cons z ys) (ite (= x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(define-funs-rec
  ((qsort ((x (list int))) (list int)))
  ((match x
     (case nil x)
     (case (cons y xs)
       (append
       (append (qsort (filter (lambda ((z int)) (<= z y)) xs))
         (cons y (as nil (list int))))
         (qsort (filter (lambda ((x2 int)) (> x2 y)) xs)))))))
(define-funs-rec
  ((and2 ((x bool) (y bool)) bool)) ((ite x y false)))
(define-funs-rec
  ((isPermutation ((x (list int)) (y (list int))) bool))
  ((match x
     (case nil (null y))
     (case (cons z xs)
       (and2 (elem z y) (isPermutation xs (delete z y)))))))
(assert-not (forall ((x (list int))) (isPermutation (qsort x) x)))
(check-sat)
