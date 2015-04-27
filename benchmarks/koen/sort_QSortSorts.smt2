; QuickSort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (t) (x ((p (=> t bool)) (y (list t))) (list t))))
  ((match y
     (case nil y)
     (case (cons z x2) (ite (@ p z) (cons z (x p x2)) (x p x2))))))
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
(define-funs-rec
  ((and2 ((y bool) (z bool)) bool)) ((ite y z false)))
(define-funs-rec
  ((ordered ((y (list int))) bool))
  ((match y
     (case nil true)
     (case (cons z x2)
       (match x2
         (case nil true)
         (case (cons y2 xs) (and2 (<= z y2) (ordered x2))))))))
(assert-not (forall ((y (list int))) (ordered (qsort y))))
(check-sat)
