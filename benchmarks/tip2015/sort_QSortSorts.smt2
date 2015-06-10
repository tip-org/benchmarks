; QuickSort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((ordered ((x (list Int))) Bool))
  ((match x
     (case nil true)
     (case (cons y z)
       (match z
         (case nil true)
         (case (cons y2 xs) (and (<= y y2) (ordered z))))))))
(define-funs-rec
  ((par (t) (filter ((p (=> t Bool)) (x (list t))) (list t))))
  ((match x
     (case nil (as nil (list t)))
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
     (case nil (as nil (list Int)))
     (case (cons y xs)
       (append
         (append (qsort (filter (lambda ((z Int)) (<= z y)) xs))
           (cons y (as nil (list Int))))
         (qsort (filter (lambda ((x2 Int)) (> x2 y)) xs)))))))
(assert-not (forall ((x (list Int))) (ordered (qsort x))))
(check-sat)
