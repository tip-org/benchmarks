; QuickSort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (t) (filter ((p (=> t bool)) (x (list t))) (list t))))
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
  ((ordered ((x (list int))) bool))
  ((match x
     (case nil true)
     (case (cons y z)
       (match z
         (case nil true)
         (case (cons y2 xs) (and2 (<= y y2) (ordered z))))))))
(assert-not (forall ((x (list int))) (ordered (qsort x))))
(check-sat)
