; QuickSort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (t) (x ((p (=> t bool)) (y (list t))) (list t))))
  ((match y
     (case nil y)
     (case (cons z x2) (ite (@ p z) (cons z (x p x2)) (x p x2))))))
(define-funs-rec ((or2 ((y bool) (z bool)) bool)) ((ite y true z)))
(define-funs-rec
  ((par (t) (null ((y (list t))) bool)))
  ((match y
     (case nil true)
     (case (cons z x2) false))))
(define-funs-rec
  ((elem ((y int) (z (list int))) bool))
  ((match z
     (case nil false)
     (case (cons y2 ys) (or2 (= y y2) (elem y ys))))))
(define-funs-rec
  ((delete ((y int) (z (list int))) (list int)))
  ((match z
     (case nil z)
     (case (cons y2 ys) (ite (= y y2) ys (cons y2 (delete y ys)))))))
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
  ((isPermutation ((y (list int)) (z (list int))) bool))
  ((match y
     (case nil (null z))
     (case (cons x2 xs)
       (and2 (elem x2 z) (isPermutation xs (delete x2 z)))))))
(assert-not (forall ((y (list int))) (isPermutation (qsort y) y)))
(check-sat)
